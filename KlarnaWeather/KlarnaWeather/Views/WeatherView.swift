//
//  WeatherView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        ZStack {
            AppLinearGradient()
            VStack {
                cityTextView
                statusView
                HStack(spacing: 20) {
                    detailView
                    detailView
                }
                HStack(spacing: 20) {
                    detailView
                    detailView
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private var cityTextView: some View {
        Text("Cupertino, CA")
            .font(.primaryHeadline)
            .foregroundStyle(Color.primaryText)
    }
    
    private var statusView: some View {
        VStack {
            Image(systemName: "cloud.sun.fill")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text("76")
                .font(.extraLarge)
                .foregroundStyle(Color.primary)
        }
    }
    
    private var detailView: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 60,height: 60)
                    .foregroundStyle(Color.white)
                HStack{
                    Image(systemName: "thermometer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
            }
            VStack(spacing: 5) {
                Text("Feels like")
                    .font(.primaryTitle)
                Text("76")
                    .font(.secondaryTitle)
            }
        }
    }
}

#Preview {
    WeatherView()
}
