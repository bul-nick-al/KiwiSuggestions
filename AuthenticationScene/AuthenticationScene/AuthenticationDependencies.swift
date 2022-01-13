//
//  AuthenticationDependencies.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Authentication

public struct AuthenticationDependencies {
    var authenticationService: AuthenticationService

    public init(
        authenticationService: AuthenticationService
    ) {
        self.authenticationService = authenticationService
    }
}
