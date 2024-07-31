//
//  NetworkMonitorManager.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 29.07.2024.
//

import Foundation
import Network

// MARK: - NetworkMonitorManagerInterface

/// Protocol defining the interface for network monitoring.
protocol NetworkMonitorManagerInterface {
    var isReachable: Published<Bool>.Publisher { get }
    func startMonitoring()
    func cancel()
}

// MARK: - NetworkMonitorManager

/// Singleton class responsible for monitoring network connectivity.
final class NetworkMonitorManager: ObservableObject {
    static let shared = NetworkMonitorManager()
    
    private let monitor: NWPathMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published private var hasConnection: Bool = false

    private init() { }
}

// MARK: - NetworkMonitorManagerInterface

extension NetworkMonitorManager: NetworkMonitorManagerInterface {
    var isReachable: Published<Bool>.Publisher { $hasConnection }
    /// Starts monitoring network connectivity.
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] monitorPath in
            guard let self = self else { return }
            
            Task {
                await MainActor.run {
                    self.hasConnection = monitorPath.status == .satisfied
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    /// Stops monitoring network connectivity.
    func cancel() {
        monitor.cancel()
    }
}
