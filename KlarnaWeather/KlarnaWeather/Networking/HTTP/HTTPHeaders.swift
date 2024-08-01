//
//  HTTPHeaders.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

// MARK: - HTTPHeaders

struct HTTPHeaders {
    private var headers: [HTTPHeader] = []
    
    /// Creates an instance from an array of `HTTPHeader`s.
    init(headers: [HTTPHeader]) {
        self.headers = headers
    }
    
    /// Adds specific header into headers.
    /// - Parameter header: Given header.
    mutating func add(_ header: HTTPHeader) {
        self.headers.append(header)
    }
    
    /// Embeds the headers into given url request.
    /// - Parameter request: Given url request.
    /// - Returns: Updated url request.
    func embed(into request: URLRequest) -> URLRequest {
        var request = request
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return request
    }
}
