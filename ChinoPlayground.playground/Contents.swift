//: Playground - noun: a place where people can play

import UIKit
import ChinoOSXLibrary
import Foundation

var str = "Hello, playground"
var chino = ChinoAPI.init(hostUrl: Credentials.url, customerId: Credentials.customer_id, customerKey: Credentials.customer_key)

//You can try here the functions
chino.repositories.createRepository(description: "test") { (response) in
    var repo: Repository!
    do {
        repo = try response()
    } catch let error {
        print((error as! ChinoError).toString())
    }
    print("lello")
}


