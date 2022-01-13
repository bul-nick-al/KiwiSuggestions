//
//  AuthenticationService.swift
//  Authentication
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
public protocol AuthenticationService {

    /// `true` if a user is logged in, `false` otherwise
    var isAuthenticated: Bool { get }

    /// Authenticates a user
    /// - Parameter authenticationData: the request body with all the needed information about a user
    func authenticate(authenticationData: AuthenticationRequest) async -> AuthenticationResponse
}

public struct AuthenticationRequest {
    public let phone: String
    public let password: String
    
    public init(phone: String, password: String) {
        self.phone = phone
        self.password = password
    }
}
