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
    @Published var hasNetworkConnection: Bool = false
    
    private let networkManager: NetworkManagerInterface
    private let networkMonitorManager: NetworkMonitorManagerInterface
    private var cancellables = Set<AnyCancellable>()

    init(
        networkManager: NetworkManagerInterface = NetworkManager(),
        networkMonitorManager: NetworkMonitorManagerInterface = NetworkMonitorManager.shared
    ) {
        self.networkManager = networkManager
        self.networkMonitorManager = networkMonitorManager
        setupBindings()
    }
}

// MARK: - Bindings

private extension SearchViewModel {
    /// Sets up the bindings for search text changes and network reachability.
    func setupBindings() {
        // Observe changes to `searchText` with a debounce of 0.5 seconds to reduce the frequency of network requests.
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                // Check if there is an active network connection before proceeding.
                guard self.hasNetworkConnection else { return }
                
                guard searchText.count >= 3 || !searchText.isEmpty else {
                    searchResults.removeAll()
                    return
                }
                
                // Fetch geographical information based on the search text.
                fetchGeographicalInfo(with: searchText)
            }
            .store(in: &cancellables)
        
        // Observe changes in network reachability status.
        networkMonitorManager.isReachable
            .sink { [weak self] isReachable in
                self?.hasNetworkConnection = isReachable
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helper

private extension SearchViewModel {
    /// Fetches geographical information based on the provided search text.
    func fetchGeographicalInfo(with query: String) {
        Task {
            do {
                let response = try await networkManager.request(
                    endpoint: WeatherEndpointItem.fetchGeographicalInfo(
                        cityName: query,
                        limit: Config.shared.defaultSearchLimit
                    ), responseType: [GeographicalInfoResponseModel].self
                )
                
                await MainActor.run {
                    updateSearchResult(with: response)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    /// Updates the search results with the latest geographical information.
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
