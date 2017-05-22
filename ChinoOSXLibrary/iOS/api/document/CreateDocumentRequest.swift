//
//  CreateDocumentRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 24/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation
open class CreateDocumentRequest{
    open var content: NSDictionary
    
    public init(){
        self.content = NSDictionary()
    }
    
    public init(content: NSDictionary){
        self.content = content
    }
    
    public func toString() -> String {
        return "{ \"content\": \(self.content.returnJson())}"
    }
}
