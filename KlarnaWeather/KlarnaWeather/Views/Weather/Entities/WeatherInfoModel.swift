//
//  WeatherInfoModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

struct WeatherInfoModel {
    let iconName: String
    let temp: String
    let feelsLike: String
    let tempMin: String
    let tempMax: String
    let humidity: String
    let cityWithCountry: String
    
    static let defaultValue = WeatherInfoModel(
        iconName: "icloud.slash.fill",
        temp: "-",
        feelsLike: "-",
        tempMin: "-",
        tempMax: "-",
        humidity: "-",
        cityWithCountry: "-"
    )
}
