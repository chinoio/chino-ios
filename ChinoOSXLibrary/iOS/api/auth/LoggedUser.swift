//
//  LoggedUser.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 03/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class LoggedUser {
    open var access_token: String
    open var token_type: String
    open var expires_in: Int
    open var refresh_token: String
    open var scope: String
    
    init(){
        self.access_token = ""
        self.token_type = ""
        self.expires_in = -1
        self.refresh_token = ""
        self.scope = ""
    }
    
    init(access_token: String, token_type: String, expires_in: Int, refresh_token: String, scope: String){
        self.access_token = access_token
        self.token_type = token_type
        self.expires_in = expires_in
        self.refresh_token = refresh_token
        self.scope = scope
    }
}

extension LoggedUser {
    convenience init(json: [String: Any]) throws {
        
        // Extract access_token
        guard let access_token = json["access_token"] as? String else {
            throw SerializationError.missing("access_token")
        }
        
        // Extract token_type
        guard let token_type = json["token_type"] as? String else {
            throw SerializationError.missing("token_type")
        }
        
        // Extract expires_in
        guard let expires_in = json["expires_in"] as? Int else {
            throw SerializationError.missing("expires_in")
        }
        
        // Extract refresh_token
        guard let refresh_token = json["refresh_token"] as? String else {
            throw SerializationError.missing("refresh_token")
        }
        
        // Extract scope
        guard let scope = json["scope"] as? String else {
            throw SerializationError.missing("scope")
        }
        
        // Initialize properties
        self.init(access_token: access_token, token_type: token_type, expires_in: expires_in, refresh_token: refresh_token, scope: scope)
    }
}
