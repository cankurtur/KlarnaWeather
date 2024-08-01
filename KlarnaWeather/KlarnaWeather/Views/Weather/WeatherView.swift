//
//  WeatherView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

// MARK: - WeatherView

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State var showSearch: Bool = false
    
    var body: some View {
        ZStack {
            AppLinearGradient()
                .ignoresSafeArea()
            VStack {
                cityTextView
                statusView
                unitToggleView
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
            if !viewModel.hasNetworkConnection {
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
        .onAppear {
            viewModel.viewOnAppear()
        }
        .alert(Localizable.somethingWentWrong,
               isPresented: $viewModel.showAlert) {
            Button(Localizable.ok, role: .cancel) {}
        }
    }
}

// MARK: - Views

private extension WeatherView {
    var cityTextView: some View {
        Text(viewModel.weatherInfoModel.cityWithCountry)
            .font(.primaryHeadline)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.primaryText)
            .padding(.bottom, 50)
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
                    .disabled(!viewModel.hasNetworkConnection)
                    Spacer()
                }
            }
        }
        .padding(.all, 30)
        .padding(.top, 30)
    }
    
    var unitToggleView: some View {
        HStack {
            Text(Localizable.celsius)
                .font(.primarySmallTitle)
                .padding(.trailing, 8)
            
            Toggle("", isOn: $viewModel.unitToggleIsOn)
                .labelsHidden()
                .toggleStyle(PlainToggleStyle())
                .frame(width: 40)
            
            Text(Localizable.fahrenheit)
                .font(.primarySmallTitle)
                .padding(.leading, 8)
        }
    }
}

#Preview {
    WeatherView()
}
