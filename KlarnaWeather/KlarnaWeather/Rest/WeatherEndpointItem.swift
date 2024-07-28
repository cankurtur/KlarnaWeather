//
//  WeatherEndpointItem.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

enum WeatherEndpointItem: Endpoint {
    case fetchWeatherInfo(latitude: Double, longitude: Double)
    case fetchGeographicalInfo(cityName: String, limit: Int)
    
    var path: String {
        switch self {
        case .fetchWeatherInfo:
            return "/data/2.5/weather"
        case .fetchGeographicalInfo:
            return "/geo/1.0/direct"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchWeatherInfo, .fetchGeographicalInfo:
            return .get
        }
    }
    
    var params: [String : Any]? {
        let apiKey = Config.shared.openWeatherMapAPIKey
        
        switch self {
        case .fetchWeatherInfo(let latitude, let longitude):
            let queryItems: [String: Any] = [
                "lat": latitude,
                "lon": longitude,
                "appid": apiKey
            ]
            return queryItems
        case .fetchGeographicalInfo(let cityName, let limit):
            let queryItems: [String: Any] = [
                "q": cityName,
                "appid": apiKey,
                "limit": limit
            ]
            return queryItems
        }
    }
}
