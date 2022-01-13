//
//  AuthenticationRoutes.swift
//  AuthenticationScene
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
import Combine

public protocol AuthenticationRoutes {
    func openPhoneNumberStep(phoneNumberSubscriper: AnySubscriber<String, Never>)
    func openPasswordStep(passwordSubscriper: AnySubscriber<String, Never>, error: AnyPublisher<String, Never>)
    func completeAuthentication()
}
