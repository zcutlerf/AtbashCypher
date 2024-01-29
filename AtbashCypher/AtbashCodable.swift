//
//  AtbashCodable.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

typealias AtbashCodable = AtbashEncodable & AtbashDecodable

protocol AtbashEncodable {
    func encode(_ message: String) -> String
}

protocol AtbashDecodable {
    func decode(_ message: String) -> String
}
