//
//  HTTPService.swift
//  AtbashCypher
//
//  Created by Zoe Cutler on 1/26/24.
//

import Foundation

protocol HTTPService {
    /// The URLSession for this HTTPService. Recommend setting this in an initializer with a default value of `URLSession.shared`, unless mocking `URLSession` to test mock HTTP responses.
    var urlSession: URLSession { get }
    
    /// The scheme of the API's url. Probably `https`.
    static var scheme: String { get }
    /// The host of the API's url. Something like `my.amazing.api`
    static var host: String { get }
    
    /// Enum of possible endpoints associated with this API.
    associatedtype Endpoint: EndpointProtocol
    
    /// Enum of possible query items you need to attach to a URL to use this API.
    associatedtype QueryItem: QueryItemProtocol
}

extension HTTPService {
    /// Creates `URLComponents` to an endpoint.
    private func components(to endpoint: Endpoint? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = Self.scheme
        components.host = Self.host
        if let path = endpoint?.path {
            components.path = path
        }
        return components
    }
    
    /// Constructs a `URL` to an endpoint, with query items if needed.
    /// - Parameters:
    ///   - endpoint: The intended destination, from this API's available endpoints.
    ///   - queryItems: Query items to be attached to this URL.
    /// - Returns: The constructed `URL`.
    /// - Throws: `URLError.badURL` if the URL cannot be constructed.
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
    
    /// Constructs a `URLRequest` from a URL with a method, optional body, and optional headers.
    /// - Parameters:
    ///   - url: URL destination of the request.
    ///   - method: Method for HTTP request, e.g. get or post.
    ///   - body: Body to include with the request.
    ///   - headers: Header values to specify with this URL.
    /// - Returns: The constructed `URLRequest`.
    /// - Throws: `Swift.EncodingError` instances depending on failure.
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
    
    /// Attempts to receive Data from a URLRequest.
    /// - Parameter request: URLRequest specifying destination, method, body, etc.
    /// - Returns: Data from request, if successful. (asynchronous)
    /// - Throws: Errors if data cannot be retrieved, e.g. network errors.
    func data(for request: URLRequest) async throws -> Data {
        try await urlSession.data(for: request).0
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

/// Methods available for `URLRequest`.
enum HTTPMethod: String {
    case post = "POST"
}

/// Enum of possible header fields for `URLRequest`.
enum HTTPHeaderField: String {
    case accept = "Accept"
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

/// Enum of possible header contents for `URLRequest`.
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
