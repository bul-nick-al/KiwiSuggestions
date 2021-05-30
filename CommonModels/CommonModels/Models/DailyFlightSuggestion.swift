//
//  DailyFlightSuggestion.swift
//  CommonModels
//
//  Created by Николай Булдаков on 26.05.2021.
//

import Foundation

public struct DailyFlightSuggestion {
    public var date: Date
    public var suggestedFlights: [Flight]
    public var destinationImages: [String: Data]

    public init(date: Date, suggestedFlights: [Flight], destinationImages: [String: Data]) {
        self.date = date
        self.suggestedFlights = suggestedFlights
        self.destinationImages = destinationImages
    }
}

extension DailyFlightSuggestion: Codable {}
