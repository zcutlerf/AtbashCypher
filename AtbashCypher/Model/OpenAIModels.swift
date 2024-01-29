//
//  OpenAIModels.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

internal extension OpenAIService {
    /// The body to include with OpenAI's chat endpoint.
    struct OpenAIChatBody: Codable {
        var model: String
        var messages: [OpenAIChat]
        var max_tokens: Int
    }
    
    /// The response from OpenAI's chat endpoint.
    struct OpenAIChatResponse: Codable {
        var choices: [OpenAIChatChoice]
    }

    /// One possible choice from an `OpenAIChatResponse`.
    struct OpenAIChatChoice: Codable {
        var message: OpenAIChat
    }

    /// Represents a chat to send to or receive from OpenAI's chat endpoint.
    struct OpenAIChat: Codable {
        /// The role of the chat. There may only be up to 1 `system` chat, representing the behavior of the assistant. Then there may be any number of `user` and `assistant` chats in conversation.
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
