//
//  Location.swift
//  CommonModels
//
//  Created by Николай Булдаков on 27.05.2021.
//

import Foundation

public struct Location {
    public var latitude: Double
    public var longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
