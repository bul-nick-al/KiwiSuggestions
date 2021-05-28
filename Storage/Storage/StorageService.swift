//
//  StorageService.swift
//  Storage
//
//  Created by Николай Булдаков on 26.05.2021.
//

import Foundation

public protocol StorageService {
    func removeValue(forKey key: String)
    func save<Value: Encodable>(value: Value, forKey key: String)
    func append<Value: Codable>(values: [Value], forKey key: String)
    func getValue<Value: Decodable>(for key: String) -> Value?
}
