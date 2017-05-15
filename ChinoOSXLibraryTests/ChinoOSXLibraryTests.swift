//
//  ChinoOSXLibraryTests.swift
//  ChinoOSXLibraryTests
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import XCTest
import ChinoOSXLibrary

class ChinoOSXLibraryTests: XCTestCase {
    
    var url: String!
    var customer_id: String!
    var customer_key: String!
    var chino: ChinoAPI!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        url = "https://api.test.chino.io/v1"
        customer_id = "<your-customer-id>"
        customer_key = "<your-customer-key>"
        chino = ChinoAPI(hostUrl: url, customerId: customer_id, customerKey: customer_key)

        //Clear all the resources for such customer_id and customer_key, needed to test some functionalities
        //NOTE: DO NOT use production values for these tests
        deleteAll(chino: chino)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRepositories() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var check=true
        var repo_id = ""
        var repo_id_2 = ""
        
        let description = "test_description"
        let description_2 = "test_description_2"
        let description_updated = "test_description_updated"
        
        //Test create repository
        chino.repositories.createRepository(description: description) { (repository) in
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description)
            repo_id = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        //Test get repository
        self.chino.repositories.getRepository(repository_id: repo_id) { (repository) in
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description)
            repo_id = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        self.chino.repositories.createRepository(description: description_2) { (repository) in
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description_2)
            repo_id_2 = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        //Test update repository
        self.chino.repositories.updateRepository(repository_id: repo_id_2, description: description_updated) { (repository) in
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description_updated)
            repo_id_2 = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        var repo_count=1
        
        //Test list repositories
        self.chino.repositories.listRepositories(offset: 0, limit: 100) { (repos) in
            repo_count = (repos?.count)!
            
            for value in (repos?.repositories)! {
                XCTAssert(assertValidRepository(repository: value))
                XCTAssert(value.description==description_updated || value.description==description)
                
                //Test delete repository
                self.chino.repositories.deleteRepository(repository_id: value.repository_id, force: true) { (response) in
                    XCTAssert(response=="success")
                    repo_count = repo_count-1
                }
            }
        }
        while(repo_count>0){
            
        }
    }
    
    func testSchemas() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var check=true
        var repo_id = ""
        var schema_id = ""
        var schema_id_2 = ""
        
        let description = "test_description"
        let description_2 = "test_description_2"
        let description_updated = "test_description_updated"
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name"))
        fields.append(Field(type: "string", name: "last_name"))
        fields.append(Field(type: "integer", name: "test_integer"))
        var structure: SchemaStructure = SchemaStructure(fields: fields)
        
        chino.repositories.createRepository(description: "test-respository-description") { (repository) in
            repo_id=(repository?.repository_id)!
            check = false
        }
        while(check){}
        check = true
        
        //Test create schema
        self.chino.schemas.createSchema(repository_id: repo_id, description: description, structure: structure) { (schema) in
            XCTAssert(assertValidSchema(schema: schema!))
            XCTAssert(schema?.description==description)
            schema_id = (schema?.schema_id)!
            for field in (schema?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "last_name" || name == "test_integer")
            }
            check = false
        }
        while(check){}
        check = true
            
        //Test get schema
        self.chino.schemas.getSchema(schema_id: schema_id) { (schema) in
            XCTAssert(assertValidSchema(schema: schema!))
            XCTAssert(schema?.description==description)
            schema_id = (schema?.schema_id)!
            for field in (schema?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "last_name" || name == "test_integer")
            }
            check = false
        }
        while(check){}
        check = true
        
        self.chino.schemas.createSchema(repository_id: repo_id, description: description_2, structure: structure) { (schema) in
            XCTAssert(assertValidSchema(schema: schema!))
            XCTAssert(schema?.description==description_2)
            schema_id_2 = (schema?.schema_id)!
            fields = [Field]()
            fields.append(Field(type: "string", name: "name_updated"))
            fields.append(Field(type: "string", name: "last_name_updated"))
            fields.append(Field(type: "integer", name: "test_integer_updated"))
            structure = SchemaStructure(fields: fields)
            check = false
        }
        while(check){}
        check = true
        
        //Test update schema
        self.chino.schemas.updateSchema(schema_id: schema_id_2, description: description_updated, structure: structure) { (schema) in
            XCTAssert(assertValidSchema(schema: schema!))
            XCTAssert(schema?.description==description_updated)
            schema_id_2 = (schema?.schema_id)!
            for field in (schema?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name_updated" || name == "last_name_updated" || name == "test_integer_updated")
            }
            check = false
        }
        while(check){}
        check = true
        
        var schema_counter = 1
        
        //Test list schemas
        self.chino.schemas.listSchemas(repository_id: repo_id) { (schemas) in
            schema_counter = (schemas?.count)!
            for schema in (schemas?.schemas)! {
                XCTAssert(assertValidSchema(schema: schema))
                XCTAssert(schema.description==description || schema.description==description_updated)
                
                //Test delete schema
                self.chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (response) in
                    XCTAssert(response=="success")
                    schema_counter = schema_counter-1
                }
            }
        }
        while(schema_counter>0){}
        
        check = true
        self.chino.repositories.deleteRepository(repository_id: repo_id, force: true) { (response) in
            XCTAssert(response=="success")
            check=false
        }
        while(check){}
    }
    
    func testUserSchemas() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var check=true
        
        var schema: UserSchema!
        var schema2: UserSchema!
        
        let description = "test_description"
        let description_2 = "test_description_2"
        let description_updated = "test_description_updated"
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name"))
        fields.append(Field(type: "string", name: "last_name"))
        fields.append(Field(type: "integer", name: "test_integer"))
        var structure: UserSchemaStructure = UserSchemaStructure(fields: fields)
        
        //Test create user_schema
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (us) in
            XCTAssert(assertValidUserSchema(user_schema: us!))
            XCTAssert(us?.description==description)
            for field in (us?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "last_name" || name == "test_integer")
            }
            schema = us!
            check = false
        }
        while(check){}
        check = true
        
        //Test get user_schema
        self.chino.user_schemas.getUserSchema(user_schema_id: schema.user_schema_id) { (us) in
            XCTAssert(assertValidUserSchema(user_schema: us!))
            XCTAssert(us?.description==description)
            for field in (us?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "last_name" || name == "test_integer")
            }
            schema = us!
            check = false
        }
        while(check){}
        check = true
        
        //Test create user_schema
        self.chino.user_schemas.createUserSchema(description: description_2, structure: structure) { (us) in
            XCTAssert(assertValidUserSchema(user_schema: us!))
            XCTAssert(us?.description==description_2)
            fields = [Field]()
            fields.append(Field(type: "string", name: "name_updated"))
            fields.append(Field(type: "string", name: "last_name_updated"))
            fields.append(Field(type: "integer", name: "test_integer_updated"))
            structure = UserSchemaStructure(fields: fields)
            schema2 = us!
            check = false
        }
        while(check){}
        check = true
        
        //Test update user_schema
        self.chino.user_schemas.updateUserSchema(user_schema_id: schema2.user_schema_id, description: description_updated, structure: structure) { (us) in
            XCTAssert(assertValidUserSchema(user_schema: us!))
            XCTAssert(us?.description==description_updated)
            for field in (us?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name_updated" || name == "last_name_updated" || name == "test_integer_updated")
            }
            check = false
        }
        while(check){}
        check = true
        
        var schema_counter = 1
        
        //Test list user_schemas
        self.chino.user_schemas.listUserSchemas() { (schemas) in
            schema_counter = (schemas?.count)!
            XCTAssert(schemas?.offset==0)
            for s in (schemas?.user_schemas)! {
                XCTAssert(assertValidUserSchema(user_schema: schema))
                XCTAssert(s.description==description || s.description==description_updated)
                
                //Test delete user_schema
                self.chino.user_schemas.deleteUserSchema(user_schema_id: s.user_schema_id, force: true) { (response) in
                    XCTAssert(response=="success")
                    schema_counter = schema_counter-1
                }
            }
        }
        
        while(schema_counter>0){}
    }

    func testUsers() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var check=true
        var schema_id = ""
        let description = "test_description"
        
        var schema: UserSchema!
        var user: User!
        
        let username="jacob@gmail.com"
        let password="password"
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name"))
        fields.append(Field(type: "string", name: "last_name"))
        fields.append(Field(type: "integer", name: "test_integer"))
        let structure: UserSchemaStructure = UserSchemaStructure(fields: fields)
        
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (us) in
            schema_id = (us?.user_schema_id)!
            XCTAssert(assertValidUserSchema(user_schema: us!))
            XCTAssert(us?.description==description)
            for field in (us?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "last_name" || name == "test_integer")
            }
            schema = us
            check = false
        }
        while(check){}
        check = true
        
        var attributes = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        //Test create user
        self.chino.users.createUser(username: username, password: password, user_schema_id: schema.user_schema_id, attributes: attributes as NSDictionary) { (u) in
            XCTAssert(assertValidUser(user: u!))
            XCTAssert(u?.attributes["test_integer"] as! Int == 123)
            user = u!
            check = false
        }
        while(check){}
        check = true
        
        //Test get user
        self.chino.users.getUser(user_id: (user?.user_id)!) { (u) in
            XCTAssert(assertValidUser(user: u!))
            user = u!
            check = false
        }
        while(check){}
        check = true
        
        attributes = ["test_integer": 1234]
        //Test update user first method
        self.chino.users.updateUser(user_id: user.user_id, attributes: attributes as NSDictionary) { (u) in
            XCTAssert(assertValidUser(user: u!))
            XCTAssert(u?.attributes["test_integer"] as! Int == 1234)
            user = u!
            check = false
        }
        while(check){}
        check = true
        
        attributes = ["name": "Giacomino", "last_name": "Rossi", "test_integer": 1234]
        //Test update user second method
        self.chino.users.updateUser(username: username, password: password, user_id: user.user_id, attributes: attributes as NSDictionary) { (u) in
            XCTAssert(assertValidUser(user: u!))
            XCTAssert(u?.attributes["last_name"] as! String == "Rossi")
            user = u!
            check = false
        }
        while(check){}
        check = true
        
        var user_counter = 1
        //Test list users
        self.chino.users.listUsers(user_schema_id: (schema?.user_schema_id)!) { (users) in
            user_counter = (users?.count)!
            for u in (users?.users)! {
                XCTAssert(assertValidUser(user: u))
                //Test delete user
                self.chino.users.deleteUser(user_id: (user?.user_id)!, force: true) { (result) in
                    XCTAssert(result=="success")
                    user_counter = user_counter-1
                }
            }
        }
        while(user_counter>0){}
        
        check = true
        self.chino.user_schemas.deleteUserSchema(user_schema_id: schema_id, force: true) { (result) in
            XCTAssert(result=="success")
            check=false
        }
        while(check){}
    }
    
    func testDocuments() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let description = "test_description"
        var check=true
        var document: CreateDocumentResponse!
        var repo: Repository!
        var schema: Schema!
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name", indexed: true))
        fields.append(Field(type: "string", name: "last_name", indexed: true))
        fields.append(Field(type: "integer", name: "test_integer", indexed: true))
        let structure: SchemaStructure = SchemaStructure(fields: fields)
        
        chino.repositories.createRepository(description: "test-repo-description") { (r) in
            XCTAssert(assertValidRepository(repository: r!))
            repo = r!
            check = false
        }
        while(check){}
        check = true
        
        self.chino.schemas.createSchema(repository_id: repo.repository_id, description: description, structure: structure) { (s) in
            XCTAssert(assertValidSchema(schema: s!))
            XCTAssert(s?.description==description)
            for field in (s?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "last_name" || name == "test_integer")
            }
            schema = s!
            check = false
        }
        while(check){}
        check = true
        
        var content = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        
        sleep(2)
        
        //Test create document
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (doc) in
            XCTAssert(assertValidCreateDocumentResponse(doc: doc!))
            document = doc
            check = false
        }
        while(check){}
        check = true
        
        //Test get document
        self.chino.documents.getDocument(document_id: (document?.document_id)!) { (doc) in
            XCTAssert(assertValidDocument(doc: doc!))
            XCTAssert(doc?.content["test_integer"] as! Int == 123)
            XCTAssert(doc?.content["name"] as! String == "Giacomino")
            XCTAssert(doc?.content["last_name"] as! String == "Storti")
            check = false
        }
        while(check){}
        check = true
        
        content = ["name": "Mario", "last_name": "Rossi", "test_integer": 1234]
        //Test update document
        self.chino.documents.updateDocument(document_id: (document?.document_id)!, content: content as NSDictionary) { (doc) in
            XCTAssert(assertValidCreateDocumentResponse(doc: doc!))
            document = doc
            check = false
        }
        while(check){}
        check = true
        
        var doc_counter = 1
        //Test list documents with content
        self.chino.documents.listDocumentsWithContent(schema_id: (schema?.schema_id)!) { (docs) in
            doc_counter = (docs?.count)!
            for d in (docs?.documents)! {
                XCTAssert(assertValidDocument(doc: d))
                doc_counter = doc_counter-1
            }
        }
        while(doc_counter>0){}
        
        doc_counter = 1
        //Test list documents without content
        self.chino.documents.listDocumentsWithoutContent(schema_id: (schema?.schema_id)!) { (docs) in
            doc_counter = (docs?.count)!
            for d in (docs?.documents)! {
                XCTAssert(assertValidCreateDocumentResponse(doc: d))
                
                //Test delete document
                self.chino.documents.deleteDocument(document_id: d.document_id, force: true) { (result) in
                    XCTAssert(result=="success")
                    print("Document deleted!")
                    doc_counter = doc_counter-1
                    check=false
                }
            }
        }
        while(doc_counter>0){}
        
        check = true
        self.chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (result) in
            XCTAssert(result=="success")
            print("Schema deleted!")
            check = false
        }
        while(check){}
        check = true
        
        self.chino.repositories.deleteRepository(repository_id: repo.repository_id, force: true) { (result) in
            XCTAssert(result=="success")
            print("Repository deleted!")
            check=false
        }
        while(check){}
        check = true
    }
    
    func testGroups(){
        
        var check=true
        var group: Group!
        
        var attributes = ["test_string": "test_value", "test_integer": 123] as NSDictionary
        
        //Test create group
        chino.groups.createGroup(groupName: "test-group", attributes: attributes) { (g) in
            XCTAssert(assertValidGroup(group: g!))
            XCTAssert(g?.groupName == "test-group")
            XCTAssert(g?.attributes["test_string"] as? String == "test_value")
            XCTAssert(g?.attributes["test_integer"] as? Int == 123)
            group = g!
            check = false
        }
        while(check){}
        check = true
        
        //Test get group
        self.chino.groups.getGroup(group_id: (group?.group_id)!) { (g) in
            XCTAssert(assertValidGroup(group: g!))
            XCTAssert(g?.groupName == "test-group")
            XCTAssert(g?.attributes["test_string"] as? String == "test_value")
            XCTAssert(g?.attributes["test_integer"] as? Int == 123)
            group = g!
            check = false
        }
        while(check){}
        check = true
        
        attributes = ["test_string": "test_value_updated", "test_integer": 1234]
                
        //Test update group
        self.chino.groups.updateGroup(group_id: (group?.group_id)!, groupName: "test-group-updated", attributes: attributes) { (g) in
            XCTAssert(assertValidGroup(group: g!))
            XCTAssert(g?.groupName == "test-group-updated")
            XCTAssert(g?.attributes["test_string"] as? String == "test_value_updated")
            XCTAssert(g?.attributes["test_integer"] as? Int == 1234)
            group = g!
            check = false
        }
        while(check){}
        check = true
        
        var group_counter = 1
        //Test list groups
        self.chino.groups.listGroups() { (groups) in
            group_counter = (groups?.count)!
            for g in (groups?.groups)! {
                XCTAssert(assertValidGroup(group: g))
                
                //Test delete group
                self.chino.groups.deleteGroup(group_id: g.group_id, force: true) { (result) in
                    XCTAssert(result=="success")
                    group_counter = group_counter-1
                    check=false
                }
                while(check){}
                check = true
            }
        }
        while(group_counter>0){}
    }

    func testCollections(){
        var check=true
        
        //Test create collection
        chino.collections.createCollection(name: "test_collection") { (collection) in
            XCTAssert(assertValidCollection(collection: collection!))
            XCTAssert(collection?.name == "test_collection")
            
            //Test get collection
            self.chino.collections.getCollection(collection_id: (collection?.collection_id)!) { (collection) in
                XCTAssert(assertValidCollection(collection: collection!))
                XCTAssert(collection?.name == "test_collection")
                
                //Test update collection
                self.chino.collections.updateCollection(collection_id: (collection?.collection_id)!, name: "test_collection_updated") { (collection) in
                    XCTAssert(assertValidCollection(collection: collection!))
                    XCTAssert(collection?.name == "test_collection_updated")
                    
                    //Test list collections
                    self.chino.collections.listCollections() { (collections) in
                        for c in (collections?.collections)! {
                            XCTAssert(assertValidCollection(collection: c))
                            
                            //Test delete collection
                            self.chino.collections.deleteCollection(collection_id: c.collection_id, force: true) { (result) in
                                XCTAssert(result=="success")
                                check=false
                            }
                        }
                    }
                }
            }
        }
        while(check){
            
        }
    }
    
    func testSearch() {
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let description = "test_description"
        var check=true
        var schema_id = ""
        var repo_id = ""
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name", indexed: true))
        fields.append(Field(type: "string", name: "last_name", indexed: true))
        fields.append(Field(type: "integer", name: "test_integer", indexed: true))
        let structure: SchemaStructure = SchemaStructure(fields: fields)
        
        chino.repositories.createRepository(description: "test-repo-description") { (repo) in
            repo_id = (repo?.repository_id)!
            self.chino.schemas.createSchema(repository_id: (repo?.repository_id)!, description: description, structure: structure) { (schema) in
                XCTAssert(assertValidSchema(schema: schema!))
                XCTAssert(schema?.description==description)

                schema_id = (schema?.schema_id)!
                var content = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
                
                sleep(2)
                
                self.chino.documents.createDocument(schema_id: (schema?.schema_id)!, content: content as NSDictionary) { (doc) in
                    XCTAssert(assertValidCreateDocumentResponse(doc: doc!))
                    
                    content = ["name": "Mario", "last_name": "Rossi", "test_integer": 1234]

                    self.chino.documents.createDocument(schema_id: (schema?.schema_id)!, content: content as NSDictionary) { (doc) in
                        XCTAssert(assertValidCreateDocumentResponse(doc: doc!))
                        
                        //Test search documents
                        let filter = [FilterOption(type: FilterOption.TypeValues.equal, field: "name", value: "Mario")]
                        let sort = [SortOption(field: "test_integer", order: "asc")]
                        let request = SearchRequest(result_type: SearchRequest.ResultTypeValues.full_content, filter_type: SearchRequest.FilterTypeValues.or, sort: sort, filter: filter)
                        self.chino.search.searchDocuments(search_request: request, schema_id: (schema?.schema_id)!) { (documents) in
                            print(documents ?? "EEEEEEEEEEEEE")
                        }
                    
                        self.chino.documents.listDocumentsWithoutContent(schema_id: (schema?.schema_id)!) { (docs) in
                            var count = docs?.count
                            for d in (docs?.documents)! {
                                XCTAssert(assertValidCreateDocumentResponse(doc: d))
                                
                                self.chino.documents.deleteDocument(document_id: d.document_id, force: true) { (result) in
                                    XCTAssert(result=="success")
                                    print("Document deleted!")
                                    count = count!-1
                                }
                            }
                            while(count!>0){
                                
                            }
                            check=false
                        }
                    }
                }
            }
        }
        while(check){
            
        }
        var check_delete = true
        self.chino.schemas.deleteSchema(schema_id: schema_id, force: true) { (result) in
            XCTAssert(result=="success")
            print("Schema deleted!")
            self.chino.repositories.deleteRepository(repository_id: repo_id, force: true) { (result) in
                XCTAssert(result=="success")
                print("Repository deleted!")
                check_delete=false
            }
        }
        while(check_delete){
            
        }
    }
    
    func testApplications(){
        var check = true
        var app_id = ""
        
        //Test create application
        chino.applications.createApplication(name: "test_application", grantType: GrantTypeValues.password, redirectUrl: "") { (app) in
            XCTAssert(assertValidApplication(app: app!))
            XCTAssert(app?.app_name == "test_application")
            app_id = (app?.app_id)!
            check = false
        }
        while(check){}
        check=true
        
        //Test get application
        self.chino.applications.getApplication(application_id: app_id) { (app) in
            XCTAssert(assertValidApplication(app: app!))
            XCTAssert(app?.app_name == "test_application")
            check=false
        }
        while(check){}
        check=true
        
        //Test update application
        self.chino.applications.updateApplication(application_id: app_id, name: "test_application_update", grantType: GrantTypeValues.password, redirectUrl: "") { (app) in
            XCTAssert(assertValidApplication(app: app!))
            XCTAssert(app?.app_name == "test_application_update")
            check=false
        }
        while(check){}
        check=true
        
        var app_counter = 1
        //Test list applications
        self.chino.applications.listApplications() { (apps) in
            for a in (apps?.applications)! {
                XCTAssert(assertValidListApplicationsObject(app: a))
                app_counter = (apps?.count)!
                        
                //Test delete application
                self.chino.applications.deleteApplication(application_id: a.app_id, force: true) { (result) in
                    XCTAssert(result=="success")
                    app_counter = app_counter-1
                }
            }
        }
        while(app_counter>0){}
    }
    
    func testAuth(){
        var check=true
        let description = "test_description"
        
        let username="jacob@gmail.com"
        let password="password"
        
        var schema: UserSchema!
        var user: User!
        var app: Application!
        var loggedUser: LoggedUser!
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name"))
        fields.append(Field(type: "string", name: "last_name"))
        fields.append(Field(type: "integer", name: "test_integer"))
        let structure: UserSchemaStructure = UserSchemaStructure(fields: fields)
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (s) in
            schema = s!
            check = false
        }
        while(check){}
        check = true
        
        let attributes = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        
        self.chino.users.createUser(username: username, password: password, user_schema_id: schema.user_schema_id, attributes: attributes as NSDictionary) { (u) in
            user = u!
            check = false
        }
        while(check){}
        check = true
        
        self.chino.applications.createApplication(name: "test_app", grantType: GrantTypeValues.password, redirectUrl: "") { (a) in
            app = a!
            check = false
        }
        while(check){}
        check = true
        
        //Test login with password
        self.chino.auth.loginWithPassword(username: username, password: password, app_id: app.app_id, app_secret: app.app_secret) { (user) in
            XCTAssert(assertValidLoggedUser(user: user!))
            loggedUser = user!
            check = false
        }
        while(check){}
        check = true
        
        //Test refresh token
        self.chino.auth.refreshToken(refresh_token: loggedUser.refresh_token, app_id: app.app_id, app_secret: app.app_secret) { (user) in
            XCTAssert(assertValidLoggedUser(user: user!))
            loggedUser = user!
            check = false
        }
        while(check){}
        check = true
            
        //Test logout
        self.chino.auth.logout(token: loggedUser.access_token, app_id: app.app_id, app_secret: app.app_secret) { (result) in
            print(result)
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        self.chino=ChinoAPI.init(hostUrl: self.url, customerId: self.customer_id, customerKey: self.customer_key)
            
        self.chino.users.deleteUser(user_id: user.user_id, force: true) { (result) in
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        self.chino.user_schemas.deleteUserSchema(user_schema_id: schema.user_schema_id, force: true) { (result) in
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        self.chino.applications.deleteApplication(application_id: app.app_id, force: true) { (result) in
            XCTAssert(result=="success")
            check=false
        }

        while(check){}
        check = true
    }
    
    func testPermissions(){
        
        var check=true
        let description = "test_description"
        
        let username="jacob@gmail.com"
        let password="password"
        
        var document: CreateDocumentResponse!
        var repo: Repository!
        var schema: Schema!
        var user_schema: UserSchema!
        var user: User!
        var app: Application!
        var loggedUser: LoggedUser!
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name"))
        fields.append(Field(type: "string", name: "last_name"))
        fields.append(Field(type: "integer", name: "test_integer"))
        let structure: UserSchemaStructure = UserSchemaStructure(fields: fields)
        
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (s) in
            user_schema = s!
            check = false
        }
        while(check){}
        check = true
        
        let attributes = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        
        self.chino.users.createUser(username: username, password: password, user_schema_id: user_schema.user_schema_id, attributes: attributes as NSDictionary) { (u) in
            user = u!
            check = false
        }
        while(check){}
        check = true
        
        self.chino.applications.createApplication(name: "test_app", grantType: GrantTypeValues.password, redirectUrl: "") { (a) in
            app = a!
            check = false
        }
        while(check){}
        check = true
        
        self.chino.repositories.createRepository(description: "test_repo") { (r) in
            repo = r!
            check = false
        }
        while(check){}
        check = true
        
        fields = [Field]()
        fields.append(Field(type: "string", name: "name"))
        fields.append(Field(type: "string", name: "last_name"))
        fields.append(Field(type: "integer", name: "test_integer"))
        let schemaStructure: SchemaStructure = SchemaStructure(fields: fields)
        
        self.chino.schemas.createSchema(repository_id: repo.repository_id, description: "test_schema", structure: schemaStructure) { (s) in
            schema = s!
            check = false
        }
        while(check){}
        check = true
        
        let authorize = [RuleValues]()
        var manage = [RuleValues.update,
                    RuleValues.read]
        let createdDocumentRule = PermissionRule(authorize: authorize, manage: manage)
        manage = [RuleValues.create]
        let rule = PermissionRule(authorize: authorize, manage: manage, created_document: createdDocumentRule)
        
        //Test give permission to user to create documents in a schema
        self.chino.permissions.permissionsOnResourceChildren(action: ActionValues.grant, resource_type: ResourceValues.schemas, resource_id: schema.schema_id, resource_children: ResourceChildrenValues.documents, subject_type: SubjectValues.users, subject_id: user.user_id, rule: rule) { (result) in
            XCTAssert(result == "success")
        }
        
        self.chino.auth.loginWithPassword(username: username, password: password, app_id: app.app_id, app_secret: app.app_secret) { (user) in
            XCTAssert(assertValidLoggedUser(user: user!))
            loggedUser = user!
            check = false
        }
        while(check){}
        check = true
        
        let content: NSDictionary = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123]
        
        sleep(2)
        
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content) { (d) in
            XCTAssert(assertValidCreateDocumentResponse(doc: d!))
            document = d
            check = false
        }
        while(check){}
        check = true
        
        self.chino.auth.logout(token: loggedUser.access_token, app_id: app.app_id, app_secret: app.app_name) { (result) in
            XCTAssert(result == "success")
            check = false
        }
        while(check){}
        check = true
        
        chino = ChinoAPI(hostUrl: url, customerId: customer_id, customerKey: customer_key)

        chino.documents.deleteDocument(document_id: document.document_id, force: true) { (result) in
            XCTAssert(result == "success")
            check = false
        }
        while(check){}
        check = true
        
        chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (result) in
            XCTAssert(result == "success")
            check = false
        }
        while(check){}
        check = true
        
        chino.repositories.deleteRepository(repository_id: repo.repository_id, force: true) { (result) in
            XCTAssert(result == "success")
            check = false
        }
        while(check){}
        check = true
        
        chino.users.deleteUser(user_id: user.user_id, force: true) { (result) in
            XCTAssert(result == "success")
            check = false
        }
        while(check){}
        check = true
        
        chino.user_schemas.deleteUserSchema(user_schema_id: user_schema.user_schema_id, force: true) { (result) in
            XCTAssert(result == "success")
            check = false
        }
        while(check){}
        check = true
    }
    
    func testBlobs(){
        
        let path = "/Users/chino/Downloads/"
        let destination = "/Users/chino/Desktop/"
        let name = "Eve.gp5"
        let description = "test_description"
        var check=true
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name", indexed: true))
        fields.append(Field(type: "string", name: "last_name", indexed: true))
        fields.append(Field(type: "integer", name: "test_integer", indexed: true))
        fields.append(Field(type: "blob", name: "test_blob"))
        let structure: SchemaStructure = SchemaStructure(fields: fields)
        
        chino.repositories.createRepository(description: "test-repo-description") { (repo) in
            self.chino.schemas.createSchema(repository_id: (repo?.repository_id)!, description: description, structure: structure) { (schema) in
                let content = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
                
                sleep(2)
                
                self.chino.documents.createDocument(schema_id: (schema?.schema_id)!, content: content as NSDictionary) { (doc) in
                    self.chino.blobs.uploadBlob(path: path, document_id: (doc?.document_id)!, field: "test_blob", file_name: name) { (blob) in
                        self.chino.blobs.get(blob_id: (blob?.blob_id)!, destination: destination) { (response) in
                            
                            print("MD5: "+(response?.md5)!)
                            print("SHA1: "+(response?.sha1)!)
                            
                            self.chino.blobs.deleteBlob(blob_id: (blob?.blob_id)!) { (result) in
                                print("Delete blob: "+result!)
                                self.chino.documents.deleteDocument(document_id: (doc?.document_id)!, force: true) { (result) in
                                    print("Delete document: "+result!)
                                    self.chino.schemas.deleteSchema(schema_id: (schema?.schema_id)!, force: true) { (result) in
                                        print("Delete schema: "+result!)
                                        self.chino.repositories.deleteRepository(repository_id: (repo?.repository_id)!, force: true) { (result) in
                                            print("Delete repo: "+result!)
                                            check = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        while(check){
            
        }
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
