//
//  LatestTemperatureValues.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 1.08.2024.
//

import Foundation

// MARK: - LatestTemperatureValues

struct LatestTemperatureValues: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
}

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
    
    /// Since there are only two types (Celsius and Fahrenheit), this method converts the temperature to the opposite unit of the one it is called on.
    func convert(temp: Double) -> Double {
        switch self {
        case .celsius:
            return temp * 9.0 / 5.0 + 32.0
        case .fahrenheit:
            return (temp - 32.0) * 5.0 / 9.0
        }
    }
}
