//
//  Consents.swift
//  ChinoOSXLibrary
//
//  Created by Paolo on 12/07/2018.
//  Copyright © 2018 Chino. All rights reserved.
//

import Foundation

//
//  Repositories.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 10/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Consents: ChinoBaseAPI{
    
    public func getConsent(consent_id id: String, completion: @escaping (_ inner: () throws -> Consent) -> Void) {
        getResource(path: "/consents/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let reposString: NSDictionary = body!["consent"] as! NSDictionary
                if let consent = try? Consent(json: reposString as! [String : Any]) {
                    completion({consent})
                }
            }
        }
    }
    
    public func listConsents(completion: @escaping (_ inner: () throws -> GetConsentsResponse) -> Void) {
        getResource(path: "/consents", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let consents = try? GetConsentsResponse(json: body!) {
                    completion({consents})
                }
            }
        }
    }
    
    public func listConsents(offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetConsentsResponse) -> Void) {
        getResource(path: "/consents", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let consents = try? GetConsentsResponse(json: body!) {
                    completion({consents})
                }
            }
        }
    }
    
    public func createConsent(user_id: String, description:String, policy_url:String, policy_version:String, collection_mode:String, data_controller:DataController, purposes:[Purpose], completion: @escaping (_ inner: () throws -> Consent) -> Void) {
        let createConsentRequest = CreateConsentRequest(user_id: user_id, description: description, policy_url: policy_url, policy_version: policy_version, collection_mode: collection_mode, data_controller: data_controller, purposes: purposes)
        postResource(path: "/consents", json: createConsentRequest.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let consentString: NSDictionary = body!["consent"] as! NSDictionary
                if let consent = try? Consent(json: consentString as! [String : Any]) {
                    completion({consent})
                }
            }
        }
    }
    
    public func updateConsent(consent_id id: String, user_id: String, description:String, policy_url:String, policy_version:String, collection_mode:String, data_controller:DataController, purposes:[Purpose], completion: @escaping (_ inner: () throws -> Consent) -> Void) {
        let createConsentRequest = CreateConsentRequest(user_id: user_id, description: description, policy_url: policy_url, policy_version: policy_version, collection_mode: collection_mode, data_controller: data_controller, purposes: purposes)
        putResource(path: "/consents/\(id)", json: createConsentRequest.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let consentString: NSDictionary = body!["consent"] as! NSDictionary
                if let consent = try? Consent(json: consentString as! [String : Any]) {
                    completion({consent})
                }
            }
        }
    }
    
    public func deleteConsent(consent_id id: String, force: Bool, completion: @escaping (_ inner: () throws -> String) -> Void) {
        deleteResource(path: "/consents/\(id)", force: force) {
            (result, error) in
            if error != nil {
                completion({throw error!})
            } else {
                completion({result!})
            }
        }
    }
}
