//
//  HTTPService.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

protocol HTTPService {
    static var scheme: String { get }
    static var host: String { get }
    
    associatedtype Endpoint: EndpointProtocol
    
    associatedtype QueryItem: QueryItemProtocol
}

extension HTTPService {
    private func components(to endpoint: Endpoint? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = Self.scheme
        components.host = Self.host
        if let path = endpoint?.path {
            components.path = path
        }
        return components
    }
    
    func url(to endpoint: Endpoint? = nil, queryItems: [QueryItem: String] = [:]) throws -> URL {
        var components = components(to: endpoint)
        
        components.queryItems = queryItems.map { (name, value) in
            URLQueryItem(name: name.rawValue, value: value)
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        return url
    }
    
    func request(_ url: URL, with method: HTTPMethod, body: Encodable? = nil, headers: [HTTPHeaderField: HTTPHeaderType] = [:]) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = Dictionary(uniqueKeysWithValues:
            headers.map { (key, value) in
            (key.rawValue, value.content)
        })
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return request
    }
    
    func data(for request: URLRequest) async throws -> Data {
        try await URLSession.shared.data(for: request).0
    }
}

protocol EndpointProtocol {
    var path: String { get }
}

protocol QueryItemProtocol: RawRepresentable, Hashable where Self.RawValue == String { }

// Hashable conformance
extension QueryItemProtocol {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

enum HTTPMethod: String {
    case post = "POST"
}

enum HTTPHeaderField: String {
    case accept = "Accept"
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum HTTPHeaderType {
    case json
    case bearer(String)
    
    var content: String {
        switch self {
        case .json:
            "application/json"
        case .bearer(let token):
            "Bearer \(token)"
        }
    }
}
