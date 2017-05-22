//
//  GetCollectionsResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetCollectionsResponse{
    open var collections = [ChinoCollection]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    
    init(){
        self.collections = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
    }
    
    init(collections: [ChinoCollection], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.collections = collections
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
    }
}

extension GetCollectionsResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract collections
        var collections: [ChinoCollection] = []
        
        let cs = json["collections"] as! NSArray
        for value in cs {
            if let collection = try? ChinoCollection(json: value as! [String : Any]) {
                collections.append(collection)
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
        self.init(collections: collections, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
