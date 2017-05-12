//
//  GetUserSchemasResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetUserSchemasResponse{
    open var user_schemas = [UserSchema]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    
    init(){
        self.user_schemas = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
    }
    
    init(user_schemas: [UserSchema], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.user_schemas = user_schemas
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
    }
}

extension GetUserSchemasResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract user_schemas
        var user_schemas: [UserSchema] = []
        
        let us = json["user_schemas"] as! NSArray
        for value in us {
            if let user_schema = try? UserSchema(json: value as! [String : Any]) {
                user_schemas.append(user_schema)
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
        self.init(user_schemas: user_schemas, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
