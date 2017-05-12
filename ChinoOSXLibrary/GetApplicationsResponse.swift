//
//  GetApplicationsResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 02/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetApplicationsResponse{
    open var applications = [ListApplicationsObject]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    
    init(){
        self.applications = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
    }
    
    init(applications: [ListApplicationsObject], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.applications = applications
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
    }
}

extension GetApplicationsResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract applications
        var applications: [ListApplicationsObject] = []
        
        let a = json["applications"] as! NSArray
        for value in a {
            if let application = try? ListApplicationsObject(json: value as! [String : Any]) {
                applications.append(application)
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
        self.init(applications: applications, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
