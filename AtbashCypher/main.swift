//
//  main.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

let cypher = Cypher()

let message = "The quick brown fox jumped over the lazy dog."
let encoded = cypher.encode(message)
let decoded = cypher.decode(encoded)
let englishified = try? await cypher.attemptEnglishification(of: decoded)

print("Welcome to the Atbash Cypher!")
print("Original message: \(message)")
print("Encoded message: \(encoded)")
print("Decoded message: \(decoded)")
if let englishified {
    print("Englishified message: \(englishified)")
}
