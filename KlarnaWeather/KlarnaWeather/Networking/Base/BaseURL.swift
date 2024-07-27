//
//  BaseURL.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

enum BaseURL: String {
    case openWeatherMapBaseUrl
    
    var url: String {
        switch self {
        case.openWeatherMapBaseUrl:
            return "https://api.openweathermap.org"
        }
    }
        
}
