//
//  DailySuggestionsService.swift
//  Suggestions
//
//  Created by Николай Булдаков on 26.05.2021.
//

import Storage
import CommonModels
import Foundation
import API

class DailySuggestionsService {

    static let flightSuggestionStorageKey = "dailyFlightSuggestion"
    static let expiredSuggestionsIdsKey = "expiredSuggestionsIdsKey"

    private let storage: StorageService
    private let dateProvider: DateProvider
    private let api: ApiService
    private let maxNumberOfSuggestions: Int

    init(storage: StorageService, dateProvider: DateProvider, api: ApiService, maxNumberOfSuggestions: Int) {
        self.storage = storage
        self.dateProvider = dateProvider
        self.api = api
        self.maxNumberOfSuggestions = maxNumberOfSuggestions
    }

    fileprivate func loadFlights(callback: @escaping (Result<[Flight], Error>) -> Void) {
        api.findFlights(for: .init(latitude: 55.8, longitude: 49)) { [weak self] in
            guard let self = self else {
                callback(.failure(DailySuggestionsServiceError.serviceDeinitialised))

                return
            }

            callback($0.flatMap(self.getSuitableSuggestions(from:)).map(self.storeUsedFlights(_:)))
        }
    }

    fileprivate func store(flights: [Flight]) {
        storage.save(
            value: DailyFlightSuggestion(date: dateProvider.date, suggestedFlights: flights),
            forKey: Self.flightSuggestionStorageKey
        )
    }

    fileprivate func getSuitableSuggestions(from flights: [Flight]) -> Result<[Flight], Error> {
        let expiredFlightIds: [String] = storage.getValue(for: Self.expiredSuggestionsIdsKey) ?? []

        let suitableFlights = flights.filter { !expiredFlightIds.contains($0.id) }.prefix(maxNumberOfSuggestions)

        guard suitableFlights.count > 0 else {
            return .failure(DailySuggestionsServiceError.noSuitableFlightsFound)
        }

        return .success(Array(suitableFlights))
    }

    fileprivate func storeUsedFlights(_ flights: [Flight]) -> [Flight] {
        storage.save(
            value: DailyFlightSuggestion(date: dateProvider.date, suggestedFlights: flights),
            forKey: Self.flightSuggestionStorageKey
        )

        storage.append(values: flights.map { $0.id }, forKey: Self.expiredSuggestionsIdsKey)

        return flights
    }
}

extension DailySuggestionsService: SuggestionsService {

    func getFlightSuggestions(_ callback: @escaping (Result<[Flight], Error>) -> Void) {
        guard
            let storedFlightSuggestion: DailyFlightSuggestion = storage.getValue(for: Self.flightSuggestionStorageKey),
            Calendar.current.isDate(storedFlightSuggestion.date, inSameDayAs: dateProvider.date)
        else {
            loadFlights { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let flights):
                    self.store(flights: flights)
                    callback(.success(flights))
                case .failure(let error):
                    callback(.failure(error))
                }
            }

            return
        }

        callback(.success(storedFlightSuggestion.suggestedFlights))
    }

}

enum DailySuggestionsServiceError: Error {
    case noSuitableFlightsFound
    case serviceDeinitialised
}
