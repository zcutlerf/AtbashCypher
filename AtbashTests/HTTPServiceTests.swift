//
//  AtbashTests.swift
//  AtbashTests
//
//  Created by Zoe Cutler on 1/26/24.
//

import XCTest

class HTTPServiceTests: XCTestCase {
    func test_url_setsSchemeAndHost() throws {
        let sut = MockHTTPService()
        
        let url = try sut.url()
        
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host(), "my.amazing.api")
    }
    
    func test_url_setsPathExtensionFromEndpoint() throws {
        let sut = MockHTTPService()
        
        let url = try sut.url(to: .fake)
        
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host(), "my.amazing.api")
        XCTAssertEqual(url.pathComponents, ["/", "fake"])
    }
    
    func test_url_oneQueryItems() throws {
        let sut = MockHTTPService()
        
        let url = try sut.url(to: .fake, queryItems: [
            .oneQueryItem: "some value",
        ])
        
        let actualQuery = url.query(percentEncoded: false)
        let expectedQuery = "one=some value"
        XCTAssertEqual(actualQuery, expectedQuery)
    }
    
    func test_url_twoQueryItems() throws {
        let sut = MockHTTPService()
        
        let url = try sut.url(to: .fake, queryItems: [
            .oneQueryItem: "some value",
            .anotherQueryItem: "something else",
        ])
        
        let actualQuery = url.query(percentEncoded: false)
        let expectedQueries = ["another=something else&one=some value", "one=some value&another=something else"]
        XCTAssertTrue(expectedQueries.contains(where: { $0 == actualQuery }))
    }
    
    func test_url_zeroQueryItems() throws {
        let sut = MockHTTPService()
        
        let url = try sut.url(to: .fake)
        
        let actualQuery = url.query(percentEncoded: false)
        let expectedQuery = ""
        XCTAssertEqual(actualQuery, expectedQuery)
    }
    
    func test_url_cannotCreate() {
        let sut = BrokenHTTPService()
        
        do {
            let _ = try sut.url(to: .fake)
            XCTFail("Did not throw error for bad URL.")
        } catch {
            let urlError = error as! URLError
            XCTAssertEqual(urlError.code, .badURL)
        }
    }
    
    func test_request_setsHTTPMethodToPOST() throws {
        let sut = MockHTTPService()
        let url = try sut.url(to: .fake)
        
        let request = try sut.request(url, with: .post)
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
        XCTAssertEqual(request.httpMethod, "POST")
    }
    
    func test_request_zeroHeaderFields() throws {
        let sut = MockHTTPService()
        let url = try sut.url(to: .fake)
        
        let request = try sut.request(url, with: .post)
        
        let actualHeaders = request.allHTTPHeaderFields
        let expectedHeaders: [String: String] = [:]
        XCTAssertEqual(actualHeaders, expectedHeaders)
    }
    
    func test_request_oneHeaderField() throws {
        let sut = MockHTTPService()
        let url = try sut.url(to: .fake)
        
        let request = try sut.request(url, with: .post, headers: [
            .accept: .json,
        ])
        
        let actualHeaders = request.allHTTPHeaderFields
        let expectedHeaders = ["Accept": "application/json"]
        XCTAssertEqual(actualHeaders, expectedHeaders)
    }
    
    func test_request_twoHeaderFields() throws {
        let sut = MockHTTPService()
        let url = try sut.url(to: .fake)
        
        let request = try sut.request(url, with: .post, headers: [
            .accept: .json,
            .authorization: .bearer("API Key"),
        ])
        
        let actualHeaders = request.allHTTPHeaderFields!.map { (key, value) in
            "\(key): \(value)"
        }.sorted(by: <)
        let expectedHeaders = ["Accept: application/json", "Authorization: Bearer API Key"]
        XCTAssertEqual(actualHeaders, expectedHeaders)
    }
    
    func test_request_noBody() throws {
        let sut = MockHTTPService()
        let url = try sut.url(to: .fake)
        
        let request = try sut.request(url, with: .post)
        
        XCTAssertNil(request.httpBody)
    }
    
    func test_request_body() throws {
        let sut = MockHTTPService()
        let url = try sut.url(to: .fake)
        let body = "some data"
        
        let request = try sut.request(url, with: .post, body: body)
        
        XCTAssertNotNil(request.httpBody)
        let decoded = try JSONDecoder().decode(String.self, from: request.httpBody!)
        XCTAssertEqual(decoded, body)
    }
}
