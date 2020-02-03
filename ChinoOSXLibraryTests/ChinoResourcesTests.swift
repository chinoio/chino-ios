//
//  ChinoResourcesAsserts.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation
import ChinoOSXLibrary

public func assertValidRepository(repository: Repository) -> Bool{
    if (repository.insertDate) == nil {
        return false
    }
    if(repository.lastUpdate) == nil {
        return false
    }
    if repository.repository_id == "" {
        return false
    }
    return true
}

public func assertValidConsent(consent: Consent) -> Bool{
    if (consent.inserted_date) == nil {
        return false
    }
    if (consent.consent_id == "") {
        return false
    }
    return true
}

public func assertValidUserSchema(user_schema: UserSchema) -> Bool{
    if (user_schema.insertDate) == nil {
        return false
    }
    if(user_schema.lastUpdate) == nil {
        return false
    }
    if user_schema.user_schema_id == "" {
        return false
    }
    if !isValidUserSchemaStructure(structure: user_schema.structure){
        return false
    }
    return true
}

public func assertValidSchema(schema: Schema) -> Bool {
    if (schema.insertDate) == nil {
        return false
    }
    if(schema.lastUpdate) == nil {
        return false
    }
    if schema.schema_id == "" {
        return false
    }
    if !isValidSchemaStructure(structure: schema.structure){
        return false
    }
    return true
}

public func assertValidUser(user: User) -> Bool{
    if user.attributes == nil {
        return false
    }
    if user.groups == nil {
        return false
    }
    if user.lastUpdate == nil {
        return false
    }
    if user.user_id == "" {
        return false
    }
    if user.insertDate == nil {
        return false
    }
    return true
}

public func assertValidApplication(app: Application) -> Bool{
    if app.app_id == "" {
        return false
    }
    if app.app_secret == "" {
        return false
    }
    if app.grant_type == "" {
        return false
    }
    return true
}

public func assertValidListApplicationsObject(app: ListApplicationsObject) -> Bool{
    if app.app_id == "" {
        return false
    }
    return true
}

public func assertValidLoggedUser(user: LoggedUser) -> Bool{
    if user.access_token == "" {
        return false
    }
    if user.refresh_token == "" {
        return false
    }
    if user.scope == "" {
        return false
    }
    if user.token_type == "" {
        return false
    }
    return true
}

public func assertValidDocument(doc: Document) -> Bool{
    if doc.content == nil {
        return false
    }
    if doc.document_id == "" {
        return false
    }
    if doc.lastUpdate == nil {
        return false
    }
    if doc.insertDate == nil {
        return false
    }
    if doc.repository_id == "" {
        return false
    }
    if doc.schema_id == "" {
        return false
    }
    return true
}

public func assertValidCreateDocumentResponse(doc: CreateDocumentResponse) -> Bool{
    if doc.document_id == "" {
        return false
    }
    if doc.lastUpdate == nil {
        return false
    }
    if doc.insertDate == nil {
        return false
    }
    if doc.repository_id == "" {
        return false
    }
    if doc.schema_id == "" {
        return false
    }
    return true
}

public func assertValidGroup(group: Group) -> Bool {
    if group.attributes == nil {
        return false
    }
    if group.group_id == "" {
        return false
    }
    if group.insertDate == nil {
        return false
    }
    if group.lastUpdate == nil {
        return false
    }
    return true
}

public func assertValidCollection(collection: ChinoCollection) -> Bool {
    if collection.collection_id == "" {
        return false
    }
    if collection.name == "" {
        return false
    }
    if collection.insertDate == nil {
        return false
    }
    if collection.lastUpdate == nil {
        return false
    }
    return true
}

public func isValidUserSchemaStructure(structure: UserSchemaStructure) -> Bool{
    for field in structure.fields {
        if !isValidField(field: field) {
            return false
        }
    }
    return true
}

public func isValidSchemaStructure(structure: SchemaStructure) -> Bool{
    for field in structure.fields {
        if !isValidField(field: field) {
            return false
        }
    }
    return true
}

public func isValidField(field: Field) -> Bool {
    if(field.type == "") {
        return false
    }
    if(field.name == "") {
        return false
    }
    return true
}

public func deleteAll(chino: ChinoAPI) {
    
    var check = true
    var document_count = 1
    var schema_count = 1
    var repo_count = 1
    
    var repos = [Repository]()
    var schemas = [Schema]()
    var documents = [CreateDocumentResponse]()
    
    chino.repositories.listRepositories() { (response) in
        var rs: GetRepositoriesResponse!
        do{
            rs = try response()
        } catch let error {
            print((error as! ChinoError).toString())
        }
        repos = (rs?.repositories)!
        check = false
    }
    while(check){}
    check = true
    
    repo_count = repos.count
    for r in repos {
        chino.schemas.listSchemas(repository_id: r.repository_id) { (response) in
            var ss: GetSchemasResponse!
            do{
                ss = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            for s in (ss?.schemas)! {
                schemas.append(s)
            }
            repo_count = repo_count-1
            check = false
        }
        while(check){}
        check = true
    }
    while(repo_count>0){}
    repo_count = repos.count
    
    schema_count = schemas.count
    for s in schemas {
        chino.documents.listDocumentsWithoutContent(schema_id: s.schema_id) { (response) in
            var ds: GetDocumentsResponse!
            do{
                ds = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            for d in (ds?.documents)! {
                documents.append(d)
            }
            schema_count = schema_count-1
            check = false
        }
        while(check){}
        check = true
    }
    while(schema_count>0){}
    
    check = true
    document_count = documents.count
    for d in documents {
        chino.documents.deleteDocument(document_id: d.document_id, force: true) { (result) in
            check = false
        }
        while(check){}
        document_count = document_count-1
        check = true
    }
    while(document_count>0){}
    
    check = true
    schema_count = schemas.count
    for s in schemas {
        chino.schemas.deleteSchema(schema_id: s.schema_id, force: true) { (result) in
            check = false
        }
        while(check){}
        schema_count = schema_count-1
        check = true
    }
    while(schema_count>0){}
    
    repo_count = repos.count
    for r in repos {
        chino.repositories.deleteRepository(repository_id: r.repository_id, force: true) { (result) in
            repo_count = repo_count-1
            check = false
        }
        while(check){}
        check = true
    }
    while(repo_count>0){}
    
    
    var user_schemas = [UserSchema]()
    var users = [User]()
    
    var user_schema_count = 1
    var user_count = 1
    
    check = true
    chino.user_schemas.listUserSchemas(){ (response) in
        var schemas: GetUserSchemasResponse!
        do{
            schemas = try response()
        } catch let error {
            print((error as! ChinoError).toString())
        }
        user_schema_count=(schemas?.count)!
        user_schemas = (schemas?.user_schemas)!
        check = false
    }
    while(check){}
    check = true
    
    user_schema_count = user_schemas.count
    for us in user_schemas {
        chino.users.listUsers(user_schema_id: us.user_schema_id) { (response) in
            var uss: GetUsersResponse!
            do{
                uss = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            for u in (uss?.users)! {
                users.append(u)
            }
            check = false
        }
        while(check){}
        user_schema_count = user_schema_count-1
        check = true
    }
    while(user_schema_count>0) {}
    
    user_count = users.count
    for u in users {
        chino.users.deleteUser(user_id: u.user_id, force: true) { (result) in
            check = false
        }
        while(check){}
        user_count = user_count-1
        check = true
    }
    while(user_count>0) {}
    
    user_schema_count = user_schemas.count
    for u in user_schemas {
        chino.user_schemas.deleteUserSchema(user_schema_id: u.user_schema_id, force: true) { (result) in
            user_schema_count = user_schema_count-1
        }
    }
    while(user_schema_count>0){}
    
    var group_count = 1
    
    chino.groups.listGroups(){ (response) in
        var groups: GetGroupsResponse!
        do{
            groups = try response()
        } catch let error {
            print((error as! ChinoError).toString())
        }
        group_count = (groups?.count)!
        for g in (groups?.groups)! {
            chino.groups.deleteGroup(group_id: g.group_id, force: true) { (result) in
                group_count = group_count-1
            }
        }
    }
    while(group_count>0){
        
    }
    
    var collection_count = 1
    
    chino.collections.listCollections(){ (response) in
        var collections: GetCollectionsResponse!
        do{
            collections = try response()
        } catch let error {
            print((error as! ChinoError).toString())
        }
        collection_count = (collections?.count)!
        for c in (collections?.collections)! {
            chino.collections.deleteCollection(collection_id: c.collection_id, force: true) { (result) in
                collection_count = collection_count-1
            }
        }
    }
    while(collection_count>0){
        
    }
}
