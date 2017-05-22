//
//  GetDocumentsResponseFullContent.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 24/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetDocumentsResponseFullContent{
    open var documents = [Document]()
    open let count: Int
    open let totalCount: Int
    open let limit: Int
    open let offset: Int
    
    init(){
        self.documents = []
        self.count = 0
        self.totalCount = 0
        self.limit = 0
        self.offset = 0
    }
    
    init(documents: [Document], count: Int, totalCount: Int, limit: Int, offset: Int){
        self.documents = documents
        self.count = count
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
    }
}

extension GetDocumentsResponseFullContent {
    convenience init(json: [String: Any]) throws {
        
        // Extract repositories
        var documents: [Document] = []
        
        let ds = json["documents"] as! NSArray
        for value in ds {
            if let document = try? Document(json: value as! [String : Any]) {
                documents.append(document)
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
        self.init(documents: documents, count: count, totalCount: totalCount, limit: limit, offset: offset)
    }
}
