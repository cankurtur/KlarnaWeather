//
//  URLQueryItemExtension.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

extension URLQueryItem {
    static func queryItems(dictionary: [String: Any]) -> [URLQueryItem] {
        dictionary.map {
            URLQueryItem(name: $0, value: ($1 as? LosslessStringConvertible)?.description)
        }
    }
}
