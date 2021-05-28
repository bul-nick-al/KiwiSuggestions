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

    public init(date: Date, suggestedFlights: [Flight]) {
        self.date = date
        self.suggestedFlights = suggestedFlights
    }
}

extension DailyFlightSuggestion: Codable {}
