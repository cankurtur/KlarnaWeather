//
//  WeatherView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject var viewModel = WeatherViewModel()
    @State var showSearch: Bool = false
    
    var body: some View {
        ZStack {
            AppLinearGradient()
                .ignoresSafeArea()
            VStack {
                cityTextView
                statusView
            }
            buttonsView
            if !appSettings.hasNetworkConnection {
                VStack {
                    ConnectionAlertView(
                        warningTitle: "Internet connection is lost.",
                        warningDescription: "Last updated time : \(Date().currentTimeWithHours)"
                    )
                    Spacer()
                }
                .ignoresSafeArea()
            }
        }.overlay {
            LocationPermissionAlertView(showAlert: $viewModel.showLocationPermissionAlert)
        }
        .onReceive(appSettings.$hasNetworkConnection, perform: { connection in
            viewModel.setConnectionStatus(with: connection)
        })
    }
}

// MARK: - Views

private extension WeatherView {
    var cityTextView: some View {
        Text(viewModel.weatherInfoModel.cityWithCountry)
            .font(.primaryHeadline)
            .foregroundStyle(Color.primaryText)
            .padding()
    }
    
    var statusView: some View {
        VStack {
            Image(systemName: viewModel.weatherInfoModel.iconName.rawValue)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text(viewModel.weatherInfoModel.temp)
                .font(.extraLarge)
                .foregroundStyle(Color.primary)
        }
    }
    
    var buttonsView: some View {
        VStack {
            HStack {
                Spacer()
                AppImageButton(imageName: "magnifyingglass.circle.fill") {
                    showSearch.toggle()
                }
                .sheet(isPresented: $showSearch, content: {
                    SearchView(selectedLocationCoordinates: $viewModel.selectedLocationCoordinates)
                })
            }
            Spacer()
            if viewModel.showLocationButton {
                HStack {
                    Spacer()
                    AppImageButton(imageName: "location.circle.fill") {
                        viewModel.didTapLocationButton()
                    }
                    Spacer()
                }
            }
        }
        .padding(.all, 30)
        .padding(.top, 30)
    }
}

#Preview {
    WeatherView()
}
