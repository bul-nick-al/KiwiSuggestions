//
//  Flight.swift
//  CommonModels
//
//  Created by Николай Булдаков on 25.05.2021.
//

import Foundation

// MARK: - Flight

public struct Flight: Codable {
    public let id: String
    public let flyFrom, flyTo, cityFrom: String?
    public let cityCodeFrom, cityTo, cityCodeTo: String?
    public let countryFrom, countryTo: Country?
    public let dTime, dTimeUTC, aTime, aTimeUTC: Int?
    public let distance: Double
    public let duration: Duration?
    public let flyDuration: String?
    public let price: Int?
    public let conversion: [String: Double]?
    public let availability: Availability?
    public let routes: [[String]]?
    public let route: [Route]?
    public let airlines: [String]?
    public let bookingToken: String?
    public let deepLink: String?
    public let mapIdfrom, mapIdto: String?
    public let hashtags: [String]?

    public enum CodingKeys: String, CodingKey {
        case id, flyFrom, flyTo, cityFrom, cityCodeFrom, cityTo
        case cityCodeTo, countryFrom, countryTo, dTime, dTimeUTC, aTime, aTimeUTC
        case distance, duration
        case flyDuration = "fly_duration"
        case price, conversion
        case route
        case availability, routes, airlines
        case bookingToken = "booking_token"
        case deepLink = "deep_link"
        case mapIdfrom, mapIdto, hashtags
    }

    public init(
        id: String, flyFrom: String, flyTo: String, cityFrom: String, cityCodeFrom: String, cityTo: String,
        cityCodeTo: String, countryFrom: Country, countryTo: Country, dTime: Int, dTimeUTC: Int, aTime: Int,
        aTimeUTC: Int, distance: Double, duration: Duration, flyDuration: String, price: Int, conversion: [String: Double],
        availability: Availability, routes: [[String]], airlines: [String], bookingToken: String, deepLink: String,
        mapIdfrom: String, mapIdto: String, hashtags: [String]
    ) {
        self.id = id
        self.flyFrom = flyFrom
        self.flyTo = flyTo
        self.cityFrom = cityFrom
        self.cityCodeFrom = cityCodeFrom
        self.cityTo = cityTo
        self.cityCodeTo = cityCodeTo
        self.countryFrom = countryFrom
        self.countryTo = countryTo
        self.dTime = dTime
        self.dTimeUTC = dTimeUTC
        self.aTime = aTime
        self.aTimeUTC = aTimeUTC
        self.distance = distance
        self.duration = duration
        self.flyDuration = flyDuration
        self.price = price
        self.conversion = conversion
        self.availability = availability
        self.routes = routes
        self.airlines = airlines
        self.bookingToken = bookingToken
        self.deepLink = deepLink
        self.mapIdfrom = mapIdfrom
        self.mapIdto = mapIdto
        self.hashtags = hashtags
        self.route = []
    }

    public init(
        id: String
    ) {
        self.id = id
        self.flyFrom = "flyFrom"
        self.flyTo = "flyTo"
        self.cityFrom = "cityFrom"
        self.cityCodeFrom = "cityCodeFrom"
        self.cityTo = "cityTo"
        self.cityCodeTo = "cityCodeTo"
        self.countryFrom = .init(code: "", name: "")
        self.countryTo = .init(code: "", name: "")
        self.dTime = 0
        self.dTimeUTC = 0
        self.aTime = 0
        self.aTimeUTC = 0
        self.distance = 0
        self.duration = .init(departure: 0, return: 0, total: 0)
        self.flyDuration = ""
        self.price = 0
        self.conversion = ["eur": 20]
        self.availability = .init(seats: 0)
        self.routes = .init()
        self.airlines = .init()
        self.bookingToken = "bookingToken"
        self.deepLink = "deepLink"
        self.mapIdfrom = "mapIdfrom"
        self.mapIdto = "mapIdto"
        self.hashtags = .init()
        self.route = []
    }
}

// MARK: - Availability
public struct Availability: Codable {
    public let seats: Int?

    public init(seats: Int?) {
        self.seats = seats
    }
}

// MARK: - Country
public struct Country: Codable {
    public let code, name: String?

    public init(code: String?, name: String?) {
        self.code = code
        self.name = name
    }
}

// MARK: - Duration
public struct Duration: Codable {
    public let departure, `return`, total: Int?

    public init(departure: Int?, return: Int?, total: Int?) {
        self.departure = departure
        self.`return` = `return`
        self.total = total
    }
}

// MARK: - Route
public struct Route: Codable {
    let id, combinationID: String
    let flyFrom: String?
    let flyTo: String
    let cityFrom: String?
    let cityCodeFrom: String?
    let cityTo, cityCodeTo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case combinationID = "combination_id"
        case flyFrom, flyTo, cityFrom, cityCodeFrom, cityTo, cityCodeTo
    }
}
