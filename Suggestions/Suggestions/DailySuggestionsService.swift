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

    static let flightSuggestionStorageKey = "DatedFlightSuggestion"
    static let expiredSuggestionsIdsKey = "expiredSuggestionsIdsKey"

    private let storage: StorageService
    private let dateProvider: DateProvider
    private let locationProvider: LocationProvider
    private let api: ApiService
    private let maxNumberOfSuggestions: Int

    init(
        storage: StorageService,
        dateProvider: DateProvider,
        locationProvider: LocationProvider,
        api: ApiService,
        maxNumberOfSuggestions: Int
    ) {
        self.storage = storage
        self.dateProvider = dateProvider
        self.locationProvider = locationProvider
        self.api = api
        self.maxNumberOfSuggestions = maxNumberOfSuggestions
    }

    fileprivate func loadFlightSuggestions(callback: @escaping (Result<DatedFlightSuggestion, Error>) -> Void) {
        api.findFlights(for: locationProvider.location) { [weak self] in
            guard let self = self else {
                callback(.failure(DailySuggestionsServiceError.serviceDeinitialised))

                return
            }

            switch $0.flatMap(self.getSuitableSuggestions) {
            case .success(let flights):
                self.fligtsToDatedFlightSuggestion(flights, callback: callback)
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

    fileprivate func fligtsToDatedFlightSuggestion(_ flights: [Flight], callback: @escaping (Result<DatedFlightSuggestion, Error>) -> Void) {
        let fallbackSuggestion = DatedFlightSuggestion(
            date: dateProvider.date, suggestedFlights: flights, destinationImages: [:]
        )

        loadDestinationImages(for: flights) { callback($0.map { [weak self] in
            guard let self = self else {
                callback(.failure(DailySuggestionsServiceError.serviceDeinitialised))

                return fallbackSuggestion
            }

            let dailySuggestion = DatedFlightSuggestion(
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
    var hasCachedSuggestions: Bool {
        guard
            let storedFlightSuggestion: DatedFlightSuggestion = storage.getValue(for: Self.flightSuggestionStorageKey),
            Calendar.current.isDate(storedFlightSuggestion.date, inSameDayAs: dateProvider.date)
        else { return false }

        return true
    }


    func getFlightSuggestions(_ callback: @escaping (Result<DatedFlightSuggestion, Error>) -> Void) {
        guard
            let storedFlightSuggestion: DatedFlightSuggestion = storage.getValue(for: Self.flightSuggestionStorageKey),
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
