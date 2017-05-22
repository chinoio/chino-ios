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

    var chino: ChinoAPI!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
        chino = ChinoAPI(hostUrl: Credentials.url, customerId: Credentials.customer_id, customerKey: Credentials.customer_key)

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
        
        var repo_count=1
        
        //Test list repositories
        self.chino.repositories.listRepositories(offset: 0, limit: 100) { (response) in
            var repos: GetRepositoriesResponse!
            do{
                repos = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            repo_count = (repos?.count)!
            
            for value in (repos?.repositories)! {
                XCTAssert(assertValidRepository(repository: value))
                XCTAssert(value.description==description_updated || value.description==description)
                
                //Test delete repository
                self.chino.repositories.deleteRepository(repository_id: value.repository_id, force: true) { (response) in
                    var result: String!
                    do{
                        result = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(result=="success")
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
        let description = "test_description"
        var check=true
        var schema_id = ""
        var repo_id = ""
        
        var fields = [Field]()
        fields.append(Field(type: "string", name: "name", indexed: true))
        fields.append(Field(type: "string", name: "last_name", indexed: true))
        fields.append(Field(type: "integer", name: "test_integer", indexed: true))
        let structure: SchemaStructure = SchemaStructure(fields: fields)
        
        chino.repositories.createRepository(description: "test-repo-description") { (response) in
            var repo: Repository!
            do{
                repo = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            repo_id = repo.repository_id
            self.chino.schemas.createSchema(repository_id: repo.repository_id, description: description, structure: structure) { (response) in
                var schema: Schema!
                do{
                    schema = try response()
                } catch let error {
                    print((error as! ChinoError).toString())
                }
                XCTAssert(assertValidSchema(schema: schema))
                XCTAssert(schema.description==description)

                schema_id = schema.schema_id
                var content = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
                
                sleep(2)
                
                self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
                    var doc: CreateDocumentResponse!
                    do{
                        doc = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    XCTAssert(assertValidCreateDocumentResponse(doc: doc))
                    
                    content = ["name": "Mario", "last_name": "Rossi", "test_integer": 1234]

                    self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
                        var doc: CreateDocumentResponse!
                        do{
                            doc = try response()
                        } catch let error {
                            print((error as! ChinoError).toString())
                        }
                        XCTAssert(assertValidCreateDocumentResponse(doc: doc))
                        
                        //Test search documents
                        let filter = [FilterOption(type: FilterOption.TypeValues.equal, field: "name", value: "Mario")]
                        let sort = [SortOption(field: "test_integer", order: "asc")]
                        let request = SearchRequest(result_type: SearchRequest.ResultTypeValues.full_content, filter_type: SearchRequest.FilterTypeValues.or, sort: sort, filter: filter)
                        self.chino.search.searchDocuments(search_request: request, schema_id: schema.schema_id) { (response) in
                            var documents: GetDocumentsResponse!
                            do{
                                documents = try response()
                            } catch let error {
                                print((error as! ChinoError).toString())
                            }
                            print(documents)
                        }
                    
                        self.chino.documents.listDocumentsWithoutContent(schema_id: schema.schema_id) { (response) in
                            var docs: GetDocumentsResponse!
                            do{
                                docs = try response()
                            } catch let error {
                                print((error as! ChinoError).toString())
                            }
                            var count = docs.count
                            for d in docs.documents {
                                XCTAssert(assertValidCreateDocumentResponse(doc: d))
                                
                                self.chino.documents.deleteDocument(document_id: d.document_id, force: true) { (response) in
                                    var result: String!
                                    do{
                                        result = try response()
                                    } catch let error {
                                        print((error as! ChinoError).toString())
                                    }
                                    XCTAssert(result=="success")
                                    print("Document deleted!")
                                    count = count-1
                                }
                            }
                            while(count>0){
                                
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
        self.chino.schemas.deleteSchema(schema_id: schema_id, force: true) { (response) in
            var result: String!
            do{
                result = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            XCTAssert(result=="success")
            print("Schema deleted!")
            self.chino.repositories.deleteRepository(repository_id: repo_id, force: true) { (response) in
                var result: String!
                do{
                    result = try response()
                } catch let error {
                    print((error as! ChinoError).toString())
                }
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
        chino.applications.createApplication(name: "test_application", grantType: GrantTypeValues.password, redirectUrl: "") { (response) in
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
        self.chino.applications.updateApplication(application_id: app_id, name: "test_application_update", grantType: GrantTypeValues.password, redirectUrl: "") { (response) in
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
        
        self.chino.applications.createApplication(name: "test_app", grantType: GrantTypeValues.password, redirectUrl: "") { (response) in
            do{
                app = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            check = false
        }
        while(check){}
        check = true
        
        //Test login with password
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
        
        self.chino=ChinoAPI.init(hostUrl: Credentials.url, customerId: Credentials.customer_id, customerKey: Credentials.customer_key)
            
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
        
        self.chino.applications.createApplication(name: "test_app", grantType: GrantTypeValues.password, redirectUrl: "") { (response) in
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
        
        self.chino.auth.logout(token: loggedUser.access_token, app_id: app.app_id, app_secret: app.app_name) { (response) in
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
        
        chino = ChinoAPI(hostUrl: Credentials.url, customerId: Credentials.customer_id, customerKey: Credentials.customer_key)

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
        
        chino.repositories.createRepository(description: "test-repo-description") { (response) in
            var repo: Repository!
            do{
                repo = try response()
            } catch let error {
                print((error as! ChinoError).toString())
            }
            self.chino.schemas.createSchema(repository_id: repo.repository_id, description: description, structure: structure) { (response) in
                var schema: Schema!
                do{
                    schema = try response()
                } catch let error {
                    print((error as! ChinoError).toString())
                }
                let content = ["name": "Giacomino", "last_name": "Storti", "test_integer": 123] as [String : Any]
                
                sleep(2)
                
                self.chino.documents.createDocument(schema_id: schema.schema_id, content: content as NSDictionary) { (response) in
                    var doc: CreateDocumentResponse!
                    do{
                        doc = try response()
                    } catch let error {
                        print((error as! ChinoError).toString())
                    }
                    self.chino.blobs.uploadBlob(path: path, document_id: doc.document_id, field: "test_blob", file_name: name) { (response) in
                        var blob: Blob!
                        do{
                            blob = try response()
                        } catch let error {
                            print((error as! ChinoError).toString())
                        }
                        self.chino.blobs.get(blob_id: (blob?.blob_id)!, destination: destination) { (response) in
                            var blobResponse: GetBlobResponse!
                            do{
                                blobResponse = try response()
                            } catch let error {
                                print((error as! ChinoError).toString())
                            }
                            print("MD5: "+(blobResponse?.md5)!)
                            print("SHA1: "+(blobResponse?.sha1)!)
                            
                            self.chino.blobs.deleteBlob(blob_id: (blob?.blob_id)!) { (response) in
                                var result: String!
                                do{
                                    result = try response()
                                } catch let error {
                                    print((error as! ChinoError).toString())
                                }
                                XCTAssert(result=="success")
                                print("Delete blob: "+result!)
                                self.chino.documents.deleteDocument(document_id: doc.document_id, force: true) { (response) in
                                    do{
                                        result = try response()
                                    } catch let error {
                                        print((error as! ChinoError).toString())
                                    }
                                    XCTAssert(result=="success")
                                    print("Delete document: "+result!)
                                    self.chino.schemas.deleteSchema(schema_id: schema.schema_id, force: true) { (response) in
                                        do{
                                            result = try response()
                                        } catch let error {
                                            print((error as! ChinoError).toString())
                                        }
                                        XCTAssert(result=="success")
                                        print("Delete schema: "+result!)
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
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
