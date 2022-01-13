//
//  CurrentLocationProvider.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 01.06.2021.
//

import Foundation

public class CurrentLocationProvider: LocationProvider {
    public var location: Location

    public init(location: Location) {
        self.location = location
    }
}
