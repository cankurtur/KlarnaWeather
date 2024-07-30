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
    @Published var hasConnection: Bool = false
    @Published var showLocationPermissionAlert: Bool = false
    
    private let compositionRoot: CompositionRootInterface
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.compositionRoot = CompositionRoot.shared
        self.weatherInfoModel = WeatherInfoModel.defaultValue
        self.setupBindigs()
    }
    
    func didTapLocationButton() {
        guard compositionRoot.locationManager.hasPermission else {
            showLocationPermissionAlert = true
            return
        }
        
        let location = compositionRoot.locationManager.currentLocation
        fetchWeatherInformation(latitude: location?.latitude, longitude: location?.longitude)
        
        selectedLocationCoordinates = nil
    }

    private func fetchSelectedLocationWeatherInfo(with location: LocationCoordinates?) {
        let latitude = location?.lat
        let longitude = location?.lon
        
        fetchWeatherInformation(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Bindings

private extension WeatherViewModel {
    func setupBindigs() {
        // Connection Binding
        compositionRoot.networkMonitorManager.$isReachable
            .sink { [weak self] isReachable in
                guard let self else { return }
                
                Task {
                    await MainActor.run {
                        self.hasConnection = isReachable
                        self.handleWeatherInfoAfterConnection()
                    }
                }
            }
            .store(in: &cancellables)
        
        // Selected Location Binding
        $selectedLocationCoordinates
            .sink { [weak self] location in
                guard let self else { return }
                guard location != nil else { return }
                
                self.fetchSelectedLocationWeatherInfo(with: location)
            }
            .store(in: &cancellables)
        
        // First Location Binding
        compositionRoot.locationManager.$firstLocation
            .sink { [weak self] location in
                guard let self else { return }
                fetchWeatherInformation(latitude: location?.latitude, longitude: location?.longitude)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers

private extension WeatherViewModel {
    func fetchWeatherInformation(latitude: Double?, longitude: Double?) {
        guard compositionRoot.networkMonitorManager.isReachable else {
            setCacheWeatherInfoIfHas()
            return
        }
        
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
        }
    }
    
    func setCacheWeatherInfoIfHas() {
        updateWeatherInfoModel(with: UserDefaultConfig.lastWeatherResponse)
    }
    
    func handleWeatherInfoAfterConnection() {
        if selectedLocationCoordinates != nil {
            let location = selectedLocationCoordinates
            fetchSelectedLocationWeatherInfo(with: location)
        } else {
            let location = compositionRoot.locationManager.currentLocation
            fetchWeatherInformation(latitude: location?.latitude, longitude: location?.longitude)
        }
    }
    
    func updateWeatherInfoModel(with response: WeatherInfoResponseModel?) {
        guard let response else { return }
        
        weatherInfoModel = WeatherInfoModel(
            iconName: WeatherInfoModel.IconName.ImageName(with: response.weather.first?.id ?? 0),
            temp: String(format: "%.1f", response.main.temp) + " °C",
            feelsLike: "\(response.main.feelsLike)",
            tempMin: "\(response.main.tempMin)",
            tempMax: "\(response.main.tempMax)",
            humidity: "\(response.main.humidity)",
            cityWithCountry: "\(response.name), \(response.sys.country)"
        )
    }
    
    func handleFailedResponse() {
        
    }
}
