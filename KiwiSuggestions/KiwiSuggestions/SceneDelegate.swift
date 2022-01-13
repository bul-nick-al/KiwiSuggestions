//
//  SceneDelegate.swift
//  KiwiSuggestions
//
//  Created by Николай Булдаков on 25.05.2021.
//

import UIKit
import CommonModels
import Suggestions
import Storage
import API
import Location
import Authentication
import AuthenticationScene
import Router
import SuggestionsScreen

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: Router?


    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let dependencyContainer = DependencyContainer()

        router = Router(
            window: window!,
            authenticationService: dependencyContainer.authenticationService,
            factory: dependencyContainer
        )

        router?.root()
        
        

//        window?.rootViewController = FlightSuggestionsViewController(
//            locationProvider: locationProvider,
//            suggestionService:,
//            locationManager: createService(of: .standard)
//        )
//        window?.makeKeyAndVisible()
    }

}

class DependencyContainer {
    let defaultLocation = Location(latitude: 51.5, longitude: 0.12)
    lazy var locationProvider = CurrentLocationProvider(location: defaultLocation)
    lazy var dateProvider = CurrentDateProvider()
    lazy var api = API.createService(of: .kiwi)

    lazy var suggestionService =  Suggestions.createService(of: .dailySuggestionServiceType(
        storage: Storage.createService(of: .userDefaults),
        dateProvider: dateProvider,
        locationProvider: locationProvider,
        api: api,
        maxNumberOfSuggestions: 5
    ))
    
    lazy var authenticationService = Authentication.create(with: .mock)
}


extension DependencyContainer: AuthenticationViewModelFactory {
    func makeAuthenticationViewModel() -> AuthenticationViewModel {
        .init(dependencies: .init(authenticationService: authenticationService))
    }
}

extension DependencyContainer: FlightSuggestionsDependenciesFactory {
    func makeFlightSuggestionsDependencies() -> FlightSuggestionsViewControllerDependencies {
        .init(
            locationProvider: locationProvider,
            suggestionService: suggestionService,
            locationManager: createService(of: .standard)
        )
    }
    
}
