//
//  GetGroupsResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetGroupsResponse{
    open var groups = [Group]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    
    init(){
        self.groups = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
    }
    
    init(groups: [Group], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.groups = groups
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
    }
}

extension GetGroupsResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract groups
        var groups: [Group] = []
        
        let gs = json["groups"] as! NSArray
        for value in gs {
            if let group = try? Group(json: value as! [String : Any]) {
                groups.append(group)
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
        self.init(groups: groups, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
