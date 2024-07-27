//
//  HTTPHeaders.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

struct HTTPHeaders {
    private var headers: [HTTPHeader] = []
    
    init(headers: [HTTPHeader]) {
        self.headers = headers
    }
    
    mutating func add(_ header: HTTPHeader) {
        self.headers.append(header)
    }
    
    func embed(into request: URLRequest) -> URLRequest {
        var request = request
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return request
    }
}
