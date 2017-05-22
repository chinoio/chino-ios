//
//  CreateGroupRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class CreateGroupRequest{
    
    open var groupName: String
    open var attributes: NSDictionary
    
    public init(){
        self.groupName = ""
        self.attributes = NSDictionary()
    }
    
    public init(groupName: String, attributes: NSDictionary){
        self.groupName = groupName
        self.attributes = attributes
    }
    
    public func toString() -> String {
        return "{ \"group_name\": \"\(groupName)\", \"attributes\": \(self.attributes.returnJson())}"
    }
}
