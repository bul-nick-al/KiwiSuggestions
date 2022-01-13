//
//  Router.swift
//  Router
//
//  Created by Nikolay Buldakov on 12.01.2022.
//

import Foundation
import UIKit
import Combine
import Authentication
import CommonModels

public class Router {
    public typealias Factory = AuthenticationViewModelFactory & FlightSuggestionsDependenciesFactory
    let window: UIWindow
    let authenticationService: AuthenticationService
    let factory: Factory
    
    public init(window: UIWindow, authenticationService: AuthenticationService, factory: Factory) {
        self.window = window
        self.authenticationService = authenticationService
        self.factory = factory
    }
    
    public func root() {
        DispatchQueue.main.async { [self] in
            if !authenticationService.isAuthenticated {
                let vc = UINavigationController()
                window.rootViewController = vc
                
                let viewModel = factory.makeAuthenticationViewModel()
                let presenter = AuthenticationPresenter(viewModel: viewModel, routes: self)
                
                DeinitWatcher.watch(vc, onDeinit: [{ _ = presenter }])
            } else {
                let vc = FlightSuggestionsViewController(
                    dependenies: factory.makeFlightSuggestionsDependencies(), routers: self
                )
                
                window.rootViewController = vc
            }
        }
    }
}

import AuthenticationScene
import SwiftUI
import SuggestionsScreen

extension Router: AuthenticationRoutes {
    public func openPhoneNumberStep(phoneNumberSubscriper: AnySubscriber<String, Never>) {
        DispatchQueue.main.async { [self] in
            let vc = UIHostingController(rootView: PhoneNumberStepView(
                configuration: PhoneNumberStepPresenter(phoneNumber: phoneNumberSubscriper)
            ))

            (window.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
        }
    }
    
    public func openPasswordStep(passwordSubscriper: AnySubscriber<String, Never>, error: AnyPublisher<String, Never>) {
        DispatchQueue.main.async { [self] in
            let vc = UIHostingController(rootView: PasswordStepView(
                configuration: PasswordStepPresenter(password: passwordSubscriper, error: error)
            ))

            (window.rootViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        }
    }
    
    public func completeAuthentication() {
        root()
    }
}

extension Router: FlightSuggestionsRoutes {
    public func openFlightSuggestion(flight: Flight) {
        let vc = FlightFullDetailsViewController()
        
        let transittionDelegate = CardTransitionDelegate()
        
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transittionDelegate
        
        vc.configure(with: flight)
    
        DeinitWatcher.watch(vc, onDeinit: [{ _ = transittionDelegate }])
        
        window.rootViewController?.present(vc, animated: true, completion: nil)
    }
}

public final class DeinitWatcher {
    private static var key: UInt8 = 0

    private var onDeinit: [() -> Void]

    private init(onDeinit: [() -> Void]) {
        self.onDeinit = onDeinit
    }

    public static func watch(_ obj: Any, onDeinit: [() -> Void]) {
        watch(obj, key: &key, onDeinit: onDeinit)
    }

    public static func watch(_ obj: Any, key: UnsafeRawPointer, onDeinit: [() -> Void]) {
        objc_setAssociatedObject(obj, key, Self(onDeinit: onDeinit), .OBJC_ASSOCIATION_RETAIN)
    }

    deinit { onDeinit.forEach { $0() } }
}
