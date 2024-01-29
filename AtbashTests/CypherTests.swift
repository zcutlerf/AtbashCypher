//
//  AtbashTests.swift
//  AtbashTests
//
//  Created by Zoe Cutler on 1/26/24.
//

import XCTest

final class CypherTests: XCTestCase {
    func test_encode_ABecomesZ() {
        let sut = createSUT()
        let original = "a"
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "z")
    }
    
    func test_encode_removesCapitalization() {
        let sut = createSUT()
        let original = "A"
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "z")
    }
    
    func test_encode_ignoresNumbers() {
        let sut = createSUT()
        let original = "123a"
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "123z")
    }
    
    func test_encode_ignoresWhitespace() {
        let sut = createSUT()
        let original = "  b\t   \n"
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "y")
    }
    
    func test_encode_excludesPunctuation() {
        let sut = createSUT()
        let original = "ab."
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "zy")
    }
    
    func test_encode_splitsIntoGroupsOfFiveCharacters() {
        let sut = createSUT()
        let original = "abcdefg"
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "zyxwv ut")
    }
    
    func test_encode_splitsIntoMultipleGroupsOfFiveCharacters() {
        let sut = createSUT()
        let original = "aaaaabbbbbccccc"
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "zzzzz yyyyy xxxxx")
    }
    
    func test_encode_exampleSentence() {
        let sut = createSUT()
        let original = "The quick brown fox jumps over the lazy dog!"
        
        let encoded = sut.encode(original)
        
        XCTAssertEqual(encoded, "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt")
    }
    
    func test_decode_ZBackToA() {
        let sut = createSUT()
        let encoded = "z"
        
        let decoded = sut.decode(encoded)
        
        XCTAssertEqual(decoded, "a")
    }
    
    func test_decode_removesWhitespace() {
        let sut = createSUT()
        let encoded = "zzzzz zzzzz z"
        
        let decoded = sut.decode(encoded)
        
        XCTAssertEqual(decoded, "aaaaaaaaaaa")
    }
    
    func test_decode_exampleSentence() {
        let sut = createSUT()
        let encoded = "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt"
        
        let decoded = sut.decode(encoded)
        
        XCTAssertEqual(decoded, "thequickbrownfoxjumpsoverthelazydog")
    }
    
    private func createSUT() -> Cypher {
        Cypher(service: MockHTTPService())
    }
}
