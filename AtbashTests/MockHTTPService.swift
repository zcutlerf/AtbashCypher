//
//  MockHTTPService.swift
//  AtbashTests
//
//  Created by Zoe Cutler on 1/26/24.
//
import Foundation

class MockHTTPService: HTTPService {
    static var scheme: String { "https" }
    static var host: String { "my.amazing.api" }
    
    enum Endpoint: EndpointProtocol {
        case fake
        
        var path: String { "/fake" }
    }
    
    enum QueryItem: String, QueryItemProtocol {
        case oneQueryItem = "one"
        case anotherQueryItem = "another"
    }
}

class BrokenHTTPService: HTTPService {
    static var scheme: String { "failure" }
    static var host: String { "/,/43,&&</,&" }
    
    enum Endpoint: EndpointProtocol {
        case fake
        
        var path: String { "/fake" }
    }
    
    enum QueryItem: String, QueryItemProtocol {
        case none
    }
}
