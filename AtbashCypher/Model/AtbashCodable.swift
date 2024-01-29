//
//  AtbashCodable.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

typealias AtbashCodable = AtbashEncodable & AtbashDecodable

protocol AtbashEncodable {
    /// Decodes a message that was encrypted with the Atbash cypher.
    /// - Parameter message: Encrypted message.
    /// - Returns: A decoded version of the message.
    func encode(_ message: String) -> String
}

protocol AtbashDecodable {
    /// Reverses a lowercase latin character (a-z) into it's opposite position in the alphabet.
    /// - Parameter letter: Letter to reverse.
    /// - Returns: Reversed letter.
    func decode(_ message: String) -> String
}
