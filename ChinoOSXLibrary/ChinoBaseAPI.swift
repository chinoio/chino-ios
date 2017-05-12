//
//  ChinoBaseAPI.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 10/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class ChinoBaseAPI{
    
    public typealias CompletionHandler = (Data?, Error?) -> Void
    let url: String
    
    public init(hostUrl url: String){
        self.url = url
    }
    
    open func getResource(path: String, offset: Int, limit: Int, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path+"?offset=\(offset)&limit=\(limit)")!
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
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }

    open func getResourceFullDocument(path: String, offset: Int, limit: Int, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path+"?full_document=true&offset=\(offset)&limit=\(limit)")!
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
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }
    
    open func postResource(path: String, json: String, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        request.httpBody = json.data(using: .utf8)
        print(json)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }
    
    open func postResource(path: String, json: String, offset: Int, limit: Int, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path+"?offset=\(offset)&limit=\(limit)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        request.httpBody = json.data(using: .utf8)
        print(json)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }
    
    open func postResource(path: String, json: Data, with_auth: Bool, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if(with_auth) {
            request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        }
        request.httpBody = json
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }
    
    open func putResource(path: String, json: String, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        request.httpBody = json.data(using: .utf8)
        print(json)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }
    
    open func putResource(path: String, json: NSData, length: Int, offset: Int, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        request.setValue(String(offset), forHTTPHeaderField: "offset")
        request.setValue(String(length), forHTTPHeaderField: "length")
        request.httpBody = json as Data
        print(json)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }
    
    open func patchResource(path: String, json: String, completion: @escaping CompletionHandler){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: self.url+path)!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        request.httpBody = json.data(using: .utf8)
        print(json)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    print(dataString ?? "problem getting value")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        print("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
            // Call your closure
            completion(data , error)
        }
        task.resume()
    }
    
    open func deleteResource(path: String, force: Bool, completion: @escaping (_ result: String?) -> ()){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url: URL
        if(force){
            url = URL(string: self.url+path+"?force=true")!
        } else {
            url = URL(string: self.url+path)!
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(ChinoAPI.authentication, forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // Everything in this block is happening on a separate thread.
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // this won't happen until the data comes back from the remote call.
                    completion("success")
                } else {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = json!["message"] as? String
                        completion("Chino Error: \(message ?? "problem unwrapping error message")!")
                    }
                }
            }
        }
        task.resume()
    }

}
