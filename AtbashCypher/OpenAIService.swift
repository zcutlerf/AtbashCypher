//
//  OpenAIService.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

actor OpenAIService: HTTPService {
    static var scheme = "https"
    static var host = "api.openai.com"
    
    enum Endpoint: EndpointProtocol {
        case chat
        
        var path: String {
            switch self {
            case .chat:
                return "/v1/chat/completions"
            }
        }
        
        var model: String {
            switch self {
            case .chat:
                return "gpt-3.5-turbo"
            }
        }
    }
    
    enum QueryItem: String, QueryItemProtocol {
        case notUsingQueryItems
    }
    
    enum OpenAIError: LocalizedError {
        case noResponseChoicesAvailable
        
        public var errorDescription: String? {
            switch self {
            case .noResponseChoicesAvailable:
                NSLocalizedString("OpenAI API returned no available choices.", comment: "Error when trying to get a response from OpenAI API but there are no available choices.")
            }
        }
    }
    
    func chat(prompt: String, max_tokens: Int = 200) async throws -> String {
        let url = try url(to: .chat)
        
        let body = OpenAIChatBody(model: Endpoint.chat.model, messages: [OpenAIChat(role: .user, content: prompt)], max_tokens: max_tokens)
        
        let request = try request(url, with: .post, body: body, headers: [
            .contentType: .json,
            .accept: .json,
            .authorization: .bearer(openAiApiKey),
        ])
        
        let data = try await data(for: request)
        let decoder = JSONDecoder()
        let response = try decoder.decode(OpenAIChatResponse.self, from: data)
        
        if let message = response.choices.first?.message.content {
            return message
        } else {
            throw OpenAIError.noResponseChoicesAvailable
        }
    }
}
