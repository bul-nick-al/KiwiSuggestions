//
//  Create.swift
//  LocationService
//
//  Created by Николай Булдаков on 01.06.2021.
//

import Foundation

public func createService(of type: LocationServiceType) -> LocationService {
    switch type {
    case .standard:
        return StandardLocationService()
    }
}

public enum LocationServiceType {
    case standard
}
