//
//  UserDefaultProperty.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 30.07.2024.
//

import Foundation

@propertyWrapper
struct UserDefaultProperty<Value: Codable> {
   
    let key: UserDefaultKeys
    let defaultValue: Value
    var storage: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            guard let data = storage.object(forKey: key.rawValue) as? Data else {
                return defaultValue
            }
            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            storage.set(data, forKey: key.rawValue)
            storage.synchronize()
        }
    }
}

extension UserDefaultProperty where Value: ExpressibleByNilLiteral {
    init(key: UserDefaultKeys, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}
