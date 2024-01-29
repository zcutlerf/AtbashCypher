//
//  main.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

class Cypher: AtbashCodable, Englishifier {
    let service: any HTTPService
    
    init(service: any HTTPService) {
        self.service = service
    }
    
    func encode(_ message: String) -> String {
        ""
    }
    
    func decode(_ message: String) -> String {
        ""
    }
    
    func attemptEnglishification(of decodedMessage: String) -> String {
        ""
    }
}
