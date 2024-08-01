//
//  GeographicalInfoModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

struct GeographicalInfoModel: Identifiable, Hashable {
    var id = UUID()
    
    let fullname: String
    let latitude: Double
    let longitude: Double
}
