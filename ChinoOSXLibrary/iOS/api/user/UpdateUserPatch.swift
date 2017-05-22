//
//  UpdateUserPatch.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class UpdateUserPatch{
    
    open var attributes: NSDictionary
    
    public init(){
        self.attributes = NSDictionary()
    }
    
    public init(attributes: NSDictionary){
        self.attributes = attributes
    }
    
    public func toString() -> String {
        return "{ \"attributes\": \(self.attributes.returnJson())}"
    }
}
