//
//  Schema.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 18/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Schema {
    open var repository_id: String
    open var schema_id: String
    open var description: String
    open var isActive: Bool
    open var lastUpdate: Date!
    open var insertDate: Date!
    open var structure: SchemaStructure
    
    init(){
        self.repository_id = ""
        self.schema_id = ""
        self.description = ""
        self.isActive = false
        self.structure = SchemaStructure()
    }
    
    init(repository_id: String, schema_id: String, description: String, isActive: Bool, lastUpdate: Date, insertDate: Date, structure: SchemaStructure){
        self.repository_id = repository_id
        self.schema_id = schema_id
        self.description = description
        self.isActive = isActive
        self.lastUpdate = lastUpdate
        self.insertDate = insertDate
        self.structure = structure
    }
}

extension Schema {
    convenience init(json: [String: Any]) throws {
        
        // Extract structure
        let structureString: NSDictionary = json["structure"] as! NSDictionary
        guard let structure = try? SchemaStructure(json: structureString as! [String : Any]) else {
            throw SerializationError.missing("structure")
        }
        
        // Extract schema_id
        guard let schema_id = json["schema_id"] as? String else {
            throw SerializationError.missing("schema_id")
        }
        
        // Extract repository_id
        guard let repository_id = json["repository_id"] as? String else {
            throw SerializationError.missing("repository_id")
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
        self.init(repository_id: repository_id, schema_id: schema_id, description: description, isActive: isActive, lastUpdate: lastUpdate!, insertDate: insertDate!, structure: structure)
    }
}
