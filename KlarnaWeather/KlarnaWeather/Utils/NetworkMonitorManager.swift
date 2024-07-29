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
    private var status: NWPath.Status = .satisfied
    var isReachable: Bool { status == .satisfied }
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = {[weak self] monitorPath in
            guard let self = self else { return }
            
            self.status = monitorPath.status
            
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func cancel() {
        monitor.cancel()
    }
}
