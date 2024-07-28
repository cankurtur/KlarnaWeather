//
//  Config.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

private enum Keys: String {
    case openWeatherMapAPIKey
    case openWeatherMapBaseUrl
    case defaultSearchLimit
}

final class Config: NSObject {
    static let shared: Config = Config()
    
    private var configs: NSDictionary!
    
    override private init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config")!
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")!
        self.configs = (NSDictionary(contentsOfFile: path)!.object(forKey: currentConfiguration) as! NSDictionary)
    }
}

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
}
