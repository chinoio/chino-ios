//
//  Purpose.swift
//  ChinoOSXLibrary
//
//  Created by Paolo on 12/07/2018.
//  Copyright © 2018 Chino. All rights reserved.
//

import Foundation

open class Purpose {
    
    open var authorized: Bool
    open var purpose: String
    open var description: String
    
    public init(){
        self.authorized=false
        self.purpose=""
        self.description=""
    }
    
    public init(authorized:Bool, purpose:String, description:String){
        self.authorized=authorized
        self.purpose=purpose
        self.description=description
    }
    
    func toString() -> String {
        return "{ \"authorized\": \(self.authorized), \"purpose\": \"\(self.purpose)\", \"description\": \"\(self.description)\"}"
    }
}

extension Purpose {
    convenience init(json: [String: Any]) throws {
        
        // Extract authorized
        guard let authorized = json["authorized"] as? Bool else {
            throw SerializationError.missing("authorized")
        }
        
        // Extract purpose
        guard let purpose = json["purpose"] as? String else {
            throw SerializationError.missing("purpose")
        }
        
        // Extract description
        guard let description = json["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        // Initialize properties
        self.init(authorized:authorized, purpose:purpose, description:description)
    }
}
