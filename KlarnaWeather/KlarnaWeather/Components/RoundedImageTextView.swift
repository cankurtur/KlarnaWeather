//
//  RoundedImageTextView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import SwiftUI

// MARK: - RoundedImageTextView

struct RoundedImageTextView: View {
    var image: Image
    var imageColor: Color
    var title: String
    var value: String
    
    init(image: Image, imageColor: Color, title: String, value: String) {
        self.image = image
        self.imageColor = imageColor
        self.title = title
        self.value = value
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 40,height: 40)
                    .foregroundStyle(.white)
                HStack{
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(imageColor)
                }
            }
            VStack(spacing: 5) {
                Text(title)
                    .font(.primarySmallTitle)
                Text(value)
                    .font(.secondarySmallTitle)
            }
        }
    }
}
