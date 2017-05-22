//
//  Document.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 21/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Document {
    open var document_id: String
    open var repository_id: String
    open var schema_id: String
    open var isActive: Bool
    open var lastUpdate: Date!
    open var insertDate: Date!
    open var content: NSDictionary!
    
    init(){
        self.document_id = ""
        self.repository_id = ""
        self.schema_id = ""
        self.isActive = false
        self.content = NSDictionary()
    }
    
    init(document_id: String, repository_id: String, schema_id: String, isActive: Bool, lastUpdate: Date, insertDate: Date, content: NSDictionary){
        self.repository_id = repository_id
        self.schema_id = schema_id
        self.document_id = document_id
        self.isActive = isActive
        self.lastUpdate = lastUpdate
        self.insertDate = insertDate
        self.content = content
    }
}

extension Document {
    convenience init(json: [String: Any]) throws {
        
        // Extract content
        guard let content: NSDictionary = json["content"] as? NSDictionary else {
            throw SerializationError.missing("content")
        }
        
        // Extract document_id
        guard let document_id = json["document_id"] as? String else {
            throw SerializationError.missing("document_id")
        }
        
        // Extract schema_id
        guard let schema_id = json["schema_id"] as? String else {
            throw SerializationError.missing("schema_id")
        }
        
        // Extract repository_id
        guard let repository_id = json["repository_id"] as? String else {
            throw SerializationError.missing("repository_id")
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
        self.init(document_id: document_id, repository_id: repository_id, schema_id: schema_id, isActive: isActive, lastUpdate: lastUpdate!, insertDate: insertDate!, content: content)
    }
}
