//
//  MockLocationManager.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import CoreLocation
import Combine
import Foundation
@testable import KlarnaWeather

final class MockLocationManager: LocationManagerInterface {
    
    var isRequestLocationPermissionCalled: Bool = false
    var isStartUpdatingLocationCalled: Bool = false
    var isStopUpdatingLocationCalled: Bool = false
    var isGetCurrentLocationIfAvailableCalled: Bool = false
    
    var firstLocation: Published<CLLocationCoordinate2D?>.Publisher { $firstValidLocation }
    var authorizationStatus: Published<CLAuthorizationStatus>.Publisher { $currentAuthorizationStatus }
    
    @Published private(set) var firstValidLocation: CLLocationCoordinate2D?
    @Published private(set) var currentAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    func requestLocationPermission() {
        isRequestLocationPermissionCalled = true
        currentAuthorizationStatus = .authorizedWhenInUse
    }
    
    func startUpdatingLocation() {
        isStartUpdatingLocationCalled = true
        firstValidLocation = CLLocationCoordinate2D(latitude: 10.0, longitude: 20.0)
    }
    
    func stopUpdatingLocation() {
        firstValidLocation = nil
        isStopUpdatingLocationCalled = true
    }
    
    func getCurrentLocationIfAvailable() -> CLLocationCoordinate2D? {
        isGetCurrentLocationIfAvailableCalled = true
        return firstValidLocation
    }
}
