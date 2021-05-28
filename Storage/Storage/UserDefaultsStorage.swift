//
//  UserDefaultsStorage.swift
//  Storage
//
//  Created by Николай Булдаков on 26.05.2021.
//

import Foundation

class UserDefaultsStorage: StorageService {
    private let userDefaults = UserDefaults(suiteName: "KiwiSuggestions")

    public func removeValue(forKey key: String) {
        userDefaults?.setValue(nil, forKey: key)
    }

    public func save<Value>(value: Value, forKey key: String) where Value: Encodable {
        if let encoded = try? JSONEncoder().encode(value) {
            userDefaults?.set(encoded, forKey: key)
        }
    }

    func append<Value>(values: [Value], forKey key: String) where Value : Codable {
        let storedValues: [Value] = getValue(for: key) ?? []

        save(value: storedValues + values, forKey: key)
    }

    public func getValue<Value>(for key: String) -> Value? where Value: Decodable {
        guard let data = userDefaults?.value(forKey: key) as? Data,
              let decodedData = try? JSONDecoder().decode(Value.self, from: data)
        else { return nil }

        return decodedData
    }
}
