//
//  GeographicalInfoResponseModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

struct GeographicalInfoResponseModel: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
}
