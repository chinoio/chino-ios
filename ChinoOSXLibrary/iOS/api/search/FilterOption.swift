//
//  FilterOption.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class FilterOption {
    
    public enum TypeValues {
        case equal, lower_than, lower_than_or_equal_to, greater_than, greater_than_or_equal_to, equal_boolean, in_list
        
        func returnValue(value: TypeValues) -> String {
            switch value {
            case .equal:
                return "eq"
            case .lower_than:
                return "lt"
            case .lower_than_or_equal_to:
                return "lte"
            case .greater_than:
                return "gt"
            case .greater_than_or_equal_to:
                return "gte"
            case .equal_boolean:
                return "is"
            case .in_list:
                return "in"
            }
        }
    }
    
    open var field: String
    open var type: TypeValues
    open var value: Any!
    
    public init(){
        self.field=""
        self.type = .equal
    }

    public init(type: TypeValues, field: String, value: Any!){
        self.type=type
        self.field=field
        self.value=value
    }
    
    func toString() -> String {
        var dict = NSDictionary()
        dict = ["type": self.type.returnValue(value: self.type), "field": self.field, "value": self.value]
        return dict.returnJson()
    }
}

//extension FilterOption {
//    convenience init(json: [String: Any]) throws {
//        
//        // Extract field
//        guard let field = json["field"] as? String else {
//            throw SerializationError.missing("field")
//        }
//        
//        // Extract type
//        guard let type = json["type"] as? String else {
//            throw SerializationError.missing("type")
//        }
//        
//        // Extract value
//        guard let value = json["value"] as Any! else {
//            throw SerializationError.missing("value")
//        }
//        
//        // Initialize properties
//        self.init(type: type, field: field, value: value)
//    }
//}
