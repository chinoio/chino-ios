//
//  User.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class User {
    open var username: String
    open var user_id: String
    open var isActive: Bool
    open var lastUpdate: Date!
    open var insertDate: Date!
    open var attributes: [String: Any]!
    open var groups: [String]!
    
    init(){
        self.username = ""
        self.user_id = ""
        self.isActive = false
    }
    
    init(username: String, user_id: String, isActive: Bool, lastUpdate: Date, insertDate: Date, attributes: [String:Any], groups: [String]){
        self.username = username
        self.user_id = user_id
        self.isActive = isActive
        self.lastUpdate = lastUpdate
        self.insertDate = insertDate
        self.attributes = attributes
        self.groups = groups
    }
}

extension User {
    convenience init(json: [String: Any]) throws {
        
        // Extract attributes
        guard let attributes: [String:Any] = json["attributes"] as? [String:Any] else {
            throw SerializationError.missing("attributes")
        }
        
        // Extract groups
        guard let groups: [String] = json["groups"] as? [String] else {
            throw SerializationError.missing("groups")
        }
        
        // Extract username
        guard let username = json["username"] as? String else {
            throw SerializationError.missing("username")
        }
        
        // Extract user_id
        guard let user_id = json["user_id"] as? String else {
            throw SerializationError.missing("user_id")
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
        self.init(username: username, user_id: user_id, isActive: isActive, lastUpdate: lastUpdate!, insertDate: insertDate!, attributes: attributes, groups: groups)
    }
}
