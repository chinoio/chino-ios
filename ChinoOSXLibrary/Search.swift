//
//  Search.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 02/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Search: ChinoBaseAPI{
    
    public func searchDocuments(search_request: SearchRequest, schema_id id: String, completion: @escaping (_ schemas: GetDocumentsResponse?) -> ()) {
        postResource(path: "/search/documents/"+id, json: search_request.toString(), offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let documents = try? GetDocumentsResponse(json: body!) {
                    completion(documents)
                }
            }
        }
    }
    
    public func searchDocuments(search_request: SearchRequest, schema_id id: String, offset: Int, limit: Int, completion: @escaping (_ schemas: GetDocumentsResponse?) -> ()) {
        postResource(path: "/search/documents/"+id, json: search_request.toString(), offset: offset, limit: limit) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let documents = try? GetDocumentsResponse(json: body!) {
                    completion(documents)
                }
            }
        }
    }
    
    public func searchUsers(search_request: SearchRequest, user_schema_id id: String, completion: @escaping (_ schemas: GetUsersResponse?) -> ()) {
        postResource(path: "/search/users/"+id, json: search_request.toString(), offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let users = try? GetUsersResponse(json: body!) {
                    completion(users)
                }
            }
        }
    }
    
    public func searchUsers(search_request: SearchRequest, user_schema_id id: String, offset: Int, limit: Int, completion: @escaping (_ schemas: GetUsersResponse?) -> ()) {
        postResource(path: "/search/users/"+id, json: search_request.toString(), offset: offset, limit: limit) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let users = try? GetUsersResponse(json: body!) {
                    completion(users)
                }
            }
        }
    }
}
