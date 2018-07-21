//
//  CreateConsentRequest.swift
//  ChinoOSXLibrary
//
//  Created by Paolo on 12/07/2018.
//  Copyright © 2018 Chino. All rights reserved.
//

import Foundation

open class CreateConsentRequest {
    
    open var user_id: String
    open var description: String
    open var policy_url: String
    open var policy_version: String
    open var collection_mode: String
    open var data_controller: DataController!
    open var purposes: [Purpose]
    
    public init(){
        self.user_id=""
        self.description=""
        self.policy_url=""
        self.policy_version=""
        self.collection_mode=""
        self.purposes=[]
    }
    
    public init(user_id: String, description: String, policy_url: String, policy_version: String, collection_mode: String, data_controller: DataController, purposes: [Purpose]){
        self.user_id=user_id
        self.description=description
        self.policy_url=policy_url
        self.policy_version=policy_version
        self.collection_mode=collection_mode
        self.data_controller=data_controller
        self.purposes=purposes
    }
    
    func toString() -> String {
        var result = "{ \"user_id\": \"\(self.user_id)\", \"description\": \"\(self.description)\", \"policy_url\": \"\(self.policy_url)\", \"policy_version\": \"\(self.policy_version)\", \"collection_mode\": \"\(self.collection_mode)\", \"data_controller\": \(self.data_controller.toString()), \"purposes\": ["
        for p in self.purposes {
            result.append(p.toString()+",")
        }
        result = String(result[..<result.index(before: result.endIndex)])
        result.append("]}")
        return result
    }
}
