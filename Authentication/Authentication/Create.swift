//
//  Create.swift
//  Authentication
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation

public func create(with configuration: AuthenticationServiceConfiguration) -> AuthenticationService {
    switch configuration {
    case .mock:
        return AuthenticationMock()
    }
}

public enum AuthenticationServiceConfiguration {
    case mock
}
