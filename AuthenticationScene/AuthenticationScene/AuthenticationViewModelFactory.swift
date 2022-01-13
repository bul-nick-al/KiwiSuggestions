//
//  AuthenticationViewModelFactory.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

public protocol AuthenticationViewModelFactory {
    func makeAuthenticationViewModel() -> AuthenticationViewModel
}
