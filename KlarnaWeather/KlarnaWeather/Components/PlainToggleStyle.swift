//
//  PlainToggleStyle.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 1.08.2024.
//

import SwiftUI

struct PlainToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Capsule()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 30)
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
                .frame(width: 26, height: 26)
                .offset(x: configuration.isOn ? 15 : -15)
                .animation(.easeInOut, value: configuration.isOn)
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
