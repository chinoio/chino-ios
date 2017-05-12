//
//  Permissions.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 04/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Permissions: ChinoBaseAPI{
    
    public func readPermissions(completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func readPermissions(offset: Int, limit: Int, completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms", offset: offset, limit: limit) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func readPermissionsOnaDocument(document_id id: String, completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms/documents/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func readPermissionsOnaDocument(document_id id: String, offset: Int, limit: Int, completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms/documents/"+id, offset: offset, limit: limit) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func readPermissionsOfaUser(user_id id: String, completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms/users/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func readPermissionsOfaUser(user_id id: String, offset: Int, limit: Int, completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms/users/"+id, offset: offset, limit: limit) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func readPermissionsOfaGroup(group_id id: String, completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms/groups/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func readPermissionsOfaGroup(group_id id: String, offset: Int, limit: Int, completion: @escaping (_ permissions: GetPermissionsResponse?) -> ()) {
        getResource(path: "/perms/groups/"+id, offset: offset, limit: limit) {
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let permissions = try? GetPermissionsResponse(json: body!) {
                    completion(permissions)
                }
            }
        }
    }
    
    public func permissionsOnResources(action: ActionValues, resource_type: ResourceValues, subject_type: SubjectValues, subject_id: String, rule: PermissionRule, completion: @escaping (_ result: String) -> ()){
        
        postResource(path: "/perms/\(action.returnValue(value: action))/\(resource_type.returnValue(value: resource_type))/\(subject_type.returnValue(value: subject_type))/\(subject_id)", json: rule.toString()){
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = json!["result"] as? String
                completion(result!)
            }
        }
    }
    
    public func permissionsOnaResource(action: ActionValues, resource_type: ResourceValues, resource_id: String, subject_type: SubjectValues, subject_id: String, rule: PermissionRule, completion: @escaping (_ result: String) -> ()){
        
        postResource(path: "/perms/\(action.returnValue(value: action))/\(resource_type.returnValue(value: resource_type))/\(resource_id)/\(subject_type.returnValue(value: subject_type))/\(subject_id)", json: rule.toString()){
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = json!["result"] as? String
                completion(result!)
            }
        }
    }
    
    public func permissionsOnResourceChildren(action: ActionValues, resource_type: ResourceValues, resource_id: String, resource_children: ResourceChildrenValues, subject_type: SubjectValues, subject_id: String, rule: PermissionRule, completion: @escaping (_ result: String) -> ()){
        
        postResource(path: "/perms/\(action.returnValue(value: action))/\(resource_type.returnValue(value: resource_type))/\(resource_id)/\(resource_children.returnValue(value: resource_children))/\(subject_type.returnValue(value: subject_type))/\(subject_id)", json: rule.toString()){
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = json!["result"] as? String
                completion(result!)
            }
        }
    }
}
