//
//  GetPermissionsResponse.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 04/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class GetPermissionsResponse{
    open var permissions = [Permission]()
    
    init(){
        self.permissions = []
    }
    
    init(permissions: [Permission]){
        self.permissions = permissions
    }
}

extension GetPermissionsResponse {
    convenience init(json: [String: Any]) throws {
        
        // Extract permissions
        var permissions: [Permission] = []
        
        let ps = json["permissions"] as! NSArray
        for value in ps {
            if let permission = try? Permission(json: value as! [String : Any]) {
                permissions.append(permission)
            }
        }
        
        // Initialize properties
        self.init(permissions: permissions)
    }
}
