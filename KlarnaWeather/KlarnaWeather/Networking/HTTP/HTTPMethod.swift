//
//  HTTPMethod.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

// MARK: - HTTPMethod

struct HTTPMethod: Equatable {
    // `GET` method.
    static let get = HTTPMethod(rawValue: "GET")
    
    /// `POST` method.
    static let post = HTTPMethod(rawValue: "POST")
    
    /// `PUT` method.
    static let put = HTTPMethod(rawValue: "PUT")
    
    /// `PATCH` method.
    static let patch = HTTPMethod(rawValue: "PATCH")
    
    /// `DELETE` method.
    static let delete = HTTPMethod(rawValue: "DELETE")
    
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - HTTPMethod Encoding

extension HTTPMethod {
    var encoding: ParameterEncoding {
        switch self {
        case .get:
            return .url
        default:
            return .json
        }
    }
    
}
