//
//  SortOption.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class SortOption {
    
    open var field: String
    open var order: String
    
    public init(){
        field=""
        order=""
    }
    
    public init(field: String, order: String){
        self.order=order
        self.field=field
    }
    
    func toString() -> String {
        var dict = NSDictionary()
        dict = ["order": self.order, "field": self.field]
        return dict.returnJson()
    }
}

extension SortOption {
    convenience init(json: [String: Any]) throws {
        
        // Extract field
        guard let field = json["field"] as? String else {
            throw SerializationError.missing("field")
        }
        
        // Extract order
        guard let order = json["order"] as? String else {
            throw SerializationError.missing("order")
        }
        
        // Initialize properties
        self.init(field: field, order: order)
    }
}
