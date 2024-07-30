//
//  Config.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

// MARK: - Keys

private enum Keys: String {
    case openWeatherMapAPIKey
    case openWeatherMapBaseUrl
    case defaultSearchLimit
    case temperatureUnitKey
}

// MARK: - Config

final class Config: NSObject {
    static let shared: Config = Config()
    
    private var configs: NSDictionary!
    
    override private init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config")!
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")!
        self.configs = (NSDictionary(contentsOfFile: path)!.object(forKey: currentConfiguration) as! NSDictionary)
    }
}

// MARK: - ConfigKeys

extension Config {
    var openWeatherMapAPIKey: String {
        return configs.object(forKey: Keys.openWeatherMapAPIKey.rawValue) as! String
    }
    
    var openWeatherMapBaseUrl: String {
        return configs.object(forKey: Keys.openWeatherMapBaseUrl.rawValue) as! String
    }
    
    var defaultSearchLimit: Int {
        return configs.object(forKey: Keys.defaultSearchLimit.rawValue) as! Int
    }
    
    var temperatureUnitKey: String {
        return configs.object(forKey: Keys.temperatureUnitKey.rawValue) as! String
    }
}
