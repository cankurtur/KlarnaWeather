//
//  LocationManager.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import CoreLocation
import Foundation

// MARK: - LocationManager

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var isFirstLocationFetched: Bool = false

    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var firstLocation: CLLocationCoordinate2D?
    @Published var hasPermission: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isFirstLocationFetched {
            firstLocation = locations.first?.coordinate
            isFirstLocationFetched = true
        }
        
        currentLocation = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // TODO: - Alert will added
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            hasPermission = true
            locationManager.startUpdatingLocation()
        } else {
            hasPermission = false
            locationManager.stopUpdatingLocation()
        }
    }
}

