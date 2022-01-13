//
//  Input.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Combine

public struct AuthenticationViewModelInput {
    var start: AnyPublisher<Void, Never>
    var phoneNumber: AnyPublisher<String, Never>
    var password: AnyPublisher<String, Never>
}
