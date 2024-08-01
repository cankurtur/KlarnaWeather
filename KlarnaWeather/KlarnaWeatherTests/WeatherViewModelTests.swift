//
//  WeatherViewModelTests.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import XCTest
import Combine
import CoreLocation
@testable import KlarnaWeather

final class WeatherViewModelTests: XCTestCase {

    private var viewModel: WeatherViewModel!
    private var mockLocationManager: MockLocationManager!
    private var mockNetworkManager: MockNetworkManager!
    private var mockNetworkMonitorManager: MockNetworkMonitorManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
        mockNetworkManager = MockNetworkManager()
        mockNetworkMonitorManager = MockNetworkMonitorManager.sharedMock
        viewModel = WeatherViewModel(
            locationManager: mockLocationManager,
            networkManager: mockNetworkManager,
            networkMonitorManager: mockNetworkMonitorManager
        )
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockLocationManager = nil
        mockNetworkManager = nil
        mockNetworkMonitorManager = nil
        cancellables = nil
    }
    
    func test_didTapLocationButton_permissionWhenNotDetermined() {
        // Given
        let expectation = self.expectation(description: "Authorization status should be get.")
        XCTAssertFalse(mockLocationManager.isRequestLocationPermissionCalled)
        var result: CLAuthorizationStatus?
        // When
        mockLocationManager.authorizationStatus
            .dropFirst()
            .sink { status in
                result = status
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.didTapLocationButton()
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result, .authorizedWhenInUse)
        XCTAssertTrue(mockLocationManager.isRequestLocationPermissionCalled)
    }
    
    func test_onAppear_permissionWhenNotDetermined() {
        // Given
        let expectation = self.expectation(description: "Authorization status should be get.")
        XCTAssertFalse(mockLocationManager.isRequestLocationPermissionCalled)
        var result: CLAuthorizationStatus?
        // When
        mockLocationManager.authorizationStatus
            .dropFirst()
            .sink { status in
                result = status
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.viewOnAppear()
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result, .authorizedWhenInUse)
        XCTAssertTrue(mockLocationManager.isRequestLocationPermissionCalled)
    }

}
