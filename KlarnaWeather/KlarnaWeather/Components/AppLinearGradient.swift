//
//  AppLinearGradient.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import SwiftUI

// MARK: - AppLinearGradient

struct AppLinearGradient: View {
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    init(startPoint: UnitPoint = .topLeading,
         endPoint: UnitPoint = .bottomTrailing) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    var body: some View {
        LinearGradient(colors: [.appMain, .blue], startPoint: startPoint, endPoint: endPoint)
    }
}
