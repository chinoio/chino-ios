//
//  Blob.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 05/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Blob {
    
    open var bytes: Int
    open var blob_id: String
    open var document_id: String
    open var sha1: String
    open var md5: String
    
    init(){
        self.bytes = -1
        self.blob_id = ""
        self.document_id=""
        self.sha1=""
        self.md5=""
    }
    
    init(bytes: Int, blob_id: String, document_id: String, sha1: String, md5: String){
        self.bytes=bytes
        self.blob_id=blob_id
        self.document_id=document_id
        self.sha1=sha1
        self.md5=md5
    }
}

extension Blob {
    convenience init(json: [String: Any]) throws {
        
        // Extract bytes
        guard let bytes = json["bytes"] as? Int else {
            throw SerializationError.missing("bytes")
        }
        
        // Extract blob_id
        guard let blob_id = json["blob_id"] as? String else {
            throw SerializationError.missing("blob_id")
        }
        
        // Extract document_id
        guard let document_id = json["document_id"] as? String else {
            throw SerializationError.missing("document_id")
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
        self.init(bytes: bytes, blob_id: blob_id, document_id: document_id, sha1: sha1, md5: md5)
    }
}
