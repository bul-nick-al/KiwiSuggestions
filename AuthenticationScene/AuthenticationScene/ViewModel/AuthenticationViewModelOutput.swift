//
//  AuthenticationViewModelOutput.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Combine

public struct AuthenticationViewModelOutput {
    var nextStep: AnyPublisher<AuthenticationStep, Never>
    var complete: AnyPublisher<Void, Never>
    var error: AnyPublisher<AuthenticationError, Never>
}
