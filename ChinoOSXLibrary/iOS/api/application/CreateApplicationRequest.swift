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
    open var redirect_url: String
    
    public init(){
        self.name=""
        self.grant_type = .password
        self.redirect_url=""
    }
    
    public init(name: String, grant_type: GrantTypeValues, redirect_url: String){
        self.name=name
        self.grant_type=grant_type
        self.redirect_url=redirect_url
    }
    
    func toString() -> String {
        var dict = NSDictionary()
        dict = ["name": self.name, "grant_type": self.grant_type.returnValue(value: self.grant_type), "redirect_url": self.redirect_url]
        return dict.returnJson()
    }
}
