//
//  Repositories.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 10/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Repositories: ChinoBaseAPI{
    
    public func getRepository(repository_id id: String, completion: @escaping (_ inner: () throws -> Repository) -> Void) {
        getResource(path: "/repositories/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let reposString: NSDictionary = body!["repository"] as! NSDictionary
                if let repository = try? Repository(json: reposString as! [String : Any]) {
                    completion({repository})
                }
            }
        }
    }
    
    public func listRepositories(completion: @escaping (_ inner: () throws -> GetRepositoriesResponse) -> Void) {
        getResource(path: "/repositories", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let repositories = try? GetRepositoriesResponse(json: body!) {
                    completion({repositories})
                }
            }
        }
    }
    
    public func listRepositories(offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetRepositoriesResponse) -> Void) {
        getResource(path: "/repositories", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let repositories = try? GetRepositoriesResponse(json: body!) {
                    completion({repositories})
                }
            }
        }
    }
    
    public func createRepository(description: String, completion: @escaping (_ inner: () throws -> Repository) -> Void) {
        let createRepoRequest = "{\"description\": \"\(description)\"}"
        postResource(path: "/repositories", json: createRepoRequest) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let reposString: NSDictionary = body!["repository"] as! NSDictionary
                if let repository = try? Repository(json: reposString as! [String : Any]) {
                    completion({repository})
                }
            }
        }
    }
    
    public func updateRepository(repository_id id: String, description: String, completion: @escaping (_ inner: () throws -> Repository) -> Void) {
        let updateRepoRequest = "{\"description\": \"\(description)\"}"
        putResource(path: "/repositories/\(id)", json: updateRepoRequest) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let reposString: NSDictionary = body!["repository"] as! NSDictionary
                if let repository = try? Repository(json: reposString as! [String : Any]) {
                    completion({repository})
                }
            }
        }
    }
    
    public func deleteRepository(repository_id id: String, force: Bool, completion: @escaping (_ result: String?) -> ()) {
        deleteResource(path: "/repositories/\(id)", force: force) {
            (result) in
                completion(result)
        }
    }
}
