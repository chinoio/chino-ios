//
//  CreateBlobRequest.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 05/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class CreateBlobRequest {
    
    open var document_id: String
    open var field: String
    open var file_name: String
    
    public init(){
        self.document_id=""
        self.field = ""
        self.file_name=""
    }
    
    public init(document_id: String, field: String, file_name: String){
        self.document_id=document_id
        self.field=field
        self.file_name=file_name
    }
    
    func toString() -> String {
        var dict = NSDictionary()
        dict = ["document_id": self.document_id, "field": self.field, "file_name": self.file_name]
        return dict.returnJson()
    }
}
