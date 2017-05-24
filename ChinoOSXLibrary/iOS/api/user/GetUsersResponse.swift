//
//  GetUsersResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetUsersResponse{
    open var users = [User]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    open let exists: Bool
    
    init(){
        self.users = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
        self.exists = false
    }
    
    init(users: [User], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.users = users
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
        self.exists = false
    }
    
    init(exists: Bool) {
        self.users = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
        self.exists = exists
    }
}

extension GetUsersResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract users
        var users: [User] = []
        
        let us = json["users"] as! NSArray
        for value in us {
            if let user = try? User(json: value as! [String : Any]) {
                users.append(user)
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
        self.init(users: users, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
    
    convenience init(json_exists: [String: Any]) throws {
        
        // Extract exists
        guard let exists = json_exists["exists"] as? Bool else {
            throw SerializationError.missing("exists")
        }
        
        // Initialize properties
        self.init(exists: exists)
    }
}
