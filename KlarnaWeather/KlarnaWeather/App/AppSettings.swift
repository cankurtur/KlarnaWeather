//
//  AppSettings.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import SwiftUI
import Combine

final class AppSettings: ObservableObject {
    @Published var hasNetworkConnection: Bool = false
    
    private let networkMonitorManager: NetworkMonitorManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.networkMonitorManager = NetworkMonitorManager()
        setupBindigs()
    }
    
    func setupBindigs() {
        networkMonitorManager.$isReachable
            .sink { [weak self] isReachable in
                guard let self else { return }
                
                self.hasNetworkConnection = isReachable
            }
            .store(in: &cancellables)
    }
}
