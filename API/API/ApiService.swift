//
//  ApiService.swift
//  API
//
//  Created by Николай Булдаков on 26.05.2021.
//

import CommonModels
import Foundation

public protocol ApiService {
    func findFlights(for location: Location, _: @escaping (Result<[Flight], Error>) -> Void)
    func getImage(for destination: String, _: @escaping (Result<Data, Error>) -> Void)
}
