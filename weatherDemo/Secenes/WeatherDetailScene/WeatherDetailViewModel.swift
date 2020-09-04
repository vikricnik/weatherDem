//
//  WeatherDetailViewModel.swift
//  weatherDemo
//
//  Created by dies irae on 03/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import Combine
import CoreLocation
import UIKit

class WeatherDetailViewModel: BaseViewModel {

    @Published var currentWeatherResponse: CurrentWeatherResponse?
    @Published var detailWeatherResponse: DetailWeatherResponse?
    @Published var mapData: Data?

    private let placemark: CLPlacemark?
    private let cityName: String?
    private var usecase: GatewayType { gateway }
    private var cancellables: Set<AnyCancellable> = []

    init(gateway: Gateway = Gateway(),
         router: BaseRouterType,
         cityName: String?,
         placemark: CLPlacemark?) {

        self.placemark = placemark
        self.cityName = cityName

        super.init(gateway: gateway, router: router)

        loadData()
    }

    private func loadData() {
        if let location = placemark?.location {
            usecase.currentWeather(location: location)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.router?.show(error: error)
                    }
                    }, receiveValue: { [weak self] response in
                        self?.currentWeatherResponse = response
                })
                .store(in: &cancellables)

            usecase.detailWeather(location: location)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.router?.show(error: error)
                    }
                    }, receiveValue: { [weak self] response in
                        self?.detailWeatherResponse = response
                })
                .store(in: &cancellables)
        } else if let cityName = cityName {
            usecase.currentWeatherForCity(city: cityName)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.router?.show(error: error)
                    }
                    }, receiveValue: { [weak self] response in
                        self?.currentWeatherResponse = response
                })
                .store(in: &cancellables)
        }
    }

    func loadImageWithSize(size: CGSize) {
        let city = placemark?.locality ?? cityName ?? ""
        usecase.mapImageFor(location: city, size: size)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.router?.show(error: error)
                }
                }, receiveValue: { [weak self] response in
                    self?.mapData = response
            })
            .store(in: &cancellables)
    }
}
