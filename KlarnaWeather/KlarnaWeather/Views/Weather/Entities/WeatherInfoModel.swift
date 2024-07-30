//
//  WeatherInfoModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

// MARK: - WeatherInfoModel

struct WeatherInfoModel {
    let iconName: IconName
    let temp: String
    let tempMin: String
    let tempMax: String
    let cityWithCountry: String
    
    static let defaultValue = WeatherInfoModel(
        iconName: .noInfo,
        temp: "-",
        tempMin: "-",
        tempMax: "-",
        cityWithCountry: "-"
    )
    
    enum IconName: String {
        case thunderstorm = "cloud.bolt.fill"
        case drizzle = "cloud.drizzle.fill"
        case rain = "cloud.rain.fill"
        case snow = "cloud.snow.fill"
        case atmosphere = "cloud.fog.fill"
        case sunMax = "sun.max.fill"
        case clouds = "cloud.sun.fill"
        case noInfo = "exclamationmark.icloud.fill"
        
        static func ImageName(with id: Int) -> IconName {
            switch id {
            case 200...232:
                return .thunderstorm
            case 300...321:
                return .drizzle
            case 500...531:
                return .rain
            case 600...622:
                return .snow
            case 701...781:
                return .atmosphere
            case 800:
                return .sunMax
            case 801...804:
                return .clouds
            default:
                return .noInfo
            }
        }
    }
}
