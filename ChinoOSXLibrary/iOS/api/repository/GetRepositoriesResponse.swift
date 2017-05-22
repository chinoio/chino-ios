//
//  GetRepositoriesResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 10/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetRepositoriesResponse{
    open var repositories = [Repository]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    
    init(){
        self.repositories = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
    }
    
    init(repositories: [Repository], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.repositories = repositories
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
    }
}

extension GetRepositoriesResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract repositories
        var repositories: [Repository] = []
        
        let repos = json["repositories"] as! NSArray
        for value in repos {
            if let repository = try? Repository(json: value as! [String : Any]) {
                repositories.append(repository)
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
        self.init(repositories: repositories, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
