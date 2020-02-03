//
//  GetConsentsResponse.swift
//  
//
//  Created by Paolo on 21/07/2018.
//

import Foundation

open class GetConsentsResponse{
    open var consents = [Consent]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    open var ids = [String]()
    
    init(){
        self.consents = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
        self.ids = []
    }
    
    init(consents: [Consent], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.consents = consents
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
        self.ids = []
    }
    
    init(ids: [String], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.consents = []
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
        self.ids = ids
    }
}

extension GetConsentsResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract documents
        var consents: [Consent] = []
        
        let cs = json["consents"] as! NSArray
        for value in cs {
            if let consent = try? Consent(json: value as! [String : Any]) {
                consents.append(consent)
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
        self.init(consents: consents, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
    
    convenience init(json_ids: [String: Any]) throws {
        
        // Extract ids
        var ids: [String] = []
        
        let ss = json_ids["IDs"] as! NSArray
        for value in ss {
            ids.append(value as! String)
        }
        
        // Extract count
        guard let count = json_ids["count"] as? Int else {
            throw SerializationError.missing("count")
        }
        
        // Extract totalCount
        guard let totalCount = json_ids["total_count"] as? Int else {
            throw SerializationError.missing("total_count")
        }
        
        // Extract limit
        guard let limit = json_ids["limit"] as? Int else {
            throw SerializationError.missing("limit")
        }
        
        // Extract offset
        guard let offset = json_ids["offset"] as? Int else {
            throw SerializationError.missing("offset")
        }
        
        // Initialize properties
        self.init(ids: ids, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
