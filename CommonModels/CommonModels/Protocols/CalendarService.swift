//
//  CalendarService.swift
//  CommonModels
//
//  Created by Николай Булдаков on 26.05.2021.
//

import Foundation

// A protocol which other parts may use to improve testability
public protocol DateProvider {
    var date: Date { get }
}
