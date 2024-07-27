//
//  Colors.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import SwiftUI

extension Color {
    static var main: Color {
        Color("AppMain")
    }
    
    static var primaryText: Color {
        .primary
    }
    
    static var secondaryText: Color {
        .primary.opacity(0.8)
    }
}
