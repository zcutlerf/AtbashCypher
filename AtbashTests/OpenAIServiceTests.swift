//
//  OpenAIServiceTests.swift
//  AtbashTests
//
//  Created by Zoe Cutler on 1/29/24.
//

import XCTest

class OpenAIServiceTests: XCTestCase {
    func test_chat_success() async throws {
        let sut = makeSUT()
        let url = URL(string: "https://my.amazing.api/endpoint")!
        let expectedResponse = "A sample response."
        let jsonString = """
                         {
                           "choices": [
                             {
                               "message": {
                                 "content": "\(expectedResponse)",
                                 "role": "assistant"
                               },
                             }
                           ],
                         }
                         """
        let data = jsonString.data(using: .utf8)
        MockURLSession.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        let actualResponse = try await sut.chat(prompt: "A sample prompt.")
        
        XCTAssertEqual(actualResponse, expectedResponse)
    }
    
    func test_chat_noAvailableChoices() async {
        func test_chat_success() async throws {
            let sut = makeSUT()
            let url = URL(string: "https://my.amazing.api/endpoint")!
            let jsonString = """
                             {
                               "choices": [],
                             }
                             """
            let data = jsonString.data(using: .utf8)
            MockURLSession.requestHandler = { request in
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            }
            
            do {
                let _ = try await sut.chat(prompt: "A sample prompt.")
                XCTFail("Did not fail.")
            } catch OpenAIService.OpenAIError.noResponseChoicesAvailable {
                // Success
            } catch {
                XCTFail("Received this error instead: \(error.localizedDescription)")
            }
        }
    }
    
    func test_chat_invalidDataFormat() async throws {
        let sut = makeSUT()
        let url = URL(string: "https://my.amazing.api/endpoint")!
        let data = Data()
        MockURLSession.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        do {
            let _ = try await sut.chat(prompt: "A sample prompt.")
            XCTFail("Did not fail.")
        } catch Swift.DecodingError.dataCorrupted(_) {
            // Success
        } catch {
            XCTFail("Received this error instead: \(error.localizedDescription)")
        }
    }
    
    private func makeSUT() -> OpenAIService {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLSession.self]
        let urlSession = URLSession.init(configuration: configuration)
        return OpenAIService(urlSession: urlSession)
    }
}
