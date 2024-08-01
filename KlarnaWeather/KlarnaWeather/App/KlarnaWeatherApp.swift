//
//  KlarnaWeatherApp.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import SwiftUI

@main
struct KlarnaWeatherApp: App {
    
    init() {
        NetworkMonitorManager.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
