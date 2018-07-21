//
//  Consent.swift
//  ChinoOSXLibrary
//
//  Created by Paolo on 12/07/2018.
//  Copyright © 2018 Chino. All rights reserved.
//

import Foundation

open class Consent {
    
    open var user_id: String
    open var description: String
    open var data_controller: DataController!
    open var consent_id: String
    open var purposes: [Purpose]
    open var policy_url: String
    open var policy_version: String
    open var withdrawn_date: Date?
    open var inserted_date: Date!
    open var collection_mode: String
    
    public init(){
        self.user_id=""
        self.description=""
        self.data_controller=nil
        self.consent_id = ""
        self.purposes = []
        self.policy_url = ""
        self.policy_version = ""
        self.collection_mode = ""
    }
    
    public init(user_id: String, description: String, data_controller: DataController, consent_id: String, purposes: [Purpose], policy_url: String, policy_version: String, withdrawn_date: Date?, inserted_date: Date, collection_mode: String){
        self.user_id=user_id
        self.description=description
        self.data_controller=data_controller
        self.consent_id = consent_id
        self.purposes = purposes
        self.policy_url = policy_url
        self.policy_version = policy_version
        self.withdrawn_date = withdrawn_date
        self.inserted_date = inserted_date
        self.collection_mode = collection_mode
    }
}

extension Consent {
    convenience init(json: [String: Any]) throws {
        
        // Extract user_id
        guard let user_id = json["user_id"] as? String else {
            throw SerializationError.missing("user_id")
        }
        
        // Extract description
        guard let description = json["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        // Extract structure
        let data_controller_string: NSDictionary = json["data_controller"] as! NSDictionary
        guard let data_controller = try? DataController(json: data_controller_string as! [String : Any]) else {
            throw SerializationError.missing("data_controller")
        }
        
        // Extract consent_id
        guard let consent_id = json["consent_id"] as? String else {
            throw SerializationError.missing("consent_id")
        }
        
        // Extract purposes
        var purposes: [Purpose] = []
        
        let ps = json["purposes"] as! NSArray
        for value in ps {
            if let purpose = try? Purpose(json: value as! [String : Any]) {
                purposes.append(purpose)
            }
        }
        
        // Extract policy_url
        guard let policy_url = json["policy_url"] as? String else {
            throw SerializationError.missing("policy_url")
        }
        
        // Extract policy_version
        guard let policy_version = json["policy_version"] as? String else {
            throw SerializationError.missing("policy_version")
        }
        
        // Extract withdrawn_date
        let withdrawn_date_string = json["withdrawn_date"] as? String
        let withdrawn_date = withdrawn_date_string?.dateFromISO8601
        
        // Extract inserted_date
        guard let inserted_date_string = json["inserted_date"] as? String else {
            throw SerializationError.missing("inserted_date")
        }
        
        let inserted_date = inserted_date_string.dateFromISO8601
        
        // Extract collection_mode
        guard let collection_mode = json["collection_mode"] as? String else {
            throw SerializationError.missing("collection_mode")
        }
        
        // Initialize properties
        self.init(user_id: user_id, description: description, data_controller: data_controller, consent_id: consent_id, purposes: purposes, policy_url: policy_url, policy_version: policy_version, withdrawn_date: withdrawn_date, inserted_date: inserted_date!, collection_mode: collection_mode)
    }
}
