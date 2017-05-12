//
//  CreateBlobResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 05/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class CreateBlobResponse {
    open var upload_id: String
    open var expire_date: Date!
    
    init(){
        self.upload_id = ""
    }
    
    init(upload_id: String, expire_date: Date){
        self.upload_id = upload_id
        self.expire_date = expire_date
    }
}

extension CreateBlobResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract upload_id
        guard let upload_id = json["upload_id"] as? String else {
            throw SerializationError.missing("upload_id")
        }
        
        // Extract expire_date
        guard let expire_date_string = json["expire_date"] as? String else {
            throw SerializationError.missing("expire_date")
        }
        
        let expire_date = expire_date_string.dateFromISO8601
        
        // Initialize properties
        self.init(upload_id: upload_id, expire_date: expire_date!)
    }
}
