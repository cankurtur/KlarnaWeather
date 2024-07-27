//
//  HTTPHeader.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

struct HTTPHeader {
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
