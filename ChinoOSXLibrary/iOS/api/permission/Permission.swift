//
//  Permission.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Permission {
    
    open var access: String
    open var parent_id: String
    open var resource_id: String
    open var resource_type: String
    open var permission: NSDictionary!
    
    init(){
        self.access=""
        self.parent_id = ""
        self.resource_id=""
        self.resource_type=""
    }
    
    init(access: String, parent_id: String, resource_id: String, resource_type: String, permission: NSDictionary){
        self.access=access
        self.parent_id=parent_id
        self.resource_id=resource_id
        self.resource_type=resource_type
        self.permission=permission
    }
}

extension Permission {
    convenience init(json: [String: Any]) throws {
        
        // Extract access
        guard let access = json["access"] as? String else {
            throw SerializationError.missing("access")
        }
        
        // Extract parent_id
        guard let parent_id = json["parent_id"] as? String else {
            throw SerializationError.missing("parent_id")
        }
        
        // Extract resource_id
        guard let resource_id = json["resource_id"] as? String else {
            throw SerializationError.missing("resource_id")
        }
        
        // Extract resource_type
        guard let resource_type = json["resource_type"] as? String else {
            throw SerializationError.missing("resource_type")
        }
        
        // Extract permission
        guard let permission = json["permission"] as? NSDictionary else {
            throw SerializationError.missing("permission")
        }
        
        // Initialize properties
        self.init(access: access, parent_id: parent_id, resource_id: resource_id, resource_type: resource_type, permission: permission)
    }
}
