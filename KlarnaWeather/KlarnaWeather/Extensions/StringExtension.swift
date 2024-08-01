//
//  StringExtension.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 1.08.2024.
//

import Foundation

extension String {
    var countryName: String {
        let countryCode = self
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }
}
