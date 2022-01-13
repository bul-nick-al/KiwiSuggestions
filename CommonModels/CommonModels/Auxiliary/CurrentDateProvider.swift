//
//  CurrentDateProvider.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 01.06.2021.
//

import Foundation

public struct CurrentDateProvider: DateProvider {
    public var date: Date = Date()
    
    public init() {}
}
