//
//  UserSchema.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class UserSchema {
    open var user_schema_id: String
    open var description: String
    open var isActive: Bool
    open var lastUpdate: Date!
    open var insertDate: Date!
    open var structure: UserSchemaStructure
    
    init(){
        self.user_schema_id = ""
        self.description = ""
        self.isActive = false
        self.structure = UserSchemaStructure()
    }
    
    init(user_schema_id: String, description: String, isActive: Bool, lastUpdate: Date, insertDate: Date, structure: UserSchemaStructure){
        self.user_schema_id = user_schema_id
        self.description = description
        self.isActive = isActive
        self.lastUpdate = lastUpdate
        self.insertDate = insertDate
        self.structure = structure
    }
}

extension UserSchema {
    convenience init(json: [String: Any]) throws {
        
        // Extract structure
        let structureString: NSDictionary = json["structure"] as! NSDictionary
        guard let structure = try? UserSchemaStructure(json: structureString as! [String : Any]) else {
            throw SerializationError.missing("structure")
        }
        
        // Extract schema_id
        guard let user_schema_id = json["user_schema_id"] as? String else {
            throw SerializationError.missing("user_schema_id")
        }
        
        // Extract description
        guard let description = json["description"] as? String else {
            throw SerializationError.missing("description")
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
        self.init(user_schema_id: user_schema_id, description: description, isActive: isActive, lastUpdate: lastUpdate!, insertDate: insertDate!, structure: structure)
    }
}
