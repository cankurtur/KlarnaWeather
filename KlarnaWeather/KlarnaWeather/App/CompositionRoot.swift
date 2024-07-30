//
//  CompositionRoot.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import Foundation

// MARK: - CompositionRootInterface

protocol CompositionRootInterface {
    var networkManager: NetworkManagerProtocol { get set }
    var locationManager: LocationManager { get set }
}

// MARK: - CompositionRoot

final class CompositionRoot: CompositionRootInterface {
    
    static let shared = CompositionRoot()
    
    lazy var networkManager: NetworkManagerProtocol = {
        return NetworkManager()
    }()
    
    lazy var locationManager: LocationManager = {
        return LocationManager()
    }()

    private init() { }
}
