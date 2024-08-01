//
//  NetworkMonitorManagerTests.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import Combine
import XCTest
@testable import KlarnaWeather

final class NetworkMonitorManagerTests: XCTestCase {

    private var sut: MockNetworkMonitorManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = MockNetworkMonitorManager.sharedMock
        sut.reset()
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    func test_isReachable_publisher_success() {
        // Given
        let expectation = self.expectation(description: "Reachability should be updated")
        let expectedConnection = true
        var result: Bool?
        // When
        sut.isReachable
            .dropFirst()
            .sink { isReachable in
                result = isReachable
                expectation.fulfill()
            }
            .store(in: &cancellables)
        sut.startMonitoring()
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result, expectedConnection)
    }

    func test_startMonitoring_success() {
        // Given
        XCTAssertFalse(sut.isStartMonitoringCalled)
        let expectedConnection = true
        // When
        sut.startMonitoring()
        // Then
        XCTAssertTrue(sut.isStartMonitoringCalled)
        XCTAssertEqual(expectedConnection, sut.hasConnection)
    }
    
    func test_cancel_success() {
        // Given
        XCTAssertFalse(sut.isCancelCalled)
        let expectedConnection = false
        // When
        sut.cancel()
        // Then
        XCTAssertTrue(sut.isCancelCalled)
        XCTAssertEqual(expectedConnection, sut.hasConnection)
    }
}
