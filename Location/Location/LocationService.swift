//
//  LocationService.swift
//  LocationService
//
//  Created by Николай Булдаков on 01.06.2021.
//

import CommonModels

public protocol LocationService {
    func getLocation(_: @escaping (Result<Location, Error>) -> Void)
}
