//
//  ChinoCollection.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class ChinoCollection {
    open var name: String
    open var collection_id: String
    open var isActive: Bool
    open var lastUpdate: Date!
    open var insertDate: Date!
    
    init(){
        self.name = ""
        self.collection_id = ""
        self.isActive = false
    }
    
    init(name: String, collection_id: String, isActive: Bool, lastUpdate: Date, insertDate: Date){
        self.name = name
        self.collection_id = collection_id
        self.isActive = isActive
        self.lastUpdate = lastUpdate
        self.insertDate = insertDate
    }
}

extension ChinoCollection {
    convenience init(json: [String: Any]) throws {
        
        // Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract collection_id
        guard let collection_id = json["collection_id"] as? String else {
            throw SerializationError.missing("collection_id")
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
        self.init(name: name, collection_id: collection_id, isActive: isActive, lastUpdate: lastUpdate!, insertDate: insertDate!)
    }
}
