//
//  GetBlobResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 05/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetBlobResponse {
    
    open var size: Int
    open var file_name: String
    open var path: String
    open var sha1: String
    open var md5: String
    
    init(){
        self.size = -1
        self.file_name = ""
        self.path=""
        self.sha1=""
        self.md5=""
    }
    
    init(size: Int, file_name: String, path: String, sha1: String, md5: String){
        self.size=size
        self.file_name=file_name
        self.path=path
        self.sha1=sha1
        self.md5=md5
    }
}

extension GetBlobResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract size
        guard let size = json["size"] as? Int else {
            throw SerializationError.missing("size")
        }
        
        // Extract file_name
        guard let file_name = json["file_name"] as? String else {
            throw SerializationError.missing("file_name")
        }
        
        // Extract path
        guard let path = json["path"] as? String else {
            throw SerializationError.missing("path")
        }
        
        // Extract sha1
        guard let sha1 = json["sha1"] as? String else {
            throw SerializationError.missing("sha1")
        }
        
        // Extract md5
        guard let md5 = json["md5"] as? String else {
            throw SerializationError.missing("md5")
        }
        
        // Initialize properties
        self.init(size: size, file_name: file_name, path: path, sha1: sha1, md5: md5)
    }
}
