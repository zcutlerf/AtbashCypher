//
//  CypherIntegrationTests.swift
//  AtbashTests
//
//  Created by Zoe Cutler on 1/29/24.
//

import XCTest

final class CypherIntegrationTests: XCTestCase {
    func test_attemptEnglishification_quickBrownFox() async throws {
        let sut = Cypher()
        let decodedMessage = "thequickbrownfoxjumpedoverthelazydog"
        
        let response = try await sut.attemptEnglishification(of: decodedMessage)
        let cleaned = response.filter { !$0.isPunctuation }
        
        XCTAssertEqual(cleaned, "The quick brown fox jumped over the lazy dog")
    }
    
    func test_attemptEnglishification_secretMessage() async throws {
        let sut = Cypher()
        let decodedMessage = "thisisasecretmessagefromthefbi"
        
        let response = try await sut.attemptEnglishification(of: decodedMessage)
        let cleaned = response.filter { !$0.isPunctuation }
        
        XCTAssertEqual(cleaned, "This is a secret message from the FBI")
    }
    
    func test_attemptEnglishification_cantDoAnything() async throws {
        let sut = Cypher()
        let decodedMessage = "icantdoanything"
        
        let response = try await sut.attemptEnglishification(of: decodedMessage)
        let cleaned = response.filter { !$0.isPunctuation }
        
        XCTAssertEqual(cleaned, "I cant do anything")
    }
    
    func test_attemptEnglishification_paragraph() async throws {
        let sut = Cypher()
        let decodedMessage = "itisaveryweakcipherbecauseitonlyhasonepossiblekeyanditisasimplemonoalphabeticsubstitutioncipherhoweverthismaynothavebeenanissueinthecipherstime"
        
        let response = try await sut.attemptEnglishification(of: decodedMessage)
        let cleaned = response.filter { !$0.isPunctuation }
        
        XCTAssertEqual(cleaned, "It is a very weak cipher because it only has one possible key and it is a simple monoalphabetic substitution cipher However this may not have been an issue in the ciphers time")
    }
}
