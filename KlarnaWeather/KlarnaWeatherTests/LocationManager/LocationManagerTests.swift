//
//  LocationManagerTests.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import Combine
import CoreLocation
import XCTest
@testable import KlarnaWeather

final class LocationManagerTests: XCTestCase {
    private var sut: MockLocationManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = MockLocationManager()
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    func test_firstLocation_publisher_succes() {
        // Given
        let expectation = self.expectation(description: "First location should be updated.")
        let expectedLatitude = 10.0
        let expectedLongitude = 20.0
        var result: CLLocationCoordinate2D?
        // When
        sut.firstLocation
            .dropFirst()
            .sink { firstLocation in
                result = firstLocation
                expectation.fulfill()
            }
            .store(in: &cancellables)
        sut.startUpdatingLocation()
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result?.latitude, expectedLatitude)
        XCTAssertEqual(result?.longitude, expectedLongitude)
    }
    
    func test_authorizationStatus_publisher_succes() {
        // Given
        let expectation = self.expectation(description: "Authorization status should be updated.")
        var result: CLAuthorizationStatus?
        // When
        sut.authorizationStatus
            .dropFirst()
            .sink { status in
                result = status
                expectation.fulfill()
            }
            .store(in: &cancellables)
        sut.requestLocationPermission()
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result, .authorizedWhenInUse)
    }
    
    func test_requestLocationPermission_success() {
        // Given
        XCTAssertFalse(sut.isRequestLocationPermissionCalled)
        let expectedStatus: CLAuthorizationStatus = .authorizedWhenInUse
        // When
        sut.requestLocationPermission()
        // Then
        XCTAssertTrue(sut.isRequestLocationPermissionCalled)
        XCTAssertEqual(expectedStatus, sut.currentAuthorizationStatus)
    }
    
    func test_startUpdatingLocation_success() {
        // Given
        XCTAssertFalse(sut.isStartUpdatingLocationCalled)
        let expectedLatitude = 10.0
        let expectedLongitude = 20.0
        // When
        sut.startUpdatingLocation()
        // Then
        XCTAssertTrue(sut.isStartUpdatingLocationCalled)
        XCTAssertEqual(expectedLatitude, sut.firstValidLocation?.latitude)
        XCTAssertEqual(expectedLongitude, sut.firstValidLocation?.longitude)
    }
    
    func test_stopUpdatingLocation_success() {
        // Given
        XCTAssertFalse(sut.isStopUpdatingLocationCalled)
        // When
        sut.stopUpdatingLocation()
        // Then
        XCTAssertTrue(sut.isStopUpdatingLocationCalled)
    }

    func test_getCurrentLocationIfAvailable_success() {
        // Given
        XCTAssertFalse(sut.isGetCurrentLocationIfAvailableCalled)
        let expectedLatitude = 10.0
        let expectedLongitude = 20.0
        sut.startUpdatingLocation()
        // When
        _ = sut.getCurrentLocationIfAvailable()
        // Then
        XCTAssertTrue(sut.isGetCurrentLocationIfAvailableCalled)
        XCTAssertEqual(expectedLatitude, sut.firstValidLocation?.latitude)
        XCTAssertEqual(expectedLongitude, sut.firstValidLocation?.longitude)
    }
}
