//
//  Application.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 02/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Application {
    
    open var app_secret: String
    open var grant_type: String
    open var app_name: String
    open var redirect_url: String
    open var app_id: String
    
    init(){
        self.app_secret=""
        self.grant_type = ""
        self.app_name=""
        self.redirect_url=""
        self.app_id=""
    }
    
    init(app_secret: String, grant_type: String, app_name: String, redirect_url: String, app_id: String){
        self.app_secret=app_secret
        self.grant_type=grant_type
        self.app_name=app_name
        self.redirect_url=redirect_url
        self.app_id=app_id
    }
}

extension Application {
    convenience init(json: [String: Any]) throws {
        
        // Extract app_secret
        guard let app_secret = json["app_secret"] as? String else {
            throw SerializationError.missing("app_secret")
        }
        
        // Extract grant_type
        guard let grant_type = json["grant_type"] as? String else {
            throw SerializationError.missing("grant_type")
        }
        
        // Extract app_name
        guard let app_name = json["app_name"] as? String else {
            throw SerializationError.missing("app_name")
        }
        
        // Extract redirect_url
        guard let redirect_url = json["redirect_url"] as? String else {
            throw SerializationError.missing("redirect_url")
        }
        
        // Extract app_id
        guard let app_id = json["app_id"] as? String else {
            throw SerializationError.missing("app_id")
        }
        
        // Initialize properties
        self.init(app_secret: app_secret, grant_type: grant_type, app_name: app_name, redirect_url: redirect_url, app_id: app_id)
    }
}
