//
//  HTTPMethod.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

struct HTTPMethod: Equatable {
    
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")
    static let put = HTTPMethod(rawValue: "PUT")
    static let patch = HTTPMethod(rawValue: "PATCH")
    static let delete = HTTPMethod(rawValue: "DELETE")
    
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

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
