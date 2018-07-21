//
//  SearchRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class SearchRequest {
    
    public enum ResultTypeValues {
        case full_content, no_content, only_id, count, exists, username_exists
        
        func returnValue(value: ResultTypeValues) -> String {
            switch value {
            case .full_content:
                return "FULL_CONTENT"
            case .no_content:
                return "NO_CONTENT"
            case .only_id:
                return "ONLY_ID"
            case .count:
                return "COUNT"
            case .exists:
                return "EXISTS"
            case .username_exists:
                return "USERNAME_EXISTS"
            }
        }
    }
    
    public enum FilterTypeValues {
        case and, or
        func returnValue(value: FilterTypeValues) -> String {
            switch value {
            case .and:
                return "and"
            case .or:
                return "or"
            }
        }
    }
    
    open var result_type: ResultTypeValues
    open var filter_type: FilterTypeValues
    open var sort: [SortOption]!
    open var filter: [FilterOption]!
    
    public init(){
        self.result_type = .no_content
        self.filter_type = .or
    }
    
    public init(result_type: ResultTypeValues, filter_type: FilterTypeValues, sort: [SortOption], filter: [FilterOption]){
        self.result_type = result_type
        self.filter_type = filter_type
        self.sort = sort
        self.filter = filter
    }
    
    func toString() -> String {
        var result = "{ \"result_type\": \"\(self.result_type.returnValue(value: self.result_type))\","
        result.append("\"filter_type\": \"\(self.filter_type.returnValue(value: self.filter_type))\",")
        result.append("\"sort\": [")
        for s in self.sort {
            result.append(s.toString()+",")
        }
        result = String(result[..<result.index(before: result.endIndex)])
        result.append("], \"filter\": [")
        for f in self.filter {
            result.append(f.toString()+",")
        }
        result = String(result[..<result.index(before: result.endIndex)])
        result.append("]}")
        return result
//        var dict = NSDictionary()
//        dict = ["result_type": self.result_type.returnValue(value: self.result_type),
//                "filter_type": self.filter_type.returnValue(value: self.filter_type),
//                "sort": self.sort,
//                "filter": self.filter]
//        return dict.returnJson()
    }
}

//extension SearchRequest {
//    convenience init(json: [String: Any]) throws {
//        
//        // Extract result_type
//        guard let result_type = json["result_type"] as? String else {
//            throw SerializationError.missing("result_type")
//        }
//        
//        // Extract filter_type
//        guard let filter_type = json["filter_type"] as? String else {
//            throw SerializationError.missing("filter_type")
//        }
//        
//        // Extract sort
//        var sort: [SortOption] = []
//        
//        let ss = json["sort"] as! NSArray
//        for value in ss {
//            if let s = try? SortOption(json: value as! [String : Any]) {
//                sort.append(s)
//            }
//        }
//        
//        // Extract filter
//        var filter: [FilterOption] = []
//        
//        let fs = json["filter"] as! NSArray
//        for value in fs {
//            if let f = try? FilterOption(json: value as! [String : Any]) {
//                filter.append(f)
//            }
//        }
//        
//        // Initialize properties
//        self.init(result_type: result_type, filter_type: filter_type, sort: sort, filter: filter)
//    }
//}
