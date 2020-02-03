//
//  CreateUserRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class CreateUserRequest{
    
    open var username: String
    open var password: String
    open var attributes: NSDictionary
    
    public init(){
        username = ""
        password = ""
        self.attributes = NSDictionary()
    }
    
    public init(username: String, password: String, attributes: NSDictionary){
        self.username = username
        self.password = password
        self.attributes = attributes
    }
    
    public func toString() -> String {
        return "{ \"username\": \"\(username)\", \"password\": \"\(password)\", \"attributes\": \(self.attributes.returnJson())}"
    }
}
