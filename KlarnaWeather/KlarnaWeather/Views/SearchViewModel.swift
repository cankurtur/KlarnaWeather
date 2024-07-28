//
//  SearchViewModel.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    private let weatherManager: WeatherManager
    
    @Published var searchText: String = ""
    @Published var searchResults: [GeographicalInfoModel] = [] {
        didSet {
            hasSearchData = !self.searchResults.isEmpty
        }
    }
    @Published var hasSearchData: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.weatherManager = WeatherManager()
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
                
                Task {
                    self.searchResults = await self.weatherManager.fetchGeographicalInfo(cityName:searchText)
                }
            }
            .store(in: &cancellables)
    }
    
}
