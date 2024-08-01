//
//  HTTPHeader.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

// MARK: - HTTPHeader

struct HTTPHeader {
    
    /// Name of the header.
    let name: String
    
    /// Value of the header.
    let value: String
    
    /// Creates an instance from the given `name` and `value`.
    /// - Parameters:
    ///   - name:  The name of the header.
    ///   - value: The value of the header.
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
