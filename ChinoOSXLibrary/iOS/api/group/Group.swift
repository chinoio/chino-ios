//
//  Group.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Group {
    open var groupName: String
    open var group_id: String
    open var isActive: Bool
    open var lastUpdate: Date!
    open var insertDate: Date!
    open var attributes: NSDictionary!
    
    init(){
        self.groupName = ""
        self.group_id = ""
        self.isActive = false
        self.attributes = NSDictionary()
    }
    
    init(groupName: String, group_id: String, isActive: Bool, lastUpdate: Date, insertDate: Date, attributes: NSDictionary){
        self.groupName = groupName
        self.group_id = group_id
        self.isActive = isActive
        self.lastUpdate = lastUpdate
        self.insertDate = insertDate
        self.attributes = attributes
    }
}

extension Group {
    convenience init(json: [String: Any]) throws {
        
        // Extract attributes
        guard let attributes: NSDictionary = json["attributes"] as? NSDictionary else {
            throw SerializationError.missing("attributes")
        }
        
        // Extract groupName
        guard let groupName = json["group_name"] as? String else {
            throw SerializationError.missing("group_name")
        }
        
        // Extract group_id
        guard let group_id = json["group_id"] as? String else {
            throw SerializationError.missing("group_id")
        }
        
        // Extract isActive
        guard let isActive = json["is_active"] as? Bool else {
            throw SerializationError.missing("is_active")
        }
        
        // Extract lastUpdate
        guard let lastUpdateString = json["last_update"] as? String else {
            throw SerializationError.missing("last_update")
        }
        
        let lastUpdate = lastUpdateString.dateFromISO8601
        
        // Extract insertDate
        guard let insertDateString = json["insert_date"] as? String else {
            throw SerializationError.missing("insert_date")
        }
        
        let insertDate = insertDateString.dateFromISO8601
        
        // Initialize properties
        self.init(groupName: groupName, group_id: group_id, isActive: isActive, lastUpdate: lastUpdate!, insertDate: insertDate!, attributes: attributes)
    }
}
