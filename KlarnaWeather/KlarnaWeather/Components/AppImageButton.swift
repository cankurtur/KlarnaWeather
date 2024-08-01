//
//  AppImageButton.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

// MARK: - AppImageButton

struct AppImageButton: View {
    private let image: Image
    private let action: () -> Void
    
    init(image: Image, action: @escaping () -> Void) {
        self.image = image
        self.action = action
    }
    
    var body: some View {
        HapticButton {
            action()
        } label: {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .tint(.primaryText)
                .frame(width: 44, height: 44)
        }
    }
}
