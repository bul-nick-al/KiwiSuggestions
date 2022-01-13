//
//  AuthenticationMock.swift
//  Authentication
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation

class AuthenticationMock: AuthenticationService {
    let phone = "1234"
    let password = "12345"

    var isAuthenticated: Bool = false
    
    
    func authenticate(authenticationData: AuthenticationRequest) async -> AuthenticationResponse {
        switch (authenticationData.phone, authenticationData.password) {
        case (phone, password):
            isAuthenticated = true
            return .token("")
        case ("", _):
            return .error(.phoneNumberRequired)
        case (_, ""):
            return .error(.passwordRequired)
        default:
            return .error(.wrongCredentials)
        }
    }
}
