//
//  ChinoOSXLibraryTests.swift
//  ChinoOSXLibraryTests
//
//  Created by Chino on 26/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import XCTest
@testable import ChinoOSXLibrary

class ChinoOSXLibraryTests: XCTestCase {

    var chino: ChinoAPI!
    var URL: String!
    var CUSTOMER_ID: String!
    var CUSTOMER_KEY: String!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false        

        let testBundle = Bundle(for: ChinoOSXLibraryTests.self)
        if let url = testBundle.url(forResource: "Info", withExtension: "plist"),
            var myDict = NSDictionary(contentsOf: url) as? [String:Any] {
            URL = myDict["URL"] as? String
            CUSTOMER_ID = myDict["CUSTOMER_ID"] as? String
            CUSTOMER_KEY = myDict["CUSTOMER_KEY"] as? String
        }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        chino = ChinoAPI(hostUrl: URL, customerId: CUSTOMER_ID, customerKey: CUSTOMER_KEY)

        //Clear all the resources for such customer_id and customer_key, needed to test some functionalities
        //NOTE: DO NOT use production values for these tests
        //deleteAll(chino: chino)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConsents() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var check=true
        var consent_id = ""
        var consent_id_2 = ""
        let user_id = "admin@chino.io"
        let user_id_updated = "admin_updated@chino.io"
        
        let data_controller = DataController.init(on_behalf: true, company: "Acme", contact: "John Doe", address: "221B Baker St.", email: "info@acme.com", VAT: "IT03256920228")
        
        let purpose = Purpose.init(authorized: true, purpose: "health data", description: "Processing of age and sex")
        
        //Test create consent
        self.chino.consents.createConsent(user_id: user_id, description: "a long textual description", policy_url: "https://chino.io/legal/privacy-policy", policy_version: "v1.0", collection_mode: "webform", data_controller: data_controller, purposes: [purpose]) { (response) in
            var consent: Consent!
            do{
                consent = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidConsent(consent: consent!))
            XCTAssert(consent?.user_id==user_id)
            consent_id = (consent?.consent_id)!
            check=false
        }
        while(check){}
        check=true
        
        //Test get consent
        self.chino.consents.getConsent(consent_id: consent_id) { (response) in
            var consent: Consent!
            do{
                consent = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidConsent(consent: consent!))
            XCTAssert(consent?.user_id==user_id)
            check=false
        }
        while(check){}
        check=true
        
        self.chino.consents.createConsent(user_id: user_id, description: "a long textual description", policy_url: "https://chino.io/legal/privacy-policy", policy_version: "v1.0", collection_mode: "webform", data_controller: data_controller, purposes: [purpose]) { (response) in
            var consent: Consent!
            do{
                consent = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidConsent(consent: consent!))
            XCTAssert(consent?.user_id==user_id)
            consent_id_2 = (consent?.consent_id)!
            check=false
        }
        while(check){}
        check=true
        
        //Test update consent
        self.chino.consents.updateConsent(consent_id: consent_id, user_id: user_id_updated, description: "a long textual description", policy_url: "https://chino.io/legal/privacy-policy", policy_version: "v1.0", collection_mode: "webform", data_controller: data_controller, purposes: [purpose]) { (response) in
            var consent: Consent!
            do{
                consent = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidConsent(consent: consent!))
            XCTAssert(consent?.user_id==user_id_updated)
            check=false
        }
        while(check){}
        check=true
        
        //Test list consents
        self.chino.consents.listConsents(offset: 0, limit: 100) { (response) in
            var consents: GetConsentsResponse!
            do{
                consents = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            
            for value in (consents?.consents)! {
                XCTAssert(assertValidConsent(consent: value))
            }
        }
        
        //Test delete consent 1
        self.chino.consents.deleteConsent(consent_id: consent_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        //Test delete consent 2
        self.chino.consents.deleteConsent(consent_id: consent_id_2, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
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
        chino.repositories.createRepository(description: description) { (response) in
            var repository: Repository!
            do{
                repository = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description)
            repo_id = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        //Test get repository
        self.chino.repositories.getRepository(repository_id: repo_id) { (response) in
            var repository: Repository!
            do{
                repository = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description)
            repo_id = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        self.chino.repositories.createRepository(description: description_2) { (response) in
            var repository: Repository!
            do{
                repository = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description_2)
            repo_id_2 = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        //Test update repository
        self.chino.repositories.updateRepository(repository_id: repo_id_2, description: description_updated) { (response) in
            var repository: Repository!
            do{
                repository = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidRepository(repository: repository!))
            XCTAssert(repository?.description==description_updated)
            repo_id_2 = (repository?.repository_id)!
            check=false
        }
        while(check){}
        check=true
        
        //Test list repositories
        self.chino.repositories.listRepositories(offset: 0, limit: 100) { (response) in
            var repos: GetRepositoriesResponse!
            do{
                repos = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            
            for value in (repos?.repositories)! {
                XCTAssert(assertValidRepository(repository: value))
            }
        }
                
        //Test delete repository
        self.chino.repositories.deleteRepository(repository_id: repo_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
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
        
        chino.repositories.createRepository(description: "test-respository-description") { (response) in
            var repository: Repository!
            do{
                repository = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            repo_id=(repository?.repository_id)!
            check = false
        }
        while(check){}
        check = true
        
        //Test create schema
        self.chino.schemas.createSchema(repository_id: repo_id, description: description, structure: structure) { (response) in
            var schema: Schema!
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        self.chino.schemas.getSchema(schema_id: schema_id) { (response) in
            var schema: Schema!
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        
        self.chino.schemas.createSchema(repository_id: repo_id, description: description_2, structure: structure) { (response) in
            var schema: Schema!
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        self.chino.schemas.updateSchema(schema_id: schema_id_2, description: description_updated, structure: structure) { (response) in
            var schema: Schema!
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        self.chino.schemas.listSchemas(repository_id: repo_id) { (response) in
            var schemas: GetSchemasResponse!
            do{
                schemas = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            schema_counter = (schemas?.count)!
            for schema in (schemas?.schemas)! {
                XCTAssert(assertValidSchema(schema: schema))
                XCTAssert(schema.description==description || schema.description==description_updated)
                
                //Test delete schema
                self.chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (response) in
                    var result: String!
                    do{
                        result = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(result=="success")
                    schema_counter = schema_counter-1
                }
            }
        }
        while(schema_counter>0){}
        
        check = true
        self.chino.repositories.deleteRepository(repository_id: repo_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
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
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (response) in
            var us: UserSchema!
            do{
                us = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        self.chino.user_schemas.getUserSchema(user_schema_id: schema.user_schema_id) { (response) in
            var us: UserSchema!
            do{
                us = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        self.chino.user_schemas.createUserSchema(description: description_2, structure: structure) { (response) in
            var us: UserSchema!
            do{
                us = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        self.chino.user_schemas.updateUserSchema(user_schema_id: schema2.user_schema_id, description: description_updated, structure: structure) { (response) in
            var us: UserSchema!
            do{
                us = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        self.chino.user_schemas.listUserSchemas() { (response) in
            var schemas: GetUserSchemasResponse!
            do{
                schemas = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            schema_counter = (schemas?.count)!
            XCTAssert(schemas?.offset==0)
            for s in (schemas?.user_schemas)! {
                XCTAssert(assertValidUserSchema(user_schema: schema))
                XCTAssert(s.description==description || s.description==description_updated)
                
                //Test delete user_schema
                self.chino.user_schemas.deleteUserSchema(user_schema_id: s.user_schema_id, force: true) { (response) in
                    var result: String!
                    do{
                        result = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(result=="success")
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
        
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (response) in
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUserSchema(user_schema: schema!))
            schema_id = (schema?.user_schema_id)!
            XCTAssert(schema?.description==description)
            for field in (schema?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "last_name" || name == "test_integer")
            }
            check = false
        }
        while(check){}
        check = true
        
        var attributes = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        //Test create user
        self.chino.users.createUser(username: username, password: password, user_schema_id: schema.user_schema_id, attributes: attributes as NSDictionary) { (response) in
            do{
                user = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: user!))
            XCTAssert(user?.attributes["test_integer"] as! Int == 123)
            check = false
        }
        while(check){}
        check = true
        
        //Test get user
        self.chino.users.getUser(user_id: (user?.user_id)!) { (response) in
            do{
                user = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: user!))
            check = false
        }
        while(check){}
        check = true
        
        attributes = ["test_integer": 1234]
        //Test update user first method
        self.chino.users.updateUser(user_id: user.user_id, attributes: attributes as NSDictionary) { (response) in
            do{
                user = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: user!))
            XCTAssert(user?.attributes["test_integer"] as! Int == 1234)
            check = false
        }
        while(check){}
        check = true
        
        attributes = ["name": "Giacomino", "last_name": "Rossi", "test_integer": 1234]
        //Test update user second method
        self.chino.users.updateUser(username: username, password: password, user_id: user.user_id, attributes: attributes as NSDictionary) { (response) in
            do{
                user = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: user!))
            XCTAssert(user?.attributes["last_name"] as! String == "Rossi")
            check = false
        }
        while(check){}
        check = true
        
        var user_counter = 1
        //Test list users
        self.chino.users.listUsers(user_schema_id: (schema?.user_schema_id)!) { (response) in
            var users: GetUsersResponse!
            do{
                users = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            user_counter = users.count
            for u in users.users {
                XCTAssert(assertValidUser(user: u))
                //Test delete user
                self.chino.users.deleteUser(user_id: (user?.user_id)!, force: true) { (response) in
                    var result: String!
                    do{
                        result = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(result=="success")
                    user_counter = user_counter-1
                }
            }
        }
        while(user_counter>0){}
        
        check = true
        self.chino.user_schemas.deleteUserSchema(user_schema_id: schema_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        fields.append(Field(type: "datetime", name: "date", indexed: true))
        fields.append(Field(type: "integer", name: "test_integer", indexed: true))
        let structure: SchemaStructure = SchemaStructure(fields: fields)
        
        chino.repositories.createRepository(description: "test-repo-description") { (response) in
            do{
                repo = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidRepository(repository: repo!))
            check = false
        }
        while(check){}
        check = true
        
        self.chino.schemas.createSchema(repository_id: repo.repository_id, description: description, structure: structure) { (response) in
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidSchema(schema: schema!))
            XCTAssert(schema?.description==description)
            for field in (schema?.structure.fields)! {
                let name = field.name
                XCTAssert(name == "name" || name == "date" || name == "test_integer")
            }
            check = false
        }
        while(check){}
        check = true
        
        var date = Date()
        
        var content = ["name": "Giacomino", "date": date.chinoDate, "test_integer": 123] as [String : Any]
        
        sleep(2)
        
        //Test create document
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
            do{
                document = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidCreateDocumentResponse(doc: document!))
            check = false
        }
        while(check){}
        check = true
        
        var doc: Document!
        
        //Test get document
        self.chino.documents.getDocument(document_id: (document?.document_id)!) { (response) in
            do{
                doc = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidDocument(doc: doc))
            XCTAssert(doc.content["test_integer"] as! Int == 123)
            XCTAssert(doc.content["name"] as! String == "Giacomino")
            XCTAssert(doc.content["date"] as! String == date.chinoDate)
            check = false
        }
        while(check){}
        check = true
        
        date = Date()
        
        content = ["name": "Mario", "date": date.chinoDate, "test_integer": 1234]
        //Test update document
        self.chino.documents.updateDocument(document_id: (document?.document_id)!, content: content as NSDictionary) { (response) in
            do{
                document = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidCreateDocumentResponse(doc: document!))
            check = false
        }
        while(check){}
        check = true
        
        var docs: GetDocumentsResponseFullContent!
        
        var doc_counter = 1
        //Test list documents with content
        self.chino.documents.listDocumentsWithContent(schema_id: (schema?.schema_id)!) { (response) in
            do{
                docs = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            doc_counter = docs.count
            for d in docs.documents {
                XCTAssert(assertValidDocument(doc: d))
                doc_counter = doc_counter-1
            }
        }
        while(doc_counter>0){}
        
        var docs_no_content: GetDocumentsResponse!
        
        doc_counter = 1
        //Test list documents without content
        self.chino.documents.listDocumentsWithoutContent(schema_id: (schema?.schema_id)!) { (response) in
            do{
                docs_no_content = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            doc_counter = docs_no_content.count
            for d in docs_no_content.documents {
                XCTAssert(assertValidCreateDocumentResponse(doc: d))
                
                //Test delete document
                self.chino.documents.deleteDocument(document_id: d.document_id, force: true) { (response) in
                    var result: String!
                    do{
                        result = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(result=="success")
                    print("Document deleted!")
                    doc_counter = doc_counter-1
                    check=false
                }
            }
        }
        while(doc_counter>0){}
        
        check = true
        self.chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            print("Schema deleted!")
            check = false
        }
        while(check){}
        check = true
        
        self.chino.repositories.deleteRepository(repository_id: repo.repository_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        chino.groups.createGroup(groupName: "test-group", attributes: attributes) { (response) in
            do{
                group = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidGroup(group: group!))
            XCTAssert(group?.groupName == "test-group")
            XCTAssert(group?.attributes["test_string"] as? String == "test_value")
            XCTAssert(group?.attributes["test_integer"] as? Int == 123)
            check = false
        }
        while(check){}
        check = true
        
        //Test get group
        self.chino.groups.getGroup(group_id: (group?.group_id)!) { (response) in
            do{
                group = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidGroup(group: group!))
            XCTAssert(group?.groupName == "test-group")
            XCTAssert(group?.attributes["test_string"] as? String == "test_value")
            XCTAssert(group?.attributes["test_integer"] as? Int == 123)
            check = false
        }
        while(check){}
        check = true
        
        attributes = ["test_string": "test_value_updated", "test_integer": 1234]
                
        //Test update group
        self.chino.groups.updateGroup(group_id: (group?.group_id)!, groupName: "test-group-updated", attributes: attributes) { (response) in
            do{
                group = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidGroup(group: group!))
            XCTAssert(group?.groupName == "test-group-updated")
            XCTAssert(group?.attributes["test_string"] as? String == "test_value_updated")
            XCTAssert(group?.attributes["test_integer"] as? Int == 1234)
            check = false
        }
        while(check){}
        check = true
        
        var group_counter = 1
        //Test list groups
        self.chino.groups.listGroups() { (response) in
            var groups: GetGroupsResponse!
            do{
                groups = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            group_counter = groups.count
            for g in groups.groups {
                XCTAssert(assertValidGroup(group: g))
                
                //Test delete group
                self.chino.groups.deleteGroup(group_id: g.group_id, force: true) { (response) in
                    var result: String!
                    do{
                        result = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
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
        var collection: ChinoCollection!
        
        //Test create collection
        chino.collections.createCollection(name: "test_collection") { (response) in
            do{
                collection = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidCollection(collection: collection))
            XCTAssert(collection.name == "test_collection")
            
            //Test get collection
            self.chino.collections.getCollection(collection_id: collection.collection_id) { (response) in
                do{
                    collection = try response()
                } catch let error {
                    print((error as! ChinoError).toString())
                }
                XCTAssert(assertValidCollection(collection: collection))
                XCTAssert(collection.name == "test_collection")
                
                //Test update collection
                self.chino.collections.updateCollection(collection_id: collection.collection_id, name: "test_collection_updated") { (response) in
                    do{
                        collection = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(assertValidCollection(collection: collection))
                    XCTAssert(collection.name == "test_collection_updated")
                    
                    var collections: GetCollectionsResponse!
                    //Test list collections
                    self.chino.collections.listCollections() { (response) in
                        do{
                            collections = try response()
                        } catch let error {
                            print((error as! ChinoError).toString())
                        }
                        for c in collections.collections {
                            XCTAssert(assertValidCollection(collection: c))
                            
                            //Test delete collection
                            self.chino.collections.deleteCollection(collection_id: c.collection_id, force: true) { (response) in
                                var result: String!
                                do{
                                    result = try response()
                                } catch let error {
                                    print((error as! ChinoError).toString())
                                }
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
        let schema_description = "base_visit"
        let user_schema_description = "user_schema"
        var check=true
        var repo: Repository!
        var schema: Schema!
        var user_schema: UserSchema!
        var doctor: User!
        var first_patient: User!
        var second_patient: User!
        var first_document: CreateDocumentResponse!
        var second_document: CreateDocumentResponse!
        var third_document: CreateDocumentResponse!
        
        //Create a Repository
        chino.repositories.createRepository(description: "tutorial-search") { (response) in
            do{
                repo = try response()
                check = false
            } catch let error {
                print((error as! ChinoError).toString())
            }
        }
        while(check) {}
        check = true
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "patient_id", indexed: true))
        fields.append(Field(type: "string", name: "doctor_id", indexed: true))
        fields.append(Field(type: "string", name: "visit_type", indexed: true))
        fields.append(Field(type: "text", name: "visit"))
        fields.append(Field(type: "datetime", name: "date", indexed: true))
        let structure: SchemaStructure = SchemaStructure(fields: fields)
        
        //Create a Schema
        self.chino.schemas.createSchema(repository_id: repo.repository_id, description: schema_description, structure: structure) { (response) in
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidSchema(schema: schema))
            XCTAssert(schema.description==schema_description)
            check = false
        }
        while(check) {}
        check = true
        
        fields = [Field]()
        fields.append(Field(type: "string", name: "name", indexed: true))
        fields.append(Field(type: "string", name: "last_name", indexed: true))
        fields.append(Field(type: "date", name: "date_birth", indexed: true))
        fields.append(Field(type: "string", name: "role"))
        let userSchemaStructure: UserSchemaStructure = UserSchemaStructure(fields: fields)
        
        //Create a UserSchema
        self.chino.user_schemas.createUserSchema(description: user_schema_description, structure: userSchemaStructure) { (response) in
            do{
                user_schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUserSchema(user_schema: user_schema))
            XCTAssert(user_schema.description==user_schema_description)
            check = false
        }
        while(check) {}
        check = true
        
        sleep(3)
        
        //Create doctor

        var attributes = ["name": "doctor_name", "last_name": "doctor_last_name", "date_birth": "1960-01-01", "role": "doctor"] as [String : Any]
        
        chino.users.createUser(username: "doctor_username", password: "doctor_password", user_schema_id: user_schema.user_schema_id, attributes: attributes as NSDictionary) { (response) in
            do{
                doctor = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: doctor))
            check = false
        }
        while(check) {}
        check = true
        
        //Create first patient
        
        attributes = ["name": "first_patient_name", "last_name": "first_patient_last_name", "date_birth": "1960-01-01", "role": "patient"] as [String : Any]
        
        chino.users.createUser(username: "first_patient_username", password: "first_patient_password", user_schema_id: user_schema.user_schema_id, attributes: attributes as NSDictionary) { (response) in
            do{
                first_patient = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: first_patient))
            check = false
        }
        while(check) {}
        check = true
        
        //Create second patient
        
        attributes = ["name": "second_patient_name", "last_name": "second_patient_last_name", "date_birth": "1960-01-01", "role": "patient"] as [String : Any]
        
        chino.users.createUser(username: "second_patient_username", password: "second_patient_password", user_schema_id: user_schema.user_schema_id, attributes: attributes as NSDictionary) { (response) in
            do{
                second_patient = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: second_patient))
            check = false
        }
        while(check) {}
        check = true
        
        //Create first document
        
        var content = ["patient_id": first_patient.user_id, "doctor_id": doctor.user_id, "visit_type": "routine", "visit": "visit_description", "date": "2017-01-04T10:25:36"] as [String : Any]
        
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
            do{
                first_document = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidCreateDocumentResponse(doc: first_document))
            check = false
        }
        while(check) {}
        check = true
        
        //Create second document
        
        content = ["patient_id": first_patient.user_id, "doctor_id": doctor.user_id, "visit_type": "routine", "visit": "visit_description", "date": "2017-01-06T12:03:45"] as [String : Any]
        
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
            do{
                second_document = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidCreateDocumentResponse(doc: second_document))
            check = false
        }
        while(check) {}
        check = true
        
        //Create third document
        
        content = ["patient_id": second_patient.user_id, "doctor_id": doctor.user_id, "visit_type": "insurance_exams", "visit": "visit_description", "date": "2017-01-06T15:03:34"] as [String : Any]
        
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
            do{
                third_document = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidCreateDocumentResponse(doc: third_document))
            check = false
        }
        while(check) {}
        check = true
        
        //Search all Documents with the id of a specific User
        print("Search all Documents with the id of a specific User")
        var filter = [FilterOption(type: FilterOption.TypeValues.equal, field: "patient_id", value: first_patient.user_id)]
        var sort = [SortOption(field: "date", order: "asc")]
        var request = SearchRequest(result_type: SearchRequest.ResultTypeValues.full_content, filter_type: SearchRequest.FilterTypeValues.or, sort: sort, filter: filter)
        self.chino.search.searchDocuments(search_request: request, schema_id: schema.schema_id) { (response) in
            var documents: GetDocumentsResponse!
            do{
                documents = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            print(documents)
            check = false
        }
        
        while(check) {}
        check = true
        
        //Search all Documents created after a specific date
        print("Search all Documents created after a specific date")
        filter = [FilterOption(type: FilterOption.TypeValues.greater_than, field: "date", value: "2017-01-05T00:00:00")]
        sort = [SortOption(field: "date", order: "asc")]
        request = SearchRequest(result_type: SearchRequest.ResultTypeValues.full_content, filter_type: SearchRequest.FilterTypeValues.or, sort: sort, filter: filter)
        chino.search.searchDocuments(search_request: request, schema_id: schema.schema_id) { (response) in
            var documents: GetDocumentsResponse!
            do{
                documents = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            print(documents)
            check = false
        }
        while(check) {}
        check = true
        
        //Search User with a specific name
        print("Search User with a specific name")
        filter = [FilterOption(type: FilterOption.TypeValues.equal, field: "name", value: "first_patient_name")]
        sort = [SortOption(field: "date_birth", order: "asc")]
        request = SearchRequest(result_type: SearchRequest.ResultTypeValues.full_content, filter_type: SearchRequest.FilterTypeValues.and, sort: sort, filter: filter)
        chino.search.searchUsers(search_request: request, user_schema_id: user_schema.user_schema_id) { (response) in
            var users: GetUsersResponse!
            do{
                users = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            print(users)
            check = false
        }
        while(check) {}
        check = true
        
        //Search if a User with a specific username exists
        print("Search if a User with a specific name exists")
        filter = [FilterOption(type: FilterOption.TypeValues.equal, field: "username", value: "first_patient_username")]
        sort = [SortOption(field: "date_birth", order: "asc")]
        request = SearchRequest(result_type: SearchRequest.ResultTypeValues.username_exists, filter_type: SearchRequest.FilterTypeValues.and, sort: sort, filter: filter)
        chino.search.searchUsers(search_request: request, user_schema_id: user_schema.user_schema_id) { (response) in
            var users: GetUsersResponse!
            do{
                users = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(users.exists==true)
            print(users)
            check = false
        }
        while(check) {}
        check = true
        
        //Search if a User with a specific name exists
        print("Search if a User with a specific name exists")
        filter = [FilterOption(type: FilterOption.TypeValues.equal, field: "name", value: "first_patient_name")]
        sort = [SortOption(field: "date_birth", order: "asc")]
        request = SearchRequest(result_type: SearchRequest.ResultTypeValues.exists, filter_type: SearchRequest.FilterTypeValues.and, sort: sort, filter: filter)
        chino.search.searchUsers(search_request: request, user_schema_id: user_schema.user_schema_id) { (response) in
            var users: GetUsersResponse!
            do{
                users = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(users.exists==true)
            print(users)
            check = false
        }
        while(check) {}
        check = true
        
        //Search for Documents created in a specific day
        print("Search all Documents created after a specific date")
        filter = [FilterOption(type: FilterOption.TypeValues.greater_than, field: "date", value:   "2017-01-04T00:00:00"),
                  FilterOption(type: FilterOption.TypeValues.lower_than, field: "date", value: "2017-01-05T00:00:00")]
        sort = [SortOption(field: "date", order: "asc")]
        request = SearchRequest(result_type: SearchRequest.ResultTypeValues.full_content, filter_type: SearchRequest.FilterTypeValues.and, sort: sort, filter: filter)
        chino.search.searchDocuments(search_request: request, schema_id: schema.schema_id) { (response) in
            var documents: GetDocumentsResponse!
            do{
                documents = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            print(documents)
            check = false
        }
        while(check) {}
        check = true
        
        //Search for Documents created after a specific date or with a visit_type pertaining to a list
        print("Search all Documents created after a specific date")
        filter = [FilterOption(type: FilterOption.TypeValues.greater_than, field: "date", value:   "2017-01-06T15:00:00"),
                  FilterOption(type: FilterOption.TypeValues.in_list, field: "visit_type", value: ["routine","physical_insurance_exams"])]
        sort = [SortOption(field: "date", order: "asc")]
        request = SearchRequest(result_type: SearchRequest.ResultTypeValues.only_id, filter_type: SearchRequest.FilterTypeValues.or, sort: sort, filter: filter)
        chino.search.searchDocuments(search_request: request, schema_id: schema.schema_id) { (response) in
            var documents: GetDocumentsResponse!
            do{
                documents = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            print(documents)
            check = false
        }
        while(check) {}
        check = true
    }
    
    func testApplications(){
        var check = true
        var app_id = ""
        
        //Test create application
        chino.applications.createApplication(name: "test_application", grantType: GrantTypeValues.password, clientType: ClientTypeValues.client_public, redirectUrl: "") { (response) in
            var app: Application!
            do{
                app = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidApplication(app: app))
            XCTAssert(app.app_name == "test_application")
            app_id = app.app_id
            check = false
        }
        while(check){}
        check=true
        
        //Test get application
        self.chino.applications.getApplication(application_id: app_id) { (response) in
            var app: Application!
            do{
                app = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidApplication(app: app))
            XCTAssert(app.app_name == "test_application")
            check=false
        }
        while(check){}
        check=true
        
        //Test update application
        self.chino.applications.updateApplication(application_id: app_id, name: "test_application_update", grantType: GrantTypeValues.password, clientType: ClientTypeValues.client_public, redirectUrl: "") { (response) in
            var app: Application!
            do{
                app = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidApplication(app: app))
            XCTAssert(app.app_name == "test_application_update")
            check=false
        }
        while(check){}
        check=true
        
        var app_counter = 1
        //Test list applications
        self.chino.applications.listApplications() { (response) in
            var apps: GetApplicationsResponse!
            do{
                apps = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            app_counter = apps.count
            for a in apps.applications {
                XCTAssert(assertValidListApplicationsObject(app: a))
                        
                //Test delete application
                self.chino.applications.deleteApplication(application_id: a.app_id, force: true) { (response) in
                    var result: String!
                    do{
                        result = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(result=="success")
                    app_counter = app_counter-1
                    check = false
                }
                while(check){}
                check = true
            }
        }
        while(app_counter>0){}
    }
    
    func testAuth(){
        var check=true
        let description = "test_description"
        
        let username="jacob@gmail.com"+String(arc4random_uniform(300))
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
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (response) in
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        let attributes = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        
        self.chino.users.createUser(username: username, password: password, user_schema_id: schema.user_schema_id, attributes: attributes as NSDictionary) { (response) in
            do{
                user = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        self.chino.applications.createApplication(name: "test_app", grantType: GrantTypeValues.password, clientType: ClientTypeValues.client_public, redirectUrl: "") { (response) in
            do{
                app = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        //Test login with password without the app_secret
        self.chino.auth.loginWithPassword(username: username, password: password, app_id: app.app_id, app_secret: "") { (response) in
            do{
                loggedUser = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidLoggedUser(user: loggedUser))
            check = false
        }
        while(check){}
        check = true
        
        //Test refresh token
        self.chino.auth.refreshToken(refresh_token: loggedUser.refresh_token, app_id: app.app_id, app_secret: app.app_secret) { (response) in
            do{
                loggedUser = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidLoggedUser(user: loggedUser))
            check = false
        }
        while(check){}
        check = true
        
        //Test user detail
        self.chino.users.me() { (response) in
            do{
                user = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidUser(user: user))
            XCTAssert(user?.attributes["last_name"] as! String == "Storti")
            check = false
        }
        while(check){}
        check = true
        
        //Test logout
        self.chino.auth.logout(token: loggedUser.access_token, app_id: app.app_id, app_secret: app.app_secret) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            print(result)
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        self.chino=ChinoAPI.init(hostUrl: URL, customerId: CUSTOMER_ID, customerKey: CUSTOMER_KEY)
            
        self.chino.users.deleteUser(user_id: user.user_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        self.chino.user_schemas.deleteUserSchema(user_schema_id: schema.user_schema_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        self.chino.applications.deleteApplication(application_id: app.app_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
        
        chino.user_schemas.createUserSchema(description: description, structure: structure) { (response) in
            do{
                user_schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        let attributes = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        
        self.chino.users.createUser(username: username, password: password, user_schema_id: user_schema.user_schema_id, attributes: attributes as NSDictionary) { (response) in
            do{
                user = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        self.chino.applications.createApplication(name: "test_app", grantType: GrantTypeValues.password, clientType: ClientTypeValues.client_public, redirectUrl: "") { (response) in
            do{
                app = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        self.chino.repositories.createRepository(description: "test_repo") { (response) in
            do{
                repo = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        fields = [Field]()
        fields.append(Field(type: "string", name: "name"))
        fields.append(Field(type: "string", name: "last_name"))
        fields.append(Field(type: "integer", name: "test_integer"))
        let schemaStructure: SchemaStructure = SchemaStructure(fields: fields)
        
        self.chino.schemas.createSchema(repository_id: repo.repository_id, description: "test_schema", structure: schemaStructure) { (response) in
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
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
            do {
                let result = try result()
                XCTAssert(result == "success")
                check = false
            } catch let error {
                print((error as! ChinoError).toString())
            }
        }
        while(check){}
        check = true
        
        self.chino.auth.loginWithPassword(username: username, password: password, app_id: app.app_id, app_secret: app.app_secret) { (response) in
            do{
                loggedUser = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidLoggedUser(user: loggedUser))
            check = false
        }
        while(check){}
        check = true
        
        let content: NSDictionary = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123]
        
        sleep(2)
        
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content) { (response) in
            do{
                document = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(assertValidCreateDocumentResponse(doc: document))
            check = false
        }
        while(check){}
        check = true
        
        self.chino.auth.logout(token: loggedUser.access_token, app_id: app.app_id, app_secret: app.app_secret) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result == "success")
            check = false
        }
        while(check){}
        check = true
        
        chino = ChinoAPI(hostUrl: URL, customerId: CUSTOMER_ID, customerKey: CUSTOMER_KEY)

        chino.documents.deleteDocument(document_id: document.document_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        chino.repositories.deleteRepository(repository_id: repo.repository_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        chino.users.deleteUser(user_id: user.user_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
        
        chino.user_schemas.deleteUserSchema(user_schema_id: user_schema.user_schema_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            check = false
        }
        while(check){}
        check = true
    }
    
    func testBlobs(){
        
        let path = ""
        let destination = ""
        let name = ""
        let description = "test_description"
        var check=true
        
        var schema: Schema!
        var repo: Repository!
        var doc: CreateDocumentResponse!
        var blob: Blob!
        var blobResponse: GetBlobResponse!
        var result: String!
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name", indexed: true))
        fields.append(Field(type: "string", name: "last_name", indexed: true))
        fields.append(Field(type: "integer", name: "test_integer", indexed: true))
        fields.append(Field(type: "blob", name: "test_blob"))
        let structure: SchemaStructure = SchemaStructure(fields: fields)
        
        chino.repositories.createRepository(description: "test-repo-description") { (response) in
            do{
                repo = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        self.chino.schemas.createSchema(repository_id: repo.repository_id, description: description, structure: structure) { (response) in
            do{
                schema = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        let content = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
        
        sleep(2)
        
        self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
            do{
                doc = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        self.chino.blobs.uploadBlob(path: path, document_id: doc.document_id, field: "test_blob", file_name: name) { (response) in
            do{
                blob = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
            

        self.chino.blobs.get(blob_id: (blob?.blob_id)!, destination: destination) { (response) in
            do{
                blobResponse = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            print("MD5: "+(blobResponse?.md5)!)
            print("SHA1: "+(blobResponse?.sha1)!)
            check = false
        }
        while(check){}
        check = true
        
        self.chino.blobs.deleteBlob(blob_id: (blob?.blob_id)!) { (response) in
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            print("Delete blob: "+result!)
            check = false
        }
        while(check){}
        check = true
            
        self.chino.documents.deleteDocument(document_id: doc.document_id, force: true) { (response) in
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            print("Delete document: "+result!)
            check = false
        }
        while(check){}
        check = true
            
            
        self.chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (response) in
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            print("Delete schema: "+result!)
            check = false
        }
        while(check){}
        check = true
        self.chino.repositories.deleteRepository(repository_id: repo.repository_id, force: true) { (response) in
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            print("Delete repo: "+result!)
            check = false
        }
        while(check){}
    }

    func testErrors(){
        var check = true
        chino.repositories.listRepositories(offset: 0, limit: 101) { (response) in
            do {
                _ = try response()
            } catch let error {
                XCTAssert((error as! ChinoError).code==400)
                check = false
            }
        }
        while(check){}
        check = true
        
        chino.repositories.listRepositories(offset: -1, limit: 50) { (response) in
            do {
                _ = try response()
            } catch let error {
                XCTAssert((error as! ChinoError).code==400)
                check = false
            }
        }
        while(check){}
        check = true
        
        chino.repositories.getRepository(repository_id: "") { (response) in
            do {
                _ = try response()
            } catch let error {
                XCTAssert((error as! ChinoError).code==404)
                check = false
            }
        }
        while(check){}
        check = true
        
        chino.repositories.updateRepository(repository_id: "", description: "") { (response) in
            do {
                _ = try response()
            } catch let error {
                XCTAssert((error as! ChinoError).code==404)
                check = false
            }
        }
        while(check){}
        check = true
        
        chino.repositories.deleteRepository(repository_id: "", force: true) { (response) in
            do{
                _ = try response()
            } catch let error {
                XCTAssert((error as! ChinoError).code==404)
                check = false
            }
        }
        while(check){}
        check = true
        
        chino = ChinoAPI(hostUrl: "", customerId: CUSTOMER_ID, customerKey: CUSTOMER_KEY)
        chino.repositories.createRepository(description: "test") { (response) in
            do{
                _ = try response()
                XCTFail()
            } catch let error {
                print((error as! ChinoError).toString())
                check = false
            }
        }
        while(check){}
        check = true
        
        chino = ChinoAPI(hostUrl: URL, customerId: CUSTOMER_ID, customerKey: "")
        chino.repositories.createRepository(description: "test") { (response) in
            do{
                _ = try response()
            } catch let error {
                XCTAssert((error as! ChinoError).code==401)
                check = false
            }
        }
        while(check){}
        check = true
        
        chino = ChinoAPI(hostUrl: URL, customerId: "", customerKey: CUSTOMER_KEY)
        chino.repositories.createRepository(description: "test") { (response) in
            do{
                _ = try response()
            } catch let error {
                XCTAssert((error as! ChinoError).code==401)
                check = false
            }
        }
        while(check){}
        check = true
        
        chino = ChinoAPI(hostUrl: URL, customerId: CUSTOMER_ID, customerKey: CUSTOMER_KEY)
        
        var fields = [Field]()
        fields.append(Field(type: "", name: "", indexed: true))
        let structure = UserSchemaStructure(fields: fields)
        chino.user_schemas.createUserSchema(description: "", structure: structure) { (response) in
            do{
                _ = try response()
            } catch let error {
                print((error as! ChinoError).toString())
                XCTAssert((error as! ChinoError).code==400)
                check = false
            }
        }
        while(check){}
        check = true
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
