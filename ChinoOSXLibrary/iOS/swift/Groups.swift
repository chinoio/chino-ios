//
//  Groups.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Groups: ChinoBaseAPI{
    
    public func getGroup(group_id id: String, completion: @escaping (_ inner: () throws -> Group) -> Void) {
        getResource(path: "/groups/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let groupString: NSDictionary = body!["group"] as! NSDictionary
                if let group = try? Group(json: groupString as! [String : Any]) {
                    completion({group})
                }
            }
        }
    }
    
    public func listGroups(completion: @escaping (_ inner: () throws -> GetGroupsResponse) -> Void) {
        getResource(path: "/groups", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let groups = try? GetGroupsResponse(json: body!) {
                    completion({groups})
                }
            }
        }
    }
    
    public func listGroups(offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetGroupsResponse) -> Void) {
        getResource(path: "/groups", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let groups = try? GetGroupsResponse(json: body!) {
                    completion({groups})
                }
            }
        }
    }
    
    public func createGroup(groupName: String, attributes: NSDictionary, completion: @escaping (_ inner: () throws -> Group) -> Void) {
        let request = CreateGroupRequest(groupName: groupName, attributes: attributes)
        postResource(path: "/groups", json: request.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let groupString: NSDictionary = body!["group"] as! NSDictionary
                if let group = try? Group(json: groupString as! [String : Any]) {
                    completion({group})
                }
            }
        }
    }
    
    public func updateGroup(group_id id: String, groupName: String, attributes: NSDictionary, completion: @escaping (_ inner: () throws -> Group) -> Void) {
        let request = CreateGroupRequest(groupName: groupName, attributes: attributes)
        putResource(path: "/groups/\(id)", json: request.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let groupString: NSDictionary = body!["group"] as! NSDictionary
                if let group = try? Group(json: groupString as! [String : Any]) {
                    completion({group})
                }
            }
        }
    }
    
    public func deleteGroup(group_id id: String, force: Bool, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/groups/\(id)", force: force) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
    
    //----------------------GROUP MEMBERSHIP------------------------------
    
    public func addUserToGroup(user_id: String, group_id: String, completion: @escaping (_ inner: () throws -> String) -> Void) {
        postResource(path: "/groups/\(group_id)/users/\(user_id)", json: "") {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = json!["result"] as? String
                completion({result!})
            }
        }
    }
    
    public func addUserSchemaToGroup(user_schema_id: String, group_id: String, completion: @escaping (_ inner: () throws -> String) -> Void) {
        postResource(path: "/groups/\(group_id)/user_schemas/\(user_schema_id)", json: "") {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = json!["result"] as? String
                completion({result!})
            }
        }
    }
    
    public func removeUserFromGroup(user_id: String, group_id: String, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/groups/\(group_id)/users/\(user_id)", force: false) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
    
    public func removeUserSchemaFromGroup(user_schema_id: String, group_id: String, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/groups/\(group_id)/user_schemas/\(user_schema_id)", force: false) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
}
