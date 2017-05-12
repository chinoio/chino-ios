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

enum ChinoError: Error {
    case badRequest(String)
}
