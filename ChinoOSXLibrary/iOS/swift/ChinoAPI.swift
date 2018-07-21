//
//  ChinoAPI.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 10/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class ChinoAPI{
    let url: String
    static var authentication = ""
    open var repositories: Repositories
    open var schemas: Schemas
    open var documents: Documents
    open var user_schemas: UserSchemas
    open var users: Users
    open var groups: Groups
    open var collections: Collections
    open var search: Search
    open var applications: Applications
    open var auth: Auth
    open var blobs: Blobs
    open var permissions: Permissions
    open var consents: Consents
    
    public init(hostUrl url: String){
        self.url = url
        ChinoAPI.authentication = ""
        repositories = Repositories(hostUrl: url)
        schemas = Schemas(hostUrl: url)
        documents = Documents(hostUrl: url)
        user_schemas = UserSchemas(hostUrl: url)
        users = Users(hostUrl: url)
        collections = Collections(hostUrl: url)
        groups = Groups(hostUrl: url)
        search = Search(hostUrl: url)
        applications = Applications(hostUrl: url)
        auth = Auth(hostUrl: url)
        blobs = Blobs(hostUrl: url)
        permissions = Permissions(hostUrl: url)
        consents = Consents(hostUrl: url)
    }
    
    public init(hostUrl url: String, customerId id: String, customerKey key: String){
        self.url = url
        let loginString = String(format: "%@:%@", id, key)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        ChinoAPI.authentication = String(format: "%@ %@", "Basic", loginData.base64EncodedString())
        repositories = Repositories(hostUrl: url)
        schemas = Schemas(hostUrl: url)
        documents = Documents(hostUrl: url)
        user_schemas = UserSchemas(hostUrl: url)
        users = Users(hostUrl: url)
        collections = Collections(hostUrl: url)
        groups = Groups(hostUrl: url)
        search = Search(hostUrl: url)
        applications = Applications(hostUrl: url)
        auth = Auth(hostUrl: url)
        blobs = Blobs(hostUrl: url)
        permissions = Permissions(hostUrl: url)
        consents = Consents(hostUrl: url)
    }
    
    static func setCustomer(customer_id id: String, customer_key key: String) {
        let loginString = String(format: "%@:%@", id, key)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        ChinoAPI.authentication = String(format: "%@ %@", "Basic", loginData.base64EncodedString())
    }
    
    static func setUser(token: String){
        ChinoAPI.authentication = String(format: "%@ %@", "Bearer", token)
    }
}
