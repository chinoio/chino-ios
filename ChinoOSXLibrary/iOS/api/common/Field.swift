//
//  Field.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Field {
    open var type: String
    open var name: String
    open var indexed: Bool
    
    public init(){
        self.type=""
        self.name=""
        self.indexed=false
    }
    
    public init(type: String, name: String){
        self.type=type
        self.name=name
        self.indexed=false
    }
    
    public init(type: String, name: String, indexed: Bool){
        self.type=type
        self.name=name
        self.indexed=indexed
    }
    
    func toString() -> String {
        return "{ \"name\": \"\(self.name)\", \"type\": \"\(self.type)\", \"indexed\": \(self.indexed) }"
    }
}

extension Field {
    convenience init(json: [String: Any]) throws {
        
        // Extract type
        guard let type = json["type"] as? String else {
            throw SerializationError.missing("type")
        }
        
        // Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract indexed
        guard let indexed = json["indexed"] as? Bool else {
            throw SerializationError.missing("indexed")
        }
        
        // Initialize properties
        self.init(type: type, name: name, indexed: indexed)
    }
}
