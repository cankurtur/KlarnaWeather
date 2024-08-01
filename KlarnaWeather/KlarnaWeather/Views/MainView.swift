//
//  MainView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import SwiftUI

// MARK: - MainView

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        WeatherView()
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    UserDefaultConfig.currentTemperatureUnit = Locale.temperatureUnit
                }
            }
    }
}
