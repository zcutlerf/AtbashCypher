//
//  OpenAIServiceIntegrationTests.swift
//  AtbashTests
//
//  Created by Zoe Cutler on 1/26/24.
//

import XCTest

class OpenAIServiceIntegrationTests: XCTestCase {
    func test_chat_doesNotThrow() async {
        let sut = OpenAIService()
        let prompt = "Say hi."
        
        do {
            let _ = try await sut.chat(prompt: prompt)
        } catch {
            XCTFail("Threw this error: \(error.localizedDescription)")
        }
    }
    
    func test_chat_attemptPrompt() async {
        let sut = OpenAIService()
        let prompt = "Say \"hi\" only."
        
        do {
            let response = try await sut.chat(prompt: prompt)
            let cleaned = response.lowercased().filter { !$0.isPunctuation && !$0.isWhitespace }
            XCTAssertEqual(cleaned, "hi")
        } catch {
            XCTFail("Threw this error: \(error.localizedDescription)")
        }
    }
}
