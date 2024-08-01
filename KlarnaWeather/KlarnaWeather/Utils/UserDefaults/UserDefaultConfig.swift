//
//  UserDefaultConfig.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import Foundation

enum UserDefaultKeys: String {
    case lastWeatherResponse
    case lastInfoFetchTime
    case currentTemperatureUnit
    case latestTemperatureValues
}

struct UserDefaultConfig {
    @UserDefaultProperty(key: UserDefaultKeys.lastWeatherResponse, defaultValue: nil)
    static var lastWeatherResponse: WeatherInfoResponseModel?
    
    @UserDefaultProperty(key: UserDefaultKeys.lastInfoFetchTime, defaultValue: "-:-")
    static var lastInfoFetchTime: String
    
    @UserDefaultProperty(key: UserDefaultKeys.currentTemperatureUnit, defaultValue: Locale.temperatureUnit)
    static var currentTemperatureUnit: TemperatureUnit
}
