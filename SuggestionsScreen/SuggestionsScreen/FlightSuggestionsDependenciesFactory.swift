//
//  FlightSuggestionsDependenciesFactory.swift
//  SuggestionsScreen
//
//  Created by Nikolay Buldakov on 13.01.2022.
//

import Foundation

public protocol FlightSuggestionsDependenciesFactory {
    func makeFlightSuggestionsDependencies() -> FlightSuggestionsViewControllerDependencies
}
