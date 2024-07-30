//
//  DateExtension.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import Foundation

extension Date {
    static var currentTimeWithHours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentTime = dateFormatter.string(from: Date())
        return currentTime
    }
}
