//
//  FlightsSearchResult.swift
//  API
//
//  Created by Николай Булдаков on 27.05.2021.
//

import Foundation
import CommonModels

struct FlightsSearchResult: Codable {
    let data: [Flight]
}
