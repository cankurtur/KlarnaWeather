//
//  SearchViewModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [GeographicalInfoModel] = []
    
    private let compositionRoot: CompositionRootInterface
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.compositionRoot = CompositionRoot.shared
        setupBindings()
    }
    
    func setupBindings() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                guard searchText.count >= 3 else {
                    searchResults.removeAll()
                    return
                }
                
                fetchGeographicalInfo(wity: searchText)
            }
            .store(in: &cancellables)
    }
    
    func fetchGeographicalInfo(wity cityName: String) {
        Task {
            let response = try await compositionRoot.networkManager.request(
                endpoint: WeatherEndpointItem.fetchGeographicalInfo(
                    cityName: cityName,
                    limit: Config.shared.defaultSearchLimit
                ), responseType: [GeographicalInfoResponseModel].self
            )
            
            await MainActor.run {
                updateSearchResult(with: response)
            }
        }
    }
    
    private func updateSearchResult(with response: [GeographicalInfoResponseModel]) {
        self.searchResults = response.map({ geographicalInfoResponseModel in
            return GeographicalInfoModel(
                cityWithCountry: "\(geographicalInfoResponseModel.name), \(geographicalInfoResponseModel.country)",
                latitude: geographicalInfoResponseModel.lat,
                longitude: geographicalInfoResponseModel.lon
            )
        })
    }
    
}
