//
//  LocationProvider.swift
//  CommonModels
//
//  Created by Николай Булдаков on 30.05.2021.
//

// A protocol which other parts may use to improve testability
public protocol LocationProvider {
    var location: Location { get }
}
