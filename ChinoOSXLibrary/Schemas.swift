//
//  Schemas.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 19/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Schemas: ChinoBaseAPI{
    
    public func getSchema(schema_id id: String, completion: @escaping (_ inner: () throws -> Schema) -> Void) {
        getResource(path: "/schemas/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let schemaString: NSDictionary = body!["schema"] as! NSDictionary
                if let schema = try? Schema(json: schemaString as! [String : Any]) {
                    completion({schema})
                }
            }
        }
    }
    
    public func listSchemas(repository_id id: String, completion: @escaping (_ inner: () throws -> GetSchemasResponse) -> Void) {
        getResource(path: "/repositories/"+id+"/schemas", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let schemas = try? GetSchemasResponse(json: body!) {
                    completion({schemas})
                }
            }
        }
    }
    
    public func listSchemas(repository_id id: String, offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetSchemasResponse) -> Void) {
        getResource(path: "/repositories/"+id+"/schemas", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let schemas = try? GetSchemasResponse(json: body!) {
                    completion({schemas})
                }
            }
        }
    }
    
    public func createSchema(repository_id id: String, description: String, structure: SchemaStructure, completion: @escaping (_ inner: () throws -> Schema) -> Void) {
        let request = SchemaRequest(description: description, structure: structure)
        postResource(path: "/repositories/\(id)/schemas", json: request.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let schemaString: NSDictionary = body!["schema"] as! NSDictionary
                if let schema = try? Schema(json: schemaString as! [String : Any]) {
                    completion({schema})
                }
            }
        }
    }
    
    public func updateSchema(schema_id id: String, description: String, structure: SchemaStructure, completion: @escaping (_ inner: () throws -> Schema) -> Void) {
        let request = SchemaRequest(description: description, structure: structure)
        putResource(path: "/schemas/\(id)", json: request.toString()) {
        (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as?       [String: Any] {
                let body = json!["data"] as? [String:Any]
                let schemaString: NSDictionary = body!["schema"] as! NSDictionary
                if let schema = try? Schema(json: schemaString as! [String : Any]) {
                    completion({schema})
                }
            }
        }
    }
    
    public func deleteSchema(schema_id id: String, force: Bool, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/schemas/\(id)", force: force) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
}
