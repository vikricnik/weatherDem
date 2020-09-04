//
//  LocatioonListViewModel.swift
//  weatherDemo
//
//  Created by dies irae on 02/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocatioonListViewModel: BaseViewModel {

    @Published var currentPlacemark: CLPlacemark?

    var usecase: GatewayType { gateway }

    override init(gateway: Gateway = Gateway(), router: BaseRouterType) {
        super.init(gateway: gateway, router: router)

        usecase.observe(didChangeAuthorizationStatus: nil,
                        didUpdateLocationsLocations: nil,
                        didDecodePlacemarks: { [weak self] placemarks in
                            self?.currentPlacemark = placemarks.first
                        },
                        errorCompletion: nil)
    }

    func didTapCurrentLocation(placemark: CLPlacemark) {
        router?.show(route: .weatherDetailViewController(placemark: placemark, city: nil))
    }

    func didSelectCity(city: String) {
        router?.show(route: .weatherDetailViewController(placemark: nil, city: city))
    }
}
