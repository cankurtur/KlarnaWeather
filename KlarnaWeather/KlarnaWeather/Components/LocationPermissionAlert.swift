//
//  LocationPermissionAlert.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import SwiftUI

// MARK: - LocationPermissionAlertView

struct LocationPermissionAlertView: View {
    @Binding var showAlert: Bool
    
    var body: some View {
        EmptyView()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(Localizable.locationPermission),
                    message: Text(Localizable.needYourLocation),
                    primaryButton: .default(Text(Localizable.cancel)),
                    secondaryButton: .default(Text(Localizable.settings)) {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                )
            }
    }
}
