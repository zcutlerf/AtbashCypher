//
//  EnglishificationService.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

protocol Englishifier {
    associatedtype Service: HTTPService
    
    /// The service to use for englishification.
    var service: Service { get }
    
    /// Tries to take a decoded Atbash message and add punctuation and whitespace back in, for improved readability.
    /// - Parameter decodedMessage: An alphanumeric string without whitespace or punctuation.
    /// - Returns: A version of `decodedMessage` with punctuation and whitespace restored.
    func attemptEnglishification(of decodedMessage: String) async throws -> String
}
