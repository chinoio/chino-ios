//
//  UserSchemas.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class UserSchemas: ChinoBaseAPI{
    
    public func getUserSchema(user_schema_id id: String, completion: @escaping (_ inner: () throws -> UserSchema) -> Void) {
        getResource(path: "/user_schemas/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let user_schemaString: NSDictionary = body!["user_schema"] as! NSDictionary
                if let user_schema = try? UserSchema(json: user_schemaString as! [String : Any]) {
                    completion({user_schema})
                }
            }
        }
    }
    
    public func listUserSchemas(completion: @escaping (_ inner: () throws -> GetUserSchemasResponse) -> Void) {
        getResource(path: "/user_schemas", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let user_schemas = try? GetUserSchemasResponse(json: body!) {
                    completion({user_schemas})
                }
            }
        }
    }
    
    public func listUserSchemas(offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetUserSchemasResponse) -> Void) {
        getResource(path: "/user_schemas", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let user_schemas = try? GetUserSchemasResponse(json: body!) {
                    completion({user_schemas})
                }
            }
        }
    }
    
    public func createUserSchema(description: String, structure: UserSchemaStructure, completion: @escaping (_ inner: () throws -> UserSchema) -> Void) {
        let request = UserSchemaRequest(description: description, structure: structure)
        postResource(path: "/user_schemas", json: request.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let user_schemaString: NSDictionary = body!["user_schema"] as! NSDictionary
                if let user_schema = try? UserSchema(json: user_schemaString as! [String : Any]) {
                    completion({user_schema})
                }
            }
        }
    }
    
    public func updateUserSchema(user_schema_id id: String, description: String, structure: UserSchemaStructure, completion: @escaping (_ inner: () throws -> UserSchema) -> Void) {
        let request = UserSchemaRequest(description: description, structure: structure)
        putResource(path: "/user_schemas/\(id)", json: request.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as?       [String: Any] {
                let body = json!["data"] as? [String:Any]
                let user_schemaString: NSDictionary = body!["user_schema"] as! NSDictionary
                if let user_schema = try? UserSchema(json: user_schemaString as! [String : Any]) {
                    completion({user_schema})
                }
            }
        }
    }
    
    public func deleteUserSchema(user_schema_id id: String, force: Bool, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/user_schemas/\(id)", force: force) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
}
