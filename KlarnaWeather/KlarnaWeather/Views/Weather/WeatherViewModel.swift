//
//  WeatherViewModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI
import Combine

final class WeatherViewModel: ObservableObject {
    @Published var weatherInfoModel: WeatherInfoModel
    @Published var selectedLocationCoordinates: LocationCoordinates?
    @Published var showLocationPermissionAlert: Bool = false
    @Published var showLocationButton: Bool = false
    private let compositionRoot: CompositionRootInterface
    private var hasNetworkConnection: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.compositionRoot = CompositionRoot.shared
        self.weatherInfoModel = WeatherInfoModel.defaultValue
        self.setupBindigs()
    }
    
    // This method use for action.
    func didTapLocationButton() {
        guard compositionRoot.locationManager.hasPermission else {
            showLocationPermissionAlert = true
            return
        }
                
        let location = compositionRoot.locationManager.currentLocation
        self.checkConnectionAndFetchInfoIfNeeded(
            latitude: location?.latitude,
            longitude: location?.longitude,
            showLocationButton: false
        )
    }
    
    // This method use for setting current connection with given value.
    func setConnectionStatus(with connection: Bool) {
        hasNetworkConnection = connection
    }
}

// MARK: - Bindings

private extension WeatherViewModel {
    func setupBindigs() {
        // Selected Location Binding
        $selectedLocationCoordinates
            .sink { [weak self] location in
                guard let self else { return }
                guard self.hasNetworkConnection else { return }
                
                self.checkConnectionAndFetchInfoIfNeeded(
                    latitude: location?.latitude,
                    longitude: location?.longitude,
                    showLocationButton: true
                )
            }
            .store(in: &cancellables)
        
        // First Location Binding
        compositionRoot.locationManager.$firstLocation
            .sink { [weak self] location in
                guard let self else { return }
                
                self.checkConnectionAndFetchInfoIfNeeded(
                    latitude: location?.latitude,
                    longitude: location?.longitude,
                    showLocationButton: false
                )
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers

private extension WeatherViewModel {
    // This method check network connection first, if is reachable then fetch weather information of location. If not, set cache value to information.
    func checkConnectionAndFetchInfoIfNeeded(latitude: Double?, longitude: Double?, showLocationButton: Bool) {
        guard self.hasNetworkConnection else {
            return updateWeatherInfoModel(with: UserDefaultConfig.lastWeatherResponse)
        }
        
        self.fetchWeatherInformation(latitude: latitude, longitude: longitude) {
            Task {
                await MainActor.run {
                    self.showLocationButton = showLocationButton
                }
            }
        }
    }
    
    // This method use for fetching weather information of location.
    func fetchWeatherInformation(latitude: Double?, longitude: Double?, completion: @escaping ()-> Void) {
        guard let latitude, let longitude else { return }
        
        Task {
            let response = try await compositionRoot.networkManager.request(
                endpoint: WeatherEndpointItem.fetchWeatherInfo(
                    latitude: latitude,
                    longitude: longitude
                ),
                responseType: WeatherInfoResponseModel.self
            )
            UserDefaultConfig.lastWeatherResponse = response
            
            await MainActor.run {
                updateWeatherInfoModel(with: response)
            }
            UserDefaultConfig.lastWeatherResponse = response
            UserDefaultConfig.lastInfoFetchTime = Date.currentTimeWithHours
            completion()
        }
    }
    
    // This method use for updating weather information.
    func updateWeatherInfoModel(with response: WeatherInfoResponseModel?) {
        guard let response else { return }
        
        weatherInfoModel = WeatherInfoModel(
            iconName: WeatherInfoModel.IconName.ImageName(with: response.weather.first?.id ?? 0),
            temp: String(format: Localizable.weatherWithCelcius, response.main.temp),
            tempMin: String(format: Localizable.weatherWithCelcius, response.main.tempMin),
            tempMax: String(format: Localizable.weatherWithCelcius, response.main.tempMax),
            cityWithCountry: "\(response.name), \(response.sys.country)"
        )
    }
}
