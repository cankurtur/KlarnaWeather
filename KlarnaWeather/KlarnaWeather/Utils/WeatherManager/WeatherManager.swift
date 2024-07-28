//
//  WeatherManager.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI
import Combine

final class WeatherManager: ObservableObject {
    private let networkManager: NetworkManagerProtocol
    @Published var currentWeatherInfo: WeatherInfoModel
    
    init() {
        self.networkManager = NetworkManager()
        self.currentWeatherInfo = WeatherInfoModel.defaultValue
    }

    func fetchWeatherInformation(latitude: Double?, longitude: Double?) async {
        guard let latitude, let longitude else { return }
        
        do {
            let response = try await networkManager.request(
                endpoint: WeatherEndpointItem.fetchWeatherInfo(
                    latitude: latitude,
                    longitude: longitude
                ), responseType: WeatherInfoResponseModel.self
            )
            
            await MainActor.run {
                self.currentWeatherInfo = WeatherInfoModel(
                    iconName: "cloud.sun.fill",
                    temp: "\(response.main.temp)",
                    feelsLike: "\(response.main.feelsLike)",
                    tempMin: "\(response.main.tempMin)",
                    tempMax: "\(response.main.tempMax)",
                    humidity: "\(response.main.humidity)",
                    cityWithCountry: "\(response.name), \(response.sys.country)"
                )
            }
        } catch {
            print("error")
        }
    }
    
    func fetchGeographicalInfo(cityName: String) async -> [GeographicalInfoModel] {
        do {
            let response = try await networkManager.request(
                endpoint: WeatherEndpointItem.fetchGeographicalInfo(
                    cityName: cityName,
                    limit: Config.shared.defaultSearchLimit
                ),
                responseType: [GeographicalInfoResponseModel].self
            )
            let model = response.map { geographicalInfoResponseModel in
                return GeographicalInfoModel(
                    cityWithCountry: "\(geographicalInfoResponseModel.name), \(geographicalInfoResponseModel.country)",
                    latitude: geographicalInfoResponseModel.lat,
                    longitude: geographicalInfoResponseModel.lon
                )
            }
            return model
        } catch let error {
            print(error)
            return []
        }
    }
}
