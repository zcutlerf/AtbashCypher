//
//  EnglishificationService.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

protocol Englishifier {
    associatedtype Service: HTTPService
    
    var service: Service { get }
    
    func attemptEnglishification(of decodedMessage: String) async throws -> String
}
