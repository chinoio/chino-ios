//
//  Users.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Users: ChinoBaseAPI{
    
    public func getUser(user_id id: String, completion: @escaping (_ schema: User?) -> ()) {
        getResource(path: "/users/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let userString: NSDictionary = body!["user"] as! NSDictionary
                if let user = try? User(json: userString as! [String : Any]) {
                    completion(user)
                }
            }
        }
    }
    
    public func listUsers(user_schema_id id: String, completion: @escaping (_ schemas: GetUsersResponse?) -> ()) {
        getResource(path: "/user_schemas/"+id+"/users", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let users = try? GetUsersResponse(json: body!) {
                    completion(users)
                }
            }
        }
    }
    
    public func listUsers(user_schema_id id: String, offset: Int, limit: Int, completion: @escaping (_ schemas: GetUsersResponse?) -> ()) {
        getResource(path: "/user_schemas/"+id+"/users", offset: offset, limit: limit) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let users = try? GetUsersResponse(json: body!) {
                    completion(users)
                }
            }
        }
    }
    
    public func createUser(username: String, password: String, user_schema_id id: String, attributes: NSDictionary, completion: @escaping (_ schema: User?) -> ()) {
        let request = CreateUserRequest(username: username, password: password, attributes: attributes)
        postResource(path: "/user_schemas/\(id)/users", json: request.toString()) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let userString: NSDictionary = body!["user"] as! NSDictionary
                if let user = try? User(json: userString as! [String : Any]) {
                    completion(user)
                }
            }
        }
    }
    
    public func updateUser(username: String, password: String, user_id id: String, attributes: NSDictionary, completion: @escaping (_ schema: User?) -> ()) {
        let request = CreateUserRequest(username: username, password: password, attributes: attributes)
        putResource(path: "/users/\(id)", json: request.toString()) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let userString: NSDictionary = body!["user"] as! NSDictionary
                if let user = try? User(json: userString as! [String : Any]) {
                    completion(user)
                }
            }
        }
    }
    
    public func updateUser(user_id id: String, attributes: NSDictionary, completion: @escaping (_ schema: User?) -> ()) {
        let request = UpdateUserPatch(attributes: attributes)
        patchResource(path: "/users/\(id)", json: request.toString()) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let userString: NSDictionary = body!["user"] as! NSDictionary
                if let user = try? User(json: userString as! [String : Any]) {
                    completion(user)
                }
            }
        }
    }
    
    public func deleteUser(user_id id: String, force: Bool, completion: @escaping (_ result: String?) -> ()) {
        deleteResource(path: "/users/\(id)", force: force) {
            (result) in
            completion(result)
        }
    }
}
