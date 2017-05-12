//
//  UserSchemaRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class UserSchemaRequest {
    
    open var description: String
    open var structure: UserSchemaStructure
    
    init(){
        self.description = ""
        self.structure = UserSchemaStructure()
    }
    
    init(description: String, structure: UserSchemaStructure){
        self.description = description
        self.structure = structure
    }
    
    func toString() -> String {
        var str: String = "{ \"description\": \"\(description)\", "
        str.append("\"structure\": { \(structure.toString()) } }")
        return str
    }
}

extension UserSchemaRequest {
    convenience init(json: [String: Any]) throws {
        
        // Extract structure
        let structureString: NSDictionary = json["structure"] as! NSDictionary
        guard let structure = try? UserSchemaStructure(json: structureString as! [String : Any]) else {
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
