//
//  EnglishificationService.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

protocol Englishifier {
    func attemptEnglishification(of decodedMessage: String) -> String
}
