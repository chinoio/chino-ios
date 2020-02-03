//
//  GetSchemasResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 19/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetSchemasResponse{
    open var schemas = [Schema]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    
    init(){
        self.schemas = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
    }
    
    init(schemas: [Schema], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.schemas = schemas
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
    }
}

extension GetSchemasResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract schemas
        var schemas: [Schema] = []
        
        let ss = json["schemas"] as! NSArray
        for value in ss {
            if let schema = try? Schema(json: value as! [String : Any]) {
                schemas.append(schema)
            }
        }
        
        // Extract count
        guard let count = json["count"] as? Int else {
            throw SerializationError.missing("count")
        }
        
        // Extract totalCount
        guard let totalCount = json["total_count"] as? Int else {
            throw SerializationError.missing("total_count")
        }
        
        // Extract limit
        guard let limit = json["limit"] as? Int else {
            throw SerializationError.missing("limit")
        }
        
        // Extract offset
        guard let offset = json["offset"] as? Int else {
            throw SerializationError.missing("offset")
        }
        
        // Initialize properties
        self.init(schemas: schemas, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
