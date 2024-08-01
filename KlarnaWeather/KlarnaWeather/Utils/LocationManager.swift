//
//  LocationManager.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import CoreLocation
import Combine

// MARK: - LocationManagerInterface

/// Protocol defining the interface for location management.
protocol LocationManagerInterface {
    var firstLocation: Published<CLLocationCoordinate2D?>.Publisher { get }
    var authorizationStatus: Published<CLAuthorizationStatus>.Publisher { get }
    func requestLocationPermission()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func getCurrentLocationIfAvailable() -> CLLocationCoordinate2D?
}

// MARK: - LocationManager

/// Manages location updates and authorization status using Core Location.
final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published private var currentLocation: CLLocationCoordinate2D?
    @Published private var firstValidLocation: CLLocationCoordinate2D?
    @Published private var currentAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - LocationManagerInterface

extension LocationManager: LocationManagerInterface {
    var firstLocation: Published<CLLocationCoordinate2D?>.Publisher { $firstValidLocation }
    var authorizationStatus: Published<CLAuthorizationStatus>.Publisher { $currentAuthorizationStatus }
    
    /// Requests permission to access location services when the app is in use.
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Starts receiving location updates from the location manager.
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// Stops receiving location updates from the location manager.
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Returns the current location coordinate if available.
    func getCurrentLocationIfAvailable() -> CLLocationCoordinate2D? {
        return currentLocation
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    /// Called when the authorization status for location services changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.currentAuthorizationStatus = status
        }
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    /// Called when new location data is available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.currentLocation = locations.last?.coordinate
            
            if firstValidLocation == nil {
                firstValidLocation = currentLocation
            }
        }
    }
    
    /// Called when an error occurs while attempting to get location data.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager failed with error: \(error)")
    }
}
