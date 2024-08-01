//
//  URLResponse.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

extension URLResponse {
    var code: Int? {
        guard let response = self as? HTTPURLResponse else {
            return nil
        }
        
        return response.statusCode
    }
}
