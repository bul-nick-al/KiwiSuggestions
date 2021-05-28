//
//  ApiMock.swift
//  API
//
//  Created by Николай Булдаков on 27.05.2021.
//

import Foundation
import CommonModels

class ApiMock: ApiService {
    func findFlights(for location: Location, _ completionHandler: @escaping (Result<[Flight], Error>) -> Void) {
        completionHandler(.success((0...100).map { "\($0)" }.map(Flight.init(id:))))
    }
}
