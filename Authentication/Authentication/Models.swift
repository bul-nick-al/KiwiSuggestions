//
//  Models.swift
//  Authentication
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation

public enum AuthenticationResponse {
    case token(String)
    case error(AuthenticationResponseError)
}

public enum AuthenticationResponseError {
    case phoneNumberRequired
    case passwordRequired
    case wrongCredentials
}
