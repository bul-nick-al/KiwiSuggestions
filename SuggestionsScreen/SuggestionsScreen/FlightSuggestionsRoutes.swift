//
//  FlightSuggestionsRoutes.swift
//  SuggestionsScreen
//
//  Created by Nikolay Buldakov on 13.01.2022.
//

import Foundation
import CommonModels

public protocol FlightSuggestionsRoutes {
    func openFlightSuggestion(flight: Flight)
}
