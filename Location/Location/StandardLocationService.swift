//
//  StandardLocationService.swift
//  LocationService
//
//  Created by Николай Булдаков on 01.06.2021.
//

import CoreLocation
import CommonModels

class StandardLocationService: NSObject {
    private lazy var manager = CLLocationManager()

    private lazy var callbacks: [(Result<Location, Error>) -> Void] = []

    override init() {
        super.init()
        manager.delegate = self
    }
}

extension StandardLocationService: LocationService {
    func getLocation(_ completionHandler: @escaping (Result<Location, Error>) -> Void) {
        callbacks.append(completionHandler)

        manager.requestWhenInUseAuthorization()
    }
}

extension StandardLocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            callbacks.forEach { $0(.failure(LocationManagerError.locationNotFound)) }
            callbacks = []

            return
        }

        callbacks.forEach { $0(.success(.init(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        ))) }

        callbacks = []
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)

        callbacks.forEach { $0(.failure(error)) }
        callbacks = []
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.requestLocation()

            return
        }

        if status == .notDetermined {

            return
        }

        callbacks.forEach { $0(.failure(LocationManagerError.notPermitted)) }
        callbacks = []
    }
}

public enum LocationManagerError: Error {
    case notPermitted
    case locationNotFound
    case serviceUnavailable
}
