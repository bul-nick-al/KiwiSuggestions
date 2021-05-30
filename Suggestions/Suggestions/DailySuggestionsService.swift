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

    fileprivate func loadFlightSuggestions(callback: @escaping (Result<DailyFlightSuggestion, Error>) -> Void) {
        api.findFlights(for: .init(latitude: 55.8, longitude: 49)) { [weak self] in
            guard let self = self else {
                callback(.failure(DailySuggestionsServiceError.serviceDeinitialised))

                return
            }

            switch $0.flatMap(self.getSuitableSuggestions) {
            case .success(let flights):
                self.fligtsToDailyFlightSuggestion(flights, callback: callback)
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    fileprivate func getSuitableSuggestions(from flights: [Flight]) -> Result<[Flight], Error> {
        let expiredFlightIds: [String] = storage.getValue(for: Self.expiredSuggestionsIdsKey) ?? []

        let suitableFlights = flights.filter { !expiredFlightIds.contains($0.id) }.prefix(maxNumberOfSuggestions)

        guard suitableFlights.count > 0 else {
            return .failure(DailySuggestionsServiceError.noSuitableFlightsFound)
        }

        return .success(Array(suitableFlights))
    }

    fileprivate func fligtsToDailyFlightSuggestion(_ flights: [Flight], callback: @escaping (Result<DailyFlightSuggestion, Error>) -> Void) {
        let fallbackSuggestion = DailyFlightSuggestion(
            date: dateProvider.date, suggestedFlights: flights, destinationImages: [:]
        )

        loadDestinationImages(for: flights) { callback($0.map { [weak self] in
            guard let self = self else {
                callback(.failure(DailySuggestionsServiceError.serviceDeinitialised))

                return fallbackSuggestion
            }

            let dailySuggestion = DailyFlightSuggestion(
                date: self.dateProvider.date, suggestedFlights: flights, destinationImages: $0
            )
            self.storage.save(value: dailySuggestion, forKey: Self.flightSuggestionStorageKey)

            self.storage.append(values: flights.map { $0.id }, forKey: Self.expiredSuggestionsIdsKey)

            return dailySuggestion
        })}
    }

    func loadDestinationImages(for flights: [Flight], completionHandler: @escaping (Result<[String: Data], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                completionHandler(.failure(DailySuggestionsServiceError.serviceDeinitialised))

                return
            }

            var result: [String: Data] = [:]
            let dispatchGroup = DispatchGroup()

            for destination in flights.compactMap({ $0.mapIdto }) {
                dispatchGroup.enter()

                self.api.getImage(for: destination) {
                    if case .success(let data) = $0 { result[destination] = data }

                    dispatchGroup.leave()
                }
            }

            dispatchGroup.wait()

            DispatchQueue.main.async {
                completionHandler(.success(result))
            }
        }
    }
}

extension DailySuggestionsService: SuggestionsService {

    func getFlightSuggestions(_ callback: @escaping (Result<DailyFlightSuggestion, Error>) -> Void) {
        guard
            let storedFlightSuggestion: DailyFlightSuggestion = storage.getValue(for: Self.flightSuggestionStorageKey),
            Calendar.current.isDate(storedFlightSuggestion.date, inSameDayAs: dateProvider.date)
        else {
            loadFlightSuggestions(callback: callback)

            return
        }

        callback(.success(storedFlightSuggestion))
    }

}

enum DailySuggestionsServiceError: Error {
    case noSuitableFlightsFound
    case serviceDeinitialised
}
