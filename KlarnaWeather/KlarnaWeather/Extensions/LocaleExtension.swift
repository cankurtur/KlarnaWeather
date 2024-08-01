//
//  LocaleExtension.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 1.08.2024.
//

import Foundation

extension Locale {
    static var temperatureUnit: TemperatureUnit {
        let formatter = MeasurementFormatter()
        let temperature = Measurement(value: 0, unit: UnitTemperature.celsius)
        let unit = formatter.string(from: temperature)
       
        if unit.contains(Localizable.celsius) {
            return .celsius
        } else {
            return .fahrenheit
        }
    }
}
