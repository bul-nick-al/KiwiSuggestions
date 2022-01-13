//
//  AuthenticationError.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation

enum AuthenticationError: CustomStringConvertible {
    case wrongCredentials
    
    var description: String {
        switch self {
        case .wrongCredentials:
            return "Wrong credentials"
        }
    }
}
