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
    public let conversion: Conversion?
    public let availability: Availability?
    public let routes: [[String]]?
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
        case availability, routes, airlines
        case bookingToken = "booking_token"
        case deepLink = "deep_link"
        case mapIdfrom, mapIdto, hashtags
    }

    public init(
        id: String, flyFrom: String, flyTo: String, cityFrom: String, cityCodeFrom: String, cityTo: String,
        cityCodeTo: String, countryFrom: Country, countryTo: Country, dTime: Int, dTimeUTC: Int, aTime: Int,
        aTimeUTC: Int, distance: Double, duration: Duration, flyDuration: String, price: Int, conversion: Conversion,
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
        self.conversion = .init(eur: 00)
        self.availability = .init(seats: 0)
        self.routes = .init()
        self.airlines = .init()
        self.bookingToken = "bookingToken"
        self.deepLink = "deepLink"
        self.mapIdfrom = "mapIdfrom"
        self.mapIdto = "mapIdto"
        self.hashtags = .init()
    }
}

// MARK: - Availability
public struct Availability: Codable {
    public let seats: Int?

    public init(seats: Int?) {
        self.seats = seats
    }
}

// MARK: - Conversion
public struct Conversion: Codable {
    public let eur: Int?

    public enum CodingKeys: String, CodingKey {
        case eur = "EUR"
    }

    public init(eur: Int?) {
        self.eur = eur
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
