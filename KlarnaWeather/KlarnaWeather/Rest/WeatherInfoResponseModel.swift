//
//  WeatherInfoResponseModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

// MARK: - WeatherInfoResponseModel

struct WeatherInfoResponseModel: Codable {
    let weather: [Weather]?
    let main: Main?
    let name: String?
    let sys: Sys?
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int?
    let main: String?
}

// MARK: - Main

struct Main: Codable {
    let temp: Double?
    let tempMin: Double?
    let tempMax: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Sys

struct Sys: Codable {
    let country: String?
}
