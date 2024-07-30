//
//  MainView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var appSettings = AppSettings()

    var body: some View {
        WeatherView()
            .environmentObject(appSettings)
    }
}
