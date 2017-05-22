//
//  PermissionRule.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 27/04/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

open class PermissionRule{
    
    open var authorize: [RuleValues]
    open var manage: [RuleValues]
    open var created_document: PermissionRule!
    
    public init() {
        self.authorize = []
        self.manage = []
    }
    
    public init(authorize: [RuleValues], manage: [RuleValues]) {
        self.authorize = authorize
        self.manage = manage
    }

    public init(authorize: [RuleValues], manage: [RuleValues], created_document: PermissionRule) {
        self.authorize = authorize
        self.manage = manage
        self.created_document = created_document
    }
    
    public func toString() -> String {
        let dict = NSMutableDictionary()
        if authorize.count > 0 {
            let authorizeArray = returnStringArray(rule_array: authorize)
            dict.addEntries(from: ["authorize": authorizeArray])
        }
        if manage.count > 0 {
            let manageArray = returnStringArray(rule_array: manage)
            dict.addEntries(from: ["manage": manageArray])
        }
        if created_document != nil {
            dict.addEntries(from: ["created_document": created_document.toDict()])
        }
        return dict.returnJson()
    }
    
    func toDict() -> NSDictionary {
        let dict = NSMutableDictionary()
        if authorize.count > 0 {
            let authorizeArray = returnStringArray(rule_array: authorize)
            dict.addEntries(from: ["authorize": authorizeArray])
        }
        if manage.count > 0 {
            let manageArray = returnStringArray(rule_array: manage)
            dict.addEntries(from: ["manage": manageArray])
        }
        return dict
    }
    
    func returnStringArray(rule_array: [RuleValues]) -> [String] {
        var temp_array = [String]()
        for r in rule_array {
            temp_array.append(r.returnValue(value: r))
        }
        return temp_array
    }
}
