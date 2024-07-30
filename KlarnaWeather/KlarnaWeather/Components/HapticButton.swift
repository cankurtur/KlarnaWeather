//
//  HapticButton.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

// MARK: - HapticButton

struct HapticButton<Label: View>: View {
    var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
    var action: () -> Void
    @ViewBuilder
    var label: Label
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.impactOccurred()
            action()
        }, label: {
            label
        })
    }
}
