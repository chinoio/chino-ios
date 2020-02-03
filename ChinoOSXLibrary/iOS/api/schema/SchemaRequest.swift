//
//  SchemaRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 19/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class SchemaRequest {
    
    open var description: String
    open var structure: SchemaStructure
    
    init(){
        self.description = ""
        self.structure = SchemaStructure()
    }
    
    init(description: String, structure: SchemaStructure){
        self.description = description
        self.structure = structure
    }
    
    func toString() -> String {
        var str: String = "{ \"description\": \"\(description)\", "
        str.append("\"structure\": { \(structure.toString()) } }")
        return str
    }
}

extension SchemaRequest {
    convenience init(json: [String: Any]) throws {
        
        // Extract structure
        let structureString: NSDictionary = json["structure"] as! NSDictionary
        guard let structure = try? SchemaStructure(json: structureString as! [String : Any]) else {
            throw SerializationError.missing("structure")
        }
        
        // Extract description
        guard let description = json["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        // Initialize properties
        self.init(description: description, structure: structure)
    }
}
