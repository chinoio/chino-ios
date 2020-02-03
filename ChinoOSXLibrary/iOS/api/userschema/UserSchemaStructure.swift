//
//  UserSchemaStructure.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class UserSchemaStructure {
    open var fields = [Field]()
    
    public init(){
        self.fields = []
    }
    
    public init(fields: [Field]){
        self.fields = fields
    }
    
    func toString() -> String {
        var str: String = "\"fields\": ["
        for value in self.fields {
            str.append(value.toString()+",")
        }
        str = String(str[..<str.index(before: str.endIndex)])
        str.append("]")
        return str
    }
}

extension UserSchemaStructure {
    convenience init(json: [String: Any]) throws {
        
        // Extract fields
        var fields: [Field] = []
        
        let fs = json["fields"] as! NSArray
        for value in fs {
            if let field = try? Field(json: value as! [String : Any]) {
                fields.append(field)
            }
        }
        
        // Initialize properties
        self.init(fields: fields)
    }
}
