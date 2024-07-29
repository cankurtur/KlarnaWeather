//
//  NetworkMonitorManager.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 29.07.2024.
//

import Foundation
import Network


final class NetworkMonitorManager: ObservableObject {
    private let monitor: NWPathMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isReachable: Bool = true

    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] monitorPath in
            guard let self = self else { return }
            
            Task {
                await MainActor.run {
                    self.isReachable = true
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func cancel() {
        monitor.cancel()
    }
}
