//
//  Collections.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Collections: ChinoBaseAPI{
    
    public func getCollection(collection_id id: String, completion: @escaping (_ inner: () throws -> ChinoCollection) -> Void) {
        getResource(path: "/collections/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let collectionString: NSDictionary = body!["collection"] as! NSDictionary
                if let collection = try? ChinoCollection(json: collectionString as! [String : Any]) {
                    completion({collection})
                }
            }
        }
    }
    
    public func listCollections(completion: @escaping (_ inner: () throws -> GetCollectionsResponse) -> Void) {
        getResource(path: "/collections", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let collections = try? GetCollectionsResponse(json: body!) {
                    completion({collections})
                }
            }
        }
    }
    
    public func listCollections(offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetCollectionsResponse) -> Void) {
        getResource(path: "/collections", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let collections = try? GetCollectionsResponse(json: body!) {
                    completion({collections})
                }
            }
        }
    }
    
    public func createCollection(name: String, completion: @escaping (_ inner: () throws -> ChinoCollection) -> Void) {
        let createCollectionRequest = "{\"name\": \"\(name)\"}"
        postResource(path: "/collections", json: createCollectionRequest) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let collectionString: NSDictionary = body!["collection"] as! NSDictionary
                if let collection = try? ChinoCollection(json: collectionString as! [String : Any]) {
                    completion({collection})
                }
            }
        }
    }
    
    public func updateCollection(collection_id id: String, name: String, completion: @escaping (_ inner: () throws -> ChinoCollection) -> Void) {
        let updateCollectionRequest = "{\"name\": \"\(name)\"}"
        putResource(path: "/collections/\(id)", json: updateCollectionRequest) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let collectionString: NSDictionary = body!["collection"] as! NSDictionary
                if let collection = try? ChinoCollection(json: collectionString as! [String : Any]) {
                    completion({collection})
                }
            }
        }
    }
    
    public func deleteCollection(collection_id id: String, force: Bool, completion: @escaping (_ result: String?) -> ()) {
        deleteResource(path: "/collections/\(id)", force: force) {
            (result) in
            completion(result)
        }
    }
    
    public func addDocument(document_id: String, collection_id: String, completion: @escaping (_ result: String?) -> ()) {
        postResource(path: "/collections/\(collection_id)/documents/\(document_id)", json: "") {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = json!["result"] as? String
                completion(result)
            }
        }
    }
    
    public func removeDocument(document_id: String, collection_id: String, completion: @escaping (_ result: String?) -> ()) {
        deleteResource(path: "/collections/\(collection_id)/documents/\(document_id)", force: false) {
            (result) in
            completion(result)
        }
    }
    
    public func listDocuments(collection_id id: String, offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetDocumentsResponse) -> Void) {
        getResource(path: "/collections/"+id+"/documents", offset: offset, limit: limit) {
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
    
    public func listDocuments(collection_id id: String, completion: @escaping (_ inner: () throws -> GetDocumentsResponse) -> Void) {
        getResource(path: "/collections/"+id+"/documents", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
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
}
