//
//  SearchViewModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI
import Combine

// MARK: - SearchViewModel

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [GeographicalInfoModel] = []
    @Published var hasNetworkConnection: Bool = false
    @Published var showAlert: Bool = false
    
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
                
                guard searchText.count >= 3  else {
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
            } catch {
                await MainActor.run {
                    showAlert = true
                }
            }
        }
    }
    
    /// Updates the search results with the latest geographical information.
    func updateSearchResult(with response: [GeographicalInfoResponseModel]) {
        
        let filteredArray = response.filter { $0.lat != nil && $0.lon != nil }
        
        searchResults = filteredArray.map { geographicalInfoResponseModel in
            
            var fullName = ""
            
            // Append the  city name if available.
            if let name = geographicalInfoResponseModel.name {
                fullName += name
            }
            
            // Append the state to the name if available.
            if let state = geographicalInfoResponseModel.state {
                fullName += ", \(state)"
            }
            
            // Append the country to the name if available.
            if let country = geographicalInfoResponseModel.country?.countryName {
                fullName += ", \(country)"
            }
            
            // Latitude and longitude default to 0 because models without valid coordinates have been filtered out.
            return GeographicalInfoModel(
                fullname: fullName,
                latitude: geographicalInfoResponseModel.lat ?? 0,
                longitude: geographicalInfoResponseModel.lon ?? 0
            )
        }
    }
}
