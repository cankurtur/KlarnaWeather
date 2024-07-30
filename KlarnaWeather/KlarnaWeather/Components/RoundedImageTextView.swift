//
//  RoundedImageTextView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import SwiftUI

struct RoundedImageTextView: View {
    var imageName: String
    var imageColor: Color
    var title: String
    var value: String
    
    init(imageName: String, imageColor: Color, title: String, value: String) {
        self.imageName = imageName
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
                    Image(systemName: imageName)
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

#Preview {
    RoundedImageTextView(imageName: "thermometer.high", imageColor: .red ,title: "Max Temp", value: "76 C")
}
