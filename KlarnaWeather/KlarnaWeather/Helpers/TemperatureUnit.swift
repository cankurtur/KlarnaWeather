//
//  TemperatureUnit.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 1.08.2024.
//

import Foundation

// MARK: - TemperatureUnit

enum TemperatureUnit: Codable {
    case celsius
    case fahrenheit
    
    var unitKey: String {
        switch self {
        case .celsius:
            return Config.shared.celsiusUnitKey
        case .fahrenheit:
            return Config.shared.fahrenheitUnitKey
        }
    }
    
    var symbol: String {
        switch self {
        case .celsius:
            Localizable.weatherWithCelsius
        case .fahrenheit:
            Localizable.weatherWithFahrenheit
        }
    }
}
