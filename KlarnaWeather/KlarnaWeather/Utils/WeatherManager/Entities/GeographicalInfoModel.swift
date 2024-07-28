//
//  GeographicalInfoModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

struct GeographicalInfoModel: Identifiable {
    var id = UUID()
    
    let cityWithCountry: String
    let latitude: Double
    let longitude: Double
}
