//
//  Blobs.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 05/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation
import CommonCrypto

open class Blobs: ChinoBaseAPI{
    
    let chunkSize = 1024*1024
    
    public func uploadBlob(path: String, document_id: String, field: String, file_name: String, completion: @escaping (_ inner: () throws -> Blob) -> Void){
        initUpload(document_id: document_id, field: field, file_name: file_name) { (createBlobResponse) in
    
            var blobResponse: CreateBlobResponse!
            do {
                blobResponse = try createBlobResponse()
            } catch let error{
                completion({throw error})
            }
            
            var bytes = [UInt8]()
            var currentFilePosition = 0
            var blobChunkResponse: CreateBlobResponse!
            var check = true
            var rng: NSRange
            
            if let data = NSData(contentsOfFile: path+file_name) {
                
                var distanceFromEnd = data.length
                var buffer = [UInt8]()
                
                while(currentFilePosition < data.length) {
                    
                    distanceFromEnd = data.length - currentFilePosition
                    if distanceFromEnd > self.chunkSize {
                        rng = NSRange(location: currentFilePosition, length: self.chunkSize)
                        buffer = [UInt8](repeating: 0, count: self.chunkSize)
                        data.getBytes(&buffer, range: rng)
                    } else {
                        rng = NSRange(location: currentFilePosition, length: distanceFromEnd)
                        buffer = [UInt8](repeating: 0, count: distanceFromEnd)
                        data.getBytes(&buffer, range: rng)
                    }
                    
                    bytes = buffer
                    
                    self.uploadChunk(upload_id: (blobResponse.upload_id), chunk_data: bytes, offset: currentFilePosition, length: bytes.count) { (response) in
                        do {
                            blobChunkResponse = try response()
                            check = false
                        } catch let error{
                            completion({throw error})
                        }
                    }
                    while(check){}
                    check = true
                    currentFilePosition = currentFilePosition + bytes.count
                }
                self.commitUpload(upload_id: (blobChunkResponse.upload_id)) { (blob) in
                    completion(blob)
                    check = false
                }
                while(check){}
            }
        }
    }
    
    public func initUpload(document_id: String, field: String, file_name: String, completion: @escaping (_ inner: () throws -> CreateBlobResponse) -> Void) {
        let createBlobRequest = CreateBlobRequest(document_id: document_id, field: field, file_name: file_name)
        postResource(path: "/blobs", json: createBlobRequest.toString()) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let appString: NSDictionary = body!["blob"] as! NSDictionary
                if error != nil {
                    completion({throw error!})
                } else if let blob = try? CreateBlobResponse(json: appString as! [String : Any]) {
                    completion({blob})
                }
            }
        }
    }
    
    public func uploadChunk(upload_id id: String, chunk_data: [UInt8], offset: Int, length: Int, completion: @escaping (_ inner: () throws -> CreateBlobResponse) -> Void) {
        let data = NSData(bytes: chunk_data, length: chunk_data.count)
        putResource(path: "/blobs/\(id)", json: data, length: length, offset: offset) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let appString: NSDictionary = body!["blob"] as! NSDictionary
                if error != nil {
                    completion({throw error!})
                } else if let blob = try? CreateBlobResponse(json: appString as! [String : Any]) {
                    completion({blob})
                }
            }
        }
    }
    
    public func commitUpload(upload_id: String, completion: @escaping (_ inner: () throws -> Blob) -> Void){
        var dict = NSDictionary()
        dict = ["upload_id": upload_id]
        postResource(path: "/blobs/commit", json: dict.returnJson()) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let appString: NSDictionary = body!["blob"] as! NSDictionary
                if error != nil {
                    completion({throw error!})
                } else if let blob = try? Blob(json: appString as! [String : Any]) {
                    completion({blob})
                }
            }
        }
    }
    
    public func get(blob_id id: String, destination: String, completion: @escaping (_ inner: () throws -> GetBlobResponse) -> Void){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+"/blobs/\(id)")!
        let path = (destination as NSString).expandingTildeInPath
        var blobResponse = GetBlobResponse()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    do {
                     try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print(error.localizedDescription);
                    }
                    var filename = httpResponse.allHeaderFields["Content-Disposition"] as! String
                    let index = filename.index(filename.startIndex, offsetBy: 21)
                    filename = filename.substring(from: index)
                    let url = URL(fileURLWithPath:path+"/\(filename)")
                    print(url)
                    do {
                        try data?.write(to: url)
                    } catch {
                        print(error)
                    }
                    let md5 = self.MD5(data: data!)
                    let sha1 = self.SHA1(data: data!)
                    blobResponse = GetBlobResponse(size: (data?.count)!, file_name: filename, path: path, sha1: sha1, md5: md5)
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                        completion({throw error!})
                    }
                }
            }
            // Call your closure
            completion({blobResponse})
        }
        task.resume()
    }
    
    public func deleteBlob(blob_id id: String, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/blobs/\(id)", force: false) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
    
    func MD5(data: Data) -> String {
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            data.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(data.count), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func SHA1(data: Data) -> String {
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
