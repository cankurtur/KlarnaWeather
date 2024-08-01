//
//  WeatherViewModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI
import Combine
import CoreLocation

// MARK: - WeatherViewModel

final class WeatherViewModel: ObservableObject {
    @Published var weatherInfoModel: WeatherInfoModel
    @Published var selectedLocationCoordinates: LocationCoordinates?
    @Published var showLocationPermissionAlert: Bool = false
    @Published var showLocationButton: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var hasNetworkConnection: Bool = false
    @Published var showAlert: Bool = false
    
    private let locationManager: LocationManagerInterface
    private let networkManager: NetworkManagerInterface
    private let networkMonitorManager: NetworkMonitorManagerInterface
    private var cancellables = Set<AnyCancellable>()
    
    init(
        locationManager: LocationManagerInterface = LocationManager(),
        networkManager: NetworkManagerInterface = NetworkManager(),
        networkMonitorManager: NetworkMonitorManagerInterface = NetworkMonitorManager.shared
    ) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        self.networkMonitorManager = networkMonitorManager
        self.weatherInfoModel = WeatherInfoModel.defaultValue
        setupBindigs()
    }
    
    /// Handles the event when the location button is tapped.
    func didTapLocationButton() {
        switch authorizationStatus {
        case .notDetermined:
            // Request location permission if it has not been determined.
            locationManager.requestLocationPermission()
        case .restricted, .denied:
            // Show an alert if location access is restricted or denied.
            showLocationPermissionAlert = true
        default:
            // Fetch weather information using the current location if permissions are granted.
            guard let location = locationManager.getCurrentLocationIfAvailable() else { return }
            
            fetchWeatherInformation(
                latitude: location.latitude,
                longitude: location.longitude,
                isSelectedLocation: false
            )
        }
    }
    
    /// Called when the view appears to start location updates or request permission.
    func viewOnAppear() {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestLocationPermission()
        }
    }
}

// MARK: - Bindings

private extension WeatherViewModel {
    func setupBindigs() {
        // Observe changes in `selectedLocationCoordinates` and fetch weather information when updated.
        $selectedLocationCoordinates
            .sink { [weak self] location in
                guard let self else { return }
                
                self.fetchWeatherInformation(
                    latitude: location?.latitude,
                    longitude: location?.longitude,
                    isSelectedLocation: true
                )
            }
            .store(in: &cancellables)

        // Observe changes in location authorization status and start location updates if authorized.
        locationManager.authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                self.authorizationStatus = status
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self.locationManager.startUpdatingLocation()
                }
            }
            .store(in: &cancellables)
        
        // Observe changes in both the first location and network reachability.
        Publishers.CombineLatest(locationManager.firstLocation, networkMonitorManager.isReachable)
            .sink { [weak self] firstLocation, isReachable in
                guard let self else { return }
                
                if isReachable, let location = firstLocation {
                    // Fetch weather information if the network is reachable and a location is available.
                    self.fetchWeatherInformation(
                        latitude: location.latitude,
                        longitude: location.longitude,
                        isSelectedLocation: false
                    )
                } else {
                    // Get weather information from cache if the network is not reachable.
                    Task {
                        await MainActor.run {
                            self.getInfoFromCacheIfNeeded()
                        }
                    }
                }
                // Update network connection status.
                self.hasNetworkConnection = isReachable
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers

private extension WeatherViewModel {
    /// Retrieves weather information from the cache if available.
    func getInfoFromCacheIfNeeded() {
        let lastResponse = UserDefaultConfig.lastWeatherResponse
        self.updateWeatherInfoModel(with: lastResponse)
        self.showLocationButton = true
    }
    
    /// Fetches weather information for a given location.
    func fetchWeatherInformation(latitude: Double?, longitude: Double?, isSelectedLocation: Bool) {
        guard let latitude, let longitude else { return }
        
        Task {
            do {
                let response = try await networkManager.request(
                    endpoint: WeatherEndpointItem.fetchWeatherInfo(
                        latitude: latitude,
                        longitude: longitude
                    ),
                    responseType: WeatherInfoResponseModel.self
                )
                
                // Update cache with the latest response and timestamp.
                UserDefaultConfig.lastWeatherResponse = response
                UserDefaultConfig.lastInfoFetchTime = Date.currentTimeWithHours
                
                // Update UI on the main thread.
                await MainActor.run {
                    updateWeatherInfoModel(with: response)
                    showLocationButton = isSelectedLocation
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                }
            }
        }
    }
    
    /// Updates the weather info model with the provided response.
    func updateWeatherInfoModel(with response: WeatherInfoResponseModel?) {
        guard let response else { return }
        
        let iconName = WeatherInfoModel.IconName.getImageName(with: response.weather?.first?.id ?? 0)
        let temp = String(format: Localizable.weatherWithCelcius, response.main?.temp ?? "-")
        let tempMin = String(format: Localizable.weatherWithCelcius, response.main?.tempMin ?? "-")
        let tempMax = String(format: Localizable.weatherWithCelcius, response.main?.tempMax ?? "-")
        
        var cityWithCountry = ""
        
        if let cityName = response.name {
            cityWithCountry += cityName
        }
        
        if let countryName = response.sys?.country?.countryName {
            cityWithCountry += ",\n \(countryName)"
        }
        
        weatherInfoModel = WeatherInfoModel(
            iconName: iconName,
            temp: temp,
            tempMin: tempMin,
            tempMax: tempMax,
            cityWithCountry: cityWithCountry
        )
    }
}
