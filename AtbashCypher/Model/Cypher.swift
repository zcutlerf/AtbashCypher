//
//  Cypher.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/29/24.
//

import Foundation

/// Implementation of AtbashCypher that can encode and decode messages in the latin alphabet using the atbash method.
/// https://en.wikipedia.org/wiki/Atbash
class Cypher: AtbashCodable, Englishifier {
    var service = OpenAIService()
    
    func encode(_ message: String) -> String {
        message
            .lowercased()
            .filter { character in
                !character.isPunctuation && !character.isWhitespace
            }
            .enumerated().map { (index, character) in
                String(reverse(character)) + (index % 5 == 4 ? " " : "")
            }
            .joined()
            .trimmingCharacters(in: .whitespaces)
    }
    
    func decode(_ message: String) -> String {
        message
            .filter { character in
                !character.isWhitespace
            }
            .map { character in
                String(reverse(character))
            }
            .joined()
    }
    
    private func reverse(_ letter: Character) -> Character {
        guard letter.isLetter else {
            return letter
        }
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        let position = 25 - (alphabet.firstIndex(of: letter)?.utf16Offset(in: alphabet) ?? 0)
        let index = alphabet.index(alphabet.startIndex, offsetBy: position)
        return alphabet[index]
    }
    
    func attemptEnglishification(of decodedMessage: String) async throws -> String {
        let maxTokens = decodedMessage.count / 3
        let prompt = "This message was decoded from a cypher without spaces or punctuation. Please add it back in.\n\(decodedMessage)"
        return try await service.chat(prompt: prompt, maxTokens: maxTokens)
    }
}
