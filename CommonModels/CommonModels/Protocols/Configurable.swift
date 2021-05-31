//
//  Configurable.swift
//  CommonModels
//
//  Created by Николай Булдаков on 30.05.2021.
//

import Foundation

public protocol Configurable {
    associatedtype ConfigurationModel

    func configure(with configuration: ConfigurationModel)
}
