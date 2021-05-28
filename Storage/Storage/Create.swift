//
//  Create.swift
//  Storage
//
//  Created by Николай Булдаков on 26.05.2021.
//

import Foundation

public func createService(of type: StorageServiceType) -> StorageService {
    switch type {
    case .userDefaults:
        return UserDefaultsStorage()
    case .runtime:
        return RuntimeStorage()
    }
}
