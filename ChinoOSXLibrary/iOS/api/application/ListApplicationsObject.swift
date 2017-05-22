//
//  ListApplicationsObject.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 09/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class ListApplicationsObject {
    
    open var app_name: String
    open var app_id: String
    
    init(){
        self.app_name=""
        self.app_id=""
    }
    
    init(app_name: String, app_id: String){
        self.app_name=app_name
        self.app_id=app_id
    }
}

extension ListApplicationsObject {
    convenience init(json: [String: Any]) throws {
        
        // Extract app_name
        guard let app_name = json["app_name"] as? String else {
            throw SerializationError.missing("app_name")
        }
        
        // Extract app_id
        guard let app_id = json["app_id"] as? String else {
            throw SerializationError.missing("app_id")
        }
        
        // Initialize properties
        self.init(app_name: app_name, app_id: app_id)
    }
}
