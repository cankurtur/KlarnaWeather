//
//  MockNetworkMonitorManager.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import Foundation
@testable import KlarnaWeather

final class MockNetworkMonitorManager: NetworkMonitorManagerInterface {
    
    static let sharedMock = MockNetworkMonitorManager()
    
    var isStartMonitoringCalled: Bool = false
    var isCancelCalled: Bool = false
    
    var isReachable: Published<Bool>.Publisher { $hasConnection }
    
    @Published private(set) var hasConnection: Bool = false
    
    func startMonitoring() {
        isStartMonitoringCalled = true
        hasConnection = true
    }
    
    func cancel() {
        isCancelCalled = true
        hasConnection = false
    }
    
    // Reset singleton state before each test to ensure test isolation.
    func reset() {
        isStartMonitoringCalled = false
        isCancelCalled = false
        hasConnection = false
    }
}
