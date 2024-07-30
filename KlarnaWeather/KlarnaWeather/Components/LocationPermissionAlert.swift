//
//  LocationPermissionAlert.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import SwiftUI

struct LocationPermissionAlertView: View {
    @Binding var showAlert: Bool
    
    var body: some View {
        EmptyView()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Location Permission"),
                    message: Text("We need to access to your location. Please grant permission in Settings."),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .default(Text("Settings")) {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                )
            }
    }
}
