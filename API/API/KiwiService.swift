//
//  KiwiService.swift
//  API
//
//  Created by Николай Булдаков on 27.05.2021.
//

import Foundation
import CommonModels
import UIKit

class KiwiApiService {
    func getURL(for location: Location) -> URL? {
        URL(string: "https://api.skypicker.com/flights?v=3&sort=popularity&asc=0&locale=en&children=0&infants=0&fly_from=\(location.latitude)-\(location.longitude)-250km&to=anywhere&featureName=aggregateResults&dateFrom=25/05/2021&dateTo=25/06/2021&typeFlight=oneway&one_per_date=0&oneforcity=1&wait_for_refresh=0&adults=1&limit=45&partner=skypicker")
    }

    func getPhotoURL(for destination: String) -> URL? {
        URL(string: "https://images.kiwi.com/photos/600x330/\(destination).jpg")
    }
}

extension KiwiApiService: ApiService {
    func getImage(for destination: String, _ completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = getPhotoURL(for: destination) else {
            completionHandler(.failure(ApiError.invalidUrl))

            return
        }

        let dataTask = URLSession.shared.dataTask(with: .init(url: url)) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))

                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                completionHandler(.failure(ApiError.serverError))
                return
            }

            guard
                let data = data,
                UIImage(data: data) != nil

            else {
                completionHandler(.failure(ApiError.couldNotPaceData))
                return
            }

            completionHandler(.success(data))
        }

        dataTask.resume()
    }

    func findFlights(for location: Location, _ completionHandler: @escaping (Result<[Flight], Error>) -> Void) {
        guard let url = getURL(for: location) else {
            completionHandler(.failure(ApiError.invalidUrl))

            return
        }

        let dataTask = URLSession.shared.dataTask(with: .init(url: url)) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))

                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                completionHandler(.failure(ApiError.serverError))
                return
            }

            guard
                let data = data,
                let flightsSearchResult = try? JSONDecoder().decode(FlightsSearchResult.self, from: data)
            else {
                completionHandler(.failure(ApiError.couldNotPaceData))
                return
            }

            completionHandler(.success(flightsSearchResult.data))
        }

        dataTask.resume()
    }
}

public enum ApiError: Error {
    case invalidUrl
    case couldNotPaceData
    case serverError
}
