//
//  Repository.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 10/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Repository {
    open var repository_id: String
    open var description: String
    open var isActive: Bool
    open var lastUpdate: Date!
    open var insertDate: Date!
    
    init(){
        self.repository_id = ""
        self.description = ""
        self.isActive = false
    }
    
    init(repository_id: String, description: String, isActive: Bool, lastUpdate: Date, insertDate: Date){
        self.repository_id = repository_id
        self.description = description
        self.isActive = isActive
        self.lastUpdate = lastUpdate
        self.insertDate = insertDate
    }
}

extension Repository {
    convenience init(json: [String: Any]) throws {
        
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
        
        //TODO: validate date format!!!!!!!!!!!!!!
        
        // Extract insertDate
        guard let insertDateString = json["insert_date"] as? String else {
            throw SerializationError.missing("insert_date")
        }
        
        let insertDate = insertDateString.dateFromISO8601
        
//        print("repo_id: \(repository_id)")
//        print("description: \(description)")
//        print("is_active: \(isActive)")
//        print(lastUpdate ?? "no last_update")
//        print(insertDate ?? "no insert_date")
        
        // Initialize properties
        self.init(repository_id: repository_id, description: description, isActive: isActive, lastUpdate:  lastUpdate!, insertDate: insertDate!)
    }
}
