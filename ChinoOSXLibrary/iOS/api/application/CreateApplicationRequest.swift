//
//  CreateApplicationRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 02/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class CreateApplicationRequest {
    
    open var name: String
    open var grant_type: GrantTypeValues
    open var client_type: ClientTypeValues
    open var redirect_url: String
    
    public init(){
        self.name=""
        self.grant_type = .password
        self.redirect_url=""
        self.client_type = .client_public
    }
    
    public init(name: String, grant_type: GrantTypeValues, client_type: ClientTypeValues, redirect_url: String){
        self.name=name
        self.grant_type=grant_type
        self.redirect_url=redirect_url
        self.client_type=client_type
    }
    
    func toString() -> String {
        var dict = NSDictionary()
        dict = ["name": self.name, "grant_type": self.grant_type.returnValue(value: self.grant_type), "redirect_url": self.redirect_url, "client_type": self.client_type.returnValue(value: self.client_type)]
        return dict.returnJson()
    }
}
