//
//  ApiMock.swift
//  API
//
//  Created by Николай Булдаков on 27.05.2021.
//

import Foundation
import CommonModels
import UIKit

class ApiMock: ApiService {
    func getImage(for destination: String, _ completionHandler: @escaping (Result<Data, Error>) -> Void) {
        completionHandler(.success(UIImage(named: "image1")!.pngData()!))
    }

    func findFlights(for location: Location, _ completionHandler: @escaping (Result<[Flight], Error>) -> Void) {
        completionHandler(.success((0...100).map { "\($0)" }.map(Flight.init(id:))))
    }
}
