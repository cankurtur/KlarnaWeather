//
//  AlertView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 29.07.2024.
//

import SwiftUI

struct ConnectionAlertView: View {
    var warningTitle: String
    var warningDescription: String
    
    init(warningTitle: String, warningDescription: String) {
        self.warningTitle = warningTitle
        self.warningDescription = warningDescription
    }
    
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .foregroundStyle(.black.opacity(0.5))
            .overlay {
                VStack(spacing: 2) {
                    Text(warningTitle)
                        .font(.primarySmallTitle)
                    Text(warningDescription)
                        .font(.secondarySmallTitle)
                }
                .padding(.horizontal)
                .padding(.top, 50)
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
            }
            .transition(.move(edge: .top))
            .animation(.smooth)
    }
}

#Preview {
    ConnectionAlertView(warningTitle: "MessageMessageMessageMessage", warningDescription: "DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription")
}
