//
//  FlightSuggestionsViewControllerDependencies.swift
//  SuggestionsScreen
//
//  Created by Nikolay Buldakov on 13.01.2022.
//

import CommonModels
import Suggestions
import Storage
import API
import CoreLocation
import Location


public struct FlightSuggestionsViewControllerDependencies {
    public let locationProvider: LocationProvider
    public let suggestionService: SuggestionsService
    public let locationManager: LocationService
    
    public init(
        locationProvider: LocationProvider, suggestionService: SuggestionsService, locationManager: LocationService
    ) {
        self.locationProvider = locationProvider
        self.suggestionService = suggestionService
        self.locationManager = locationManager
    }
}
