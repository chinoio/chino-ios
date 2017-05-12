//
//  Auth.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 03/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class Auth: ChinoBaseAPI {
    
    public func loginWithPassword(username: String, password: String, app_id: String, app_secret: String, completion: @escaping (_ repository: LoggedUser?) -> ()){
        let data = "grant_type=password&username=\(username)&password=\(password)".data(using:String.Encoding.ascii, allowLossyConversion: false)
        ChinoAPI.setCustomer(customer_id: app_id, customer_key: app_secret)
        postResource(path: "/auth/token/", json: data!, with_auth: true){
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let usr = try? LoggedUser(json: body!) {
                    ChinoAPI.setUser(token: usr.access_token)
                    completion(usr)
                }
            }
        }
    }
    
    public func loginWithAuthorizationCode(code: String, redirect_url: String, app_id: String, app_secret: String, completion: @escaping (_ repository: LoggedUser?) -> ()){
        let data = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirect_url)&client_id=\(app_id)&client_secret=\(app_secret)&scope=read write".data(using:String.Encoding.ascii, allowLossyConversion: false)
        postResource(path: "/auth/token/", json: data!, with_auth: false){
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let usr = try? LoggedUser(json: body!) {
                    ChinoAPI.setUser(token: usr.access_token)
                    completion(usr)
                }
            }
        }
    }
    
    public func refreshToken(refresh_token: String, app_id: String, app_secret: String, completion: @escaping (_ repository: LoggedUser?) -> ()){
        let data = "grant_type=refresh_token&refresh_token=\(refresh_token)&client_id=\(app_id)&client_secret=\(app_secret)".data(using:String.Encoding.ascii, allowLossyConversion: false)
        postResource(path: "/auth/token/", json: data!, with_auth: false){
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = json!["data"] as? [String:Any]
                if let usr = try? LoggedUser(json: body!) {
                    ChinoAPI.setUser(token: usr.access_token)
                    completion(usr)
                }
            }
        }
    }
    
    public func logout(token: String, app_id: String, app_secret: String, completion: @escaping (_ result: String) -> ()){
        let data = "token=\(token)&client_id=\(app_id)&client_secret=\(app_secret)".data(using:String.Encoding.ascii, allowLossyConversion: false)
        postResource(path: "/auth/revoke_token/", json: data!, with_auth: false){
            (data, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = json!["result"] as? String
                completion(result!)
            }
        }
    }
}
