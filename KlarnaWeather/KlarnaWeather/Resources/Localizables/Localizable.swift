//
//  Localizable.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import Foundation

struct Localizable {
    
    // MARK: - General
    static let cancel = NSLocalizedString("general.cancel", comment: "")
    static let settings = NSLocalizedString("general.settings", comment: "")
    static let somethingWentWrong = NSLocalizedString("general.somethingWentWrong", comment: "")
    static let ok = NSLocalizedString("general.ok", comment: "")
    
    // MARK: - Weather
    
    static let maxTemp = NSLocalizedString("weather.maxTemp", comment: "")
    static let minTemp = NSLocalizedString("weather.minTemp", comment: "")
    static let weatherWithCelcius = NSLocalizedString("weather.withCelcius", comment: "")
    
    // MARK: - Search
    
    static let findYourCity = NSLocalizedString("search.findYourCity", comment: "")
    static let startSearching = NSLocalizedString("search.startSearching", comment: "")
        
    // MARK: - Connection Alert
    
    static let weatherLostConnection = NSLocalizedString("connectionAlert.weatherLostConnection", comment: "")
    static let lastUpdatedTime = NSLocalizedString("connectionAlert.lastUpdatedTime", comment: "")
    static let searchLostConnection = NSLocalizedString("connectionAlert.searchLostConnection", comment: "")
    
    // MARK: - Location Permission Alert
    
    static let locationPermission = NSLocalizedString("locationPermissionAlert.locationPermission", comment: "")
    static let needYourLocation = NSLocalizedString("locationPermissionAlert.weNeedYourLocation", comment: "")
}
