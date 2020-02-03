//
//  DataController.swift
//  ChinoOSXLibrary
//
//  Created by Paolo on 12/07/2018.
//  Copyright © 2018 Chino. All rights reserved.
//

import Foundation

open class DataController {
    
    open var on_behalf: Bool
    open var company: String
    open var contact: String
    open var address: String
    open var email: String
    open var VAT: String
    
    public init(){
        self.on_behalf=false
        self.company=""
        self.contact=""
        self.address=""
        self.email=""
        self.VAT=""
    }
    
    public init(on_behalf:Bool, company:String, contact:String, address:String, email:String, VAT:String=""){
        self.on_behalf=on_behalf
        self.company=company
        self.contact=contact
        self.address=address
        self.email=email
        self.VAT=VAT
    }
    
    func toString() -> String {
        var dict = NSDictionary()
        dict = ["on_behalf": self.on_behalf, "company": self.company, "contact": self.contact, "address": self.address, "email": self.email, "VAT": self.VAT]
        return dict.returnJson()
    }
}

extension DataController {
    convenience init(json: [String: Any]) throws {
        
        // Extract on_behalf
        guard let on_behalf = json["on_behalf"] as? Bool else {
            throw SerializationError.missing("on_behalf")
        }
        
        // Extract company
        guard let company = json["company"] as? String else {
            throw SerializationError.missing("company")
        }
        
        // Extract contact
        guard let contact = json["contact"] as? String else {
            throw SerializationError.missing("contact")
        }
        
        // Extract address
        guard let address = json["address"] as? String else {
            throw SerializationError.missing("address")
        }
        
        // Extract email
        guard let email = json["email"] as? String else {
            throw SerializationError.missing("email")
        }
        
        // Extract VAT
        guard let VAT = json["VAT"] as? String else {
            throw SerializationError.missing("VAT")
        }
        
        // Initialize properties
        self.init(on_behalf: on_behalf, company: company, contact: contact, address: address, email: email, VAT: VAT)
    }
}
