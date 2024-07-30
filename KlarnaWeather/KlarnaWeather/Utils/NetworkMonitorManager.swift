//
//  NetworkMonitorManager.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 29.07.2024.
//

import Foundation
import Network

// MARK: - NetworkMonitorManager

final class NetworkMonitorManager: ObservableObject {
    private let monitor: NWPathMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isReachable: Bool = false

    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] monitorPath in
            guard let self = self else { return }
            
            Task {
                await MainActor.run {
                    self.isReachable = monitorPath.status == .satisfied
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func cancel() {
        monitor.cancel()
    }
}
