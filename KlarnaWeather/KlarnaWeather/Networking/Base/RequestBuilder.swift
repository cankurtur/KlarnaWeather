//
//  RequestBuilder.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

final class RequestBuilder {
    static func makeRequest(endpoint: Endpoint, timeoutInterval: TimeInterval) -> URLRequest? {
        guard let url = prepareURLComponents(for: endpoint)?.url else { return nil }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: timeoutInterval
        )
        
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = prepareBodyDataIfNeeded(for: endpoint)
        request = prepareHeaders(for: endpoint, into: request)
        
        return request
    }
    
    private static func prepareURLComponents(for endpoint: Endpoint) -> URLComponents? {
        var components = URLComponents(string: endpoint.url)
        
        if endpoint.method.encoding == .url,
           let parameters = endpoint.params {
            let queryItems = URLQueryItem.queryItems(dictionary: parameters)
            components?.queryItems = queryItems
        }
        return components
    }
    
    private static func prepareBodyDataIfNeeded(for endpoint: Endpoint) -> Data? {
        guard endpoint.method.encoding == .json,
              let parameters = endpoint.params else {
            return nil
        }
        
        return try? JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
            )
    }
    
    private static func prepareHeaders(for endpoint: Endpoint, into request: URLRequest) -> URLRequest {
        guard let headers = endpoint.headers else { return request }
        
        return headers.embed(into: request)
    }
    
}
