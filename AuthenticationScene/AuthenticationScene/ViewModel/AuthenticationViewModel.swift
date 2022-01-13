//
//  AuthenticationViewModel.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
import CommonModels
import Combine
import Authentication

public class AuthenticationViewModel: Transformable {
    var dependencies: AuthenticationDependencies
    var authenticationService: AuthenticationService { dependencies.authenticationService }
    
    public init(dependencies: AuthenticationDependencies) {
        self.dependencies = dependencies
    }

    public func transform(input: AuthenticationViewModelInput) -> AuthenticationViewModelOutput {
        
        let loginRequest = Publishers.CombineLatest(
            input.phoneNumber.prepend(""),
            Publishers.Merge(input.password.prepend(""), input.phoneNumber.map { _ in "" })
        ).map(AuthenticationRequest.init)
        
        let response = loginRequest
            .map { request in
                Future { [weak self] in await self?.authenticationService.authenticate(authenticationData: request) }
                .compactMap { $0 }
            }
            .switchToLatest()
        
        let complete = response.filter {
            guard case .token = $0 else { return false }
            
            return true
        }
            .map { _ in }
            .eraseToAnyPublisher()
                
        
        let responseError = response.compactMap { response -> AuthenticationResponseError? in
            guard case .error(let error) = response else { return nil }
            
            return error
        }
        
        let nextStep = responseError.compactMap { responseError -> AuthenticationStep? in
            switch responseError {
            case .phoneNumberRequired:
                return .phoneNumber
            case .passwordRequired:
                return .password
            case .wrongCredentials:
                return nil
            }
        }.eraseToAnyPublisher()
        
        let error = responseError.compactMap { responseError -> AuthenticationError? in
            switch responseError {
            case .phoneNumberRequired, .passwordRequired:
                return nil
            case .wrongCredentials:
                return .wrongCredentials
            }
        }.eraseToAnyPublisher()
        
        return .init(
            nextStep: nextStep,
            complete: complete,
            error: error
        )
    }
}
