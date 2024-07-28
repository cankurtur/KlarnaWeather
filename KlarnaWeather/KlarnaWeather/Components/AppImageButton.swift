//
//  AppImageButton.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

struct AppImageButton: View {
    private let imageName: String
    private let action: () -> Void
    
    init(imageName: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.action = action
    }
    
    var body: some View {
        HapticButton {
            action()
        } label: {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .tint(.primaryText)
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    AppImageButton(imageName: "magnifyingglass.circle.fill", action: {})
}
