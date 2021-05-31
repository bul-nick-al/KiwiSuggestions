//
//  Create.swift
//  Suggestions
//
//  Created by Николай Булдаков on 30.05.2021.
//

import Foundation
import CommonModels
import API
import Storage

public func createService(of type: SuggestionsServiceType) -> SuggestionsService {
    switch type {
    case .dailySuggestionServiceType(
            storage: let storage,
            dateProvider: let dateProvider,
            locationProvider: let locationProvider,
            api: let api,
            maxNumberOfSuggestions: let maxNumberOfSuggestions
    ):
        return DailySuggestionsService(
            storage: storage,
            dateProvider: dateProvider,
            locationProvider: locationProvider,
            api: api,
            maxNumberOfSuggestions: maxNumberOfSuggestions
        )
    }
}

public enum SuggestionsServiceType {
    case dailySuggestionServiceType(
            storage: StorageService,
            dateProvider: DateProvider,
            locationProvider: LocationProvider,
            api: ApiService,
            maxNumberOfSuggestions: Int
         )
}
