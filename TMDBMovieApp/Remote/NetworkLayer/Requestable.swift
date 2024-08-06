//
//  Requestable.swift
//  GenericNetworkLayer
//
//  Created by Ahmed Sallam on 31/07/2024.
//

import Foundation

public protocol Requestable {
    var baseURL: String { get }
    var endpointURL: String { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }
    var isPrintable: Bool { get }
}

extension Requestable {
    
    public var fullURL: URL? {

        let fullURL = baseURL + endpointURL
        
        guard var urlComponents = URLComponents(string: fullURL) else { return nil }
        var urlQueryItems = [URLQueryItem]()

        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
    public func urlRequest() -> URLRequest? {
        
        guard let url = self.fullURL else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = [:]
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    private func encodeBody(bodyParameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: bodyParameters)
    }
}
