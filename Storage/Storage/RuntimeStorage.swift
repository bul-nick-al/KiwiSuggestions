//
//  RuntimeStorage.swift
//  Storage
//
//  Created by Николай Булдаков on 27.05.2021.
//

import Foundation

class RuntimeStorage: StorageService {

    var storage = [String: Any]()

    func removeValue(forKey key: String) {
        storage[key] = nil
    }

    func save<Value>(value: Value, forKey key: String) where Value : Encodable {
        storage[key] = value
    }

    func append<Value>(values: [Value], forKey key: String) where Value : Decodable, Value : Encodable {
        let storedValues: [Value] = getValue(for: key) ?? []

        save(value: storedValues + values, forKey: key)
    }

    func getValue<Value>(for key: String) -> Value? where Value : Decodable {
        storage[key] as? Value
    }
}
