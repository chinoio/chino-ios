//
//  Documents.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 24/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Documents: ChinoBaseAPI{
    
    public func getDocument(document_id id: String, completion: @escaping (_ inner: () throws -> Document) -> Void) {
        getResource(path: "/documents/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let documentString: NSDictionary = body!["document"] as! NSDictionary
                if let document = try? Document(json: documentString as! [String : Any]) {
                    completion({document})
                }
            }
        }
    }
    
    public func listDocumentsWithContent(schema_id id: String, completion: @escaping (_ inner: () throws -> GetDocumentsResponseFullContent) -> Void) {
        getResourceFullDocument(path: "/schemas/"+id+"/documents", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let documents = try? GetDocumentsResponseFullContent(json: body!) {
                    completion({documents})
                }
            }
        }
    }
    
    public func listDocumentsWithoutContent(schema_id id: String, completion: @escaping (_ inner: () throws -> GetDocumentsResponse) -> Void) {
        getResource(path: "/schemas/"+id+"/documents", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let documents = try? GetDocumentsResponse(json: body!) {
                    completion({documents})
                }
            }
        }
    }
    
    public func listDocumentsWithContent(schema_id id: String, offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetDocumentsResponseFullContent) -> Void) {
        getResourceFullDocument(path: "/schemas/"+id+"/documents", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let documents = try? GetDocumentsResponseFullContent(json: body!) {
                    completion({documents})
                }
            }
        }
    }
    
    public func listDocumentsWithoutContent(schema_id id: String, offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetDocumentsResponse) -> Void) {
        getResource(path: "/schemas/"+id+"/documents", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let documents = try? GetDocumentsResponse(json: body!) {
                    completion({documents})
                }
            }
        }
    }
    
    public func createDocument(schema_id id: String, content: NSDictionary, completion: @escaping (_ inner: () throws -> CreateDocumentResponse) -> Void) {
        let request = CreateDocumentRequest(content: content)
        postResource(path: "/schemas/\(id)/documents", json: request.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let documentString: NSDictionary = body!["document"] as! NSDictionary
                if let document = try? CreateDocumentResponse(json: documentString as! [String : Any]) {
                    completion({document})
                }
            }
        }
    }
    
    public func updateDocument(document_id id: String, content: NSDictionary, completion: @escaping (_ inner: () throws -> CreateDocumentResponse) -> Void) {
        let request = CreateDocumentRequest(content: content)
        putResource(path: "/documents/\(id)", json: request.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as?       [String: Any] {
                let body = json!["data"] as? [String:Any]
                let documentString: NSDictionary = body!["document"] as! NSDictionary
                if let document = try? CreateDocumentResponse(json: documentString as! [String : Any]) {
                    completion({document})
                }
            }
        }
    }
    
    public func deleteDocument(document_id id: String, force: Bool, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/documents/\(id)", force: force) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
}
