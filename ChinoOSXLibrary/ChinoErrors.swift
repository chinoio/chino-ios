//
//  ChinoErrors.swift
//  ChinoOSXLibrary
//
//  Created by Chino on 11/05/2017.
//  Copyright © 2017 Chino. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

protocol ChinoErrorProtocol: Error {
    
    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var code: Int { get }
}

public struct ChinoError: ChinoErrorProtocol {
    
    public var localizedTitle: String
    public var localizedDescription: String
    public var code: Int
    
    public init(localizedDescription: String, code: Int) {
        self.localizedTitle = "Error"
        self.localizedDescription = localizedDescription
        self.code = code
        self.localizedTitle = checkErrorCode(code)
    }
    
    func checkErrorCode(_ errorCode: Int) -> String {
        switch errorCode {
        case 400:
            return "Bad Request"
        case 401:
            return "Not Authorized"
        case 403:
            return "Forbidden"
        case 404:
            return "Not Found"
        case 405:
            return "Method Not Allowed"
        case 500:
            return "Internal Error"
        case 503:
            return "Temporary Unavailable"
        default:
            return "Error"
        }
    }
    
    public func toString() -> String {
        let result = self.localizedTitle+" "+String(self.code)+": "+self.localizedDescription
        return result
    }
}
