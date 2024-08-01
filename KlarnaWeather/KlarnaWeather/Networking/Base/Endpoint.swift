//
//  Endpoint.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

// MARK: - Endpoint

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    var baseHeaders: HTTPHeaders? { get }
    var url: String { get }
    var method: HTTPMethod { get }
}

// MARK: - EndpointExtension

extension Endpoint {
    var baseUrl: String {
        return BaseURL.openWeatherMapBaseUrl.url
    }
    
    var params: [String: Any]? {
        return nil
    }
    
    var url: String {
        return "\(baseUrl)\(path)"
    }
    
    var headers: HTTPHeaders? {
        var headers = baseHeaders
        return headers
    }
    
    var baseHeaders: HTTPHeaders? {
        let acceptHeader = HTTPHeader(name: "Accept", value: "application/json")
        let cacheHeader = HTTPHeader(name: "Cache-Control", value: "no-cache")
        let contentTypeHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        
        return HTTPHeaders(headers: [acceptHeader, cacheHeader, contentTypeHeader])
    }
}
