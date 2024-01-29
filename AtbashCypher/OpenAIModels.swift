//
//  OpenAIModels.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

internal extension OpenAIService {
    struct OpenAIChatBody: Codable {
        var model: String
        var messages: [OpenAIChat]
        var max_tokens: Int
    }
    
    struct OpenAIChatResponse: Codable {
        var choices: [OpenAIChatChoice]
    }

    struct OpenAIChatChoice: Codable {
        var message: OpenAIChat
    }

    struct OpenAIChat: Codable {
        enum Role: String {
            case system, user, assistant
        }
        
        var role: String
        var content: String
        
        init(role: Role, content: String) {
            self.role = role.rawValue
            self.content = content
        }
    }
}
