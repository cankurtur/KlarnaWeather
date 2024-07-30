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
    private var hasNetworkConnection: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.compositionRoot = CompositionRoot.shared
        setupBindings()
    }
    
    // This method use for setting current connection with given value.
    func setConnectionStatus(with connection: Bool) {
        hasNetworkConnection = connection
    }
}

// MARK: - Bindings

private extension SearchViewModel {
    // This method use for setting bindings.
    func setupBindings() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                guard searchText.count >= 3 || !searchText.isEmpty else {
                    searchResults.removeAll()
                    return
                }
                guard hasNetworkConnection else { return }
                
                fetchGeographicalInfo(wity: searchText)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helper

private extension SearchViewModel {
    // This method use for fetching geographical info with given searchText.
    func fetchGeographicalInfo(wity searchText: String) {
        Task {
            let response = try await compositionRoot.networkManager.request(
                endpoint: WeatherEndpointItem.fetchGeographicalInfo(
                    cityName: searchText,
                    limit: Config.shared.defaultSearchLimit
                ), responseType: [GeographicalInfoResponseModel].self
            )
            
            await MainActor.run {
                updateSearchResult(with: response)
            }
        }
    }
    
    // This method use for updating search result with latest response.
    func updateSearchResult(with response: [GeographicalInfoResponseModel]) {
        self.searchResults = response.map({ geographicalInfoResponseModel in
            return GeographicalInfoModel(
                cityWithCountry: "\(geographicalInfoResponseModel.name), \(geographicalInfoResponseModel.country)",
                latitude: geographicalInfoResponseModel.lat,
                longitude: geographicalInfoResponseModel.lon
            )
        })
    }
}
