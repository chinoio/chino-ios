//
//  Applications.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 03/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Applications: ChinoBaseAPI{
    
    public func getApplication(application_id id: String, completion: @escaping (_ inner: () throws -> Application) -> Void) {
        getResource(path: "/auth/applications/"+id, offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let appString: NSDictionary = body!["application"] as! NSDictionary
                if let app = try? Application(json: appString as! [String : Any]) {
                    completion({app})
                }
            }
        }
    }
    
    public func listApplications(completion: @escaping (_ inner: () throws -> GetApplicationsResponse) -> Void) {
        getResource(path: "/auth/applications", offset: 0, limit: ChinoConstants.QUERY_DEFAULT_LIMIT) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let apps = try? GetApplicationsResponse(json: body!) {
                    completion({apps})
                }
            }
        }
    }
    
    public func listApplications(offset: Int, limit: Int, completion: @escaping (_ inner: () throws -> GetApplicationsResponse) -> Void) {
        getResource(path: "/auth/applications", offset: offset, limit: limit) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let apps = try? GetApplicationsResponse(json: body!) {
                    completion({apps})
                }
            }
        }
    }
    
    public func createApplication(name: String, grantType: GrantTypeValues, redirectUrl: String, completion: @escaping (_ inner: () throws -> Application) -> Void) {
        let createAppRequest = CreateApplicationRequest(name: name, grant_type: grantType, redirect_url: redirectUrl)
        postResource(path: "/auth/applications", json: createAppRequest.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let appString: NSDictionary = body!["application"] as! NSDictionary
                if let app = try? Application(json: appString as! [String : Any]) {
                    completion({app})
                }
            }
        }
    }
    
    public func updateApplication(application_id id: String, name: String, grantType: GrantTypeValues, redirectUrl: String, completion: @escaping (_ inner: () throws -> Application) -> Void) {
        let createAppRequest = CreateApplicationRequest(name: name, grant_type: grantType, redirect_url: redirectUrl)
        putResource(path: "/auth/applications/\(id)", json: createAppRequest.toString()) {
            (data, error) in
            if error != nil {
                completion({throw error!})
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                let appString: NSDictionary = body!["application"] as! NSDictionary
                if let app = try? Application(json: appString as! [String : Any]) {
                    completion({app})
                }
            }
        }
    }
    
    public func deleteApplication(application_id id: String, force: Bool, completion: @escaping (_ result: String?) -> ()) {
        deleteResource(path: "/auth/applications/\(id)", force: force) {
            (result) in
            completion(result)
        }
    }
}
