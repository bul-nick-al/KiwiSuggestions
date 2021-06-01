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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let defaultLocation = Location(latitude: 51.5, longitude: 0.12)
        let locationProvider = CurrentLocationProvider(location: defaultLocation)

        window?.rootViewController = FlightSuggestionsViewController(
            locationProvider: locationProvider,
            suggestionService: Suggestions.createService(of: .dailySuggestionServiceType(
                    storage: Storage.createService(of: .userDefaults),
                    dateProvider: CurrentDateProvider(),
                    locationProvider: locationProvider,
                    api: API.createService(of: .kiwi),
                    maxNumberOfSuggestions: 5
                )),
            locationManager: createService(of: .standard)
        )
        window?.makeKeyAndVisible()
    }

}

