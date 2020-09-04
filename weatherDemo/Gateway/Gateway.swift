//
//  Gateway.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import CoreLocation
import Combine
import UIKit

protocol GatewayType {
    func observe(didChangeAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?,
                 didUpdateLocationsLocations: (([CLLocation]) -> Void)?,
                 didDecodePlacemarks: ((Set<CLPlacemark>) -> Void)?,
                 errorCompletion: ((Error) -> Void)?)
    func resolve(location: CLLocation, didResolvePlacemark: ((Set<CLPlacemark>) -> Void)?)
    func currentWeather(location: CLLocation) -> AnyPublisher<CurrentWeatherResponse, Error>
    func detailWeather(location: CLLocation) -> AnyPublisher<DetailWeatherResponse, Error>
    func currentWeatherForCity(city: String) -> AnyPublisher<CurrentWeatherResponse, Error>
    func mapImageFor(location: String, size: CGSize) -> AnyPublisher<Data, Error>
}

class Gateway: NSObject {

    private var clManager: CLLocationManager?
    let apiClient: NetworkClient

    private var didChangeAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?
    private var didUpdateLocationsLocations: (([CLLocation]) -> Void)?
    private var didDecodePlacemarks: ((Set<CLPlacemark>) -> Void)?
    private var errorCompletion: ((Error) -> Void)?

    init(apiClient: NetworkClient = NetworkClient()) {
        self.apiClient = apiClient
        super.init()
    }

}

extension Gateway: GatewayType {

    func detailWeather(location: CLLocation) -> AnyPublisher<DetailWeatherResponse, Error> {
        apiClient.request(target: Target.detail(location: location))
    }

    func currentWeather(location: CLLocation) -> AnyPublisher<CurrentWeatherResponse, Error> {
        apiClient.request(target: Target.current(location: location))
    }

    func currentWeatherForCity(city: String) -> AnyPublisher<CurrentWeatherResponse, Error> {
        apiClient.request(target: Target.currentForCity(city: city))
    }

    func mapImageFor(location: String, size: CGSize) -> AnyPublisher<Data, Error> {
        apiClient.request(target: Target.mapImage(locatiuonName: location, size: size))
    }

    func observe(didChangeAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?,
                 didUpdateLocationsLocations: (([CLLocation]) -> Void)?,
                 didDecodePlacemarks: ((Set<CLPlacemark>) -> Void)?,
                 errorCompletion: ((Error) -> Void)?) {
        self.didChangeAuthorizationStatus = didChangeAuthorizationStatus
        self.didUpdateLocationsLocations = didUpdateLocationsLocations
        self.errorCompletion = errorCompletion
        self.didDecodePlacemarks = didDecodePlacemarks

        self.clManager = CLLocationManager()

        clManager?.delegate = self
        clManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        clManager?.pausesLocationUpdatesAutomatically = true
    }

}

extension Gateway: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        didUpdateLocationsLocations?(locations)
        let group = DispatchGroup()
        let geo = CLGeocoder()
        var placemarksSet = Set<CLPlacemark>()
        locations.forEach { location in
            group.enter()
            geo.reverseGeocodeLocation(location) { (placemarks, _) in
                group.leave()
                placemarks?.forEach { placemarksSet.insert($0) }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.didDecodePlacemarks?(placemarksSet)
        }
    }

    func resolve(location: CLLocation, didResolvePlacemark: ((Set<CLPlacemark>) -> Void)?) {
        let geo = CLGeocoder()
        var placemarksSet = Set<CLPlacemark>()
        geo.reverseGeocodeLocation(location) { (placemarks, _) in
            placemarks?.forEach { placemarksSet.insert($0) }
            didResolvePlacemark?(placemarksSet)
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        errorCompletion?(error)
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorizationStatus?(status)
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        }
    }
}
