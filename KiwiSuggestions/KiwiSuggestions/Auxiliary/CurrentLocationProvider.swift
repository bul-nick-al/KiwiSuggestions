//
//  CurrentLocationProvider.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 01.06.2021.
//

import Foundation
import CommonModels

class CurrentLocationProvider: LocationProvider {
    var location: Location

    internal init(location: Location) {
        self.location = location
    }
}
