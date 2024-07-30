//
//  UserDefaultConfig.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import Foundation

enum UserDefaultKeys: String {
    case lastWeatherResponse
}

struct UserDefaultConfig {
    @UserDefaultProperty(key: UserDefaultKeys.lastWeatherResponse, defaultValue: nil)
    static var lastWeatherResponse: WeatherInfoResponseModel?
}
