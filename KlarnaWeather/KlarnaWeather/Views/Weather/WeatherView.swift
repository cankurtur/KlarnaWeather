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
                HStack(spacing: 50) {
                    RoundedImageTextView(
                        image: Images.thermometerHigh,
                        imageColor: .red,
                        title: Localizable.maxTemp,
                        value: viewModel.weatherInfoModel.tempMax
                    )
                    RoundedImageTextView(
                        image: Images.thermometerLow,
                        imageColor: .blue,
                        title: Localizable.minTemp,
                        value: viewModel.weatherInfoModel.tempMin
                    )
                }
            }
            buttonsView
            if !appSettings.hasNetworkConnection {
                VStack {
                    ConnectionAlertView(
                        warningTitle: Localizable.weatherLostConnection,
                        warningDescription: String(format: Localizable.lastUpdatedTime, UserDefaultConfig.lastInfoFetchTime)
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
                .frame(width: 150, height: 150)
            Text(viewModel.weatherInfoModel.temp)
                .font(.extraLarge)
                .foregroundStyle(Color.primary)
        }
    }
    
    var buttonsView: some View {
        VStack {
            HStack {
                Spacer()
                AppImageButton(image: Images.magnifyingglass) {
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
                    AppImageButton(image: Images.location) {
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
