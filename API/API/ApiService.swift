//
//  ApiService.swift
//  API
//
//  Created by Николай Булдаков on 26.05.2021.
//

import CommonModels

public protocol ApiService {
    func findFlights(for location: Location, _: @escaping (Result<[Flight], Error>) -> Void)
}
