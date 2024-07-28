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
    private let compositionRoot: CompositionRootInterface
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.compositionRoot = CompositionRoot.shared
        self.weatherInfoModel = WeatherInfoModel.defaultValue
        self.setupBindigs()
    }
    
    func setupBindigs() {
        $selectedLocationCoordinates
            .sink { [weak self] location in
                guard let self else { return }
                
                self.fetchWeatherInformation(latitude: location?.lat, longitude: location?.lon)
            }
            .store(in: &cancellables)
    }
    
    func fetchCurrentLocationWeatherInfo() {
        let location = compositionRoot.locationManager.location
        fetchWeatherInformation(latitude: location?.latitude, longitude: location?.longitude)
    }
    
    func fetchWeatherInformation(latitude: Double?, longitude: Double?) {
        guard let latitude, let longitude else { return }
        
        Task {
            let response = try await compositionRoot.networkManager.request(
                endpoint: WeatherEndpointItem.fetchWeatherInfo(
                    latitude: latitude,
                    longitude: longitude
                ),
                responseType: WeatherInfoResponseModel.self
            )
            
            await MainActor.run {
                updateWeatherInfoModel(with: response)
            }
        } 
    }
    
    private func updateWeatherInfoModel(with response: WeatherInfoResponseModel) {
        weatherInfoModel = WeatherInfoModel(
            iconName: WeatherInfoModel.IconName.ImageName(with: response.weather.first?.id ?? 0),
            temp: "\(response.main.temp)",
            feelsLike: "\(response.main.feelsLike)",
            tempMin: "\(response.main.tempMin)",
            tempMax: "\(response.main.tempMax)",
            humidity: "\(response.main.humidity)",
            cityWithCountry: "\(response.name), \(response.sys.country)"
        )
    }
    
    private func handleFailedResponse() {
        
    }
}

struct LocationCoordinates {
    let lat: Double?
    let lon: Double?
}
