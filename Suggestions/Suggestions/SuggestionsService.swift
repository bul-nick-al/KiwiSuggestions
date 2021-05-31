//
//  SuggestionsService.swift
//  Suggestions
//
//  Created by Николай Булдаков on 26.05.2021.
//

import CommonModels

public protocol SuggestionsService {
    func getFlightSuggestions(_: @escaping (Result<DatedFlightSuggestion, Error>) -> Void)
}
