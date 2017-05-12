//
//  Values.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 09/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

public enum GrantTypeValues {
    case password, authorization_code
    func returnValue(value: GrantTypeValues) -> String {
        switch value {
        case .password:
            return "password"
        case .authorization_code:
            return "authorization-code"
        }
    }
}

public enum ActionValues {
    case grant, revoke
    
    func returnValue(value: ActionValues) -> String {
        switch value {
        case .grant:
            return "grant"
        case .revoke:
            return "revoke"
        }
    }
}

public enum ResourceValues {
    case groups, user_schemas, repositories, schemas
    
    func returnValue(value: ResourceValues) -> String {
        switch value {
        case .groups:
            return "groups"
        case .user_schemas:
            return "user_schemas"
        case .repositories:
            return "repositories"
        case .schemas:
            return "schemas"
        }
    }
}

public enum ResourceChildrenValues {
    case users, schemas, documents
    
    func returnValue(value: ResourceChildrenValues) -> String {
        switch value {
        case .users:
            return "users"
        case .schemas:
            return "schemas"
        case .documents:
            return "documents"
        }
    }
}

public enum SubjectValues {
    case users, groups
    
    func returnValue(value: SubjectValues) -> String {
        switch value {
        case .users:
            return "users"
        case .groups:
            return "groups"
        }
    }
}

public enum RuleValues {
    case create, read, update, delete, list, administer, search
    
    func returnValue(value: RuleValues) -> String {
        switch value {
        case .create:
            return "C"
        case .read:
            return "R"
        case .update:
            return "U"
        case .delete:
            return "D"
        case .list:
            return "L"
        case .administer:
            return "A"
        case .search:
            return "S"
        }
    }
}
