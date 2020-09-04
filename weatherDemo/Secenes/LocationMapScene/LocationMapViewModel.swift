//
//  LocationMapViewModel.swift
//  weatherDemo
//
//  Created by dies irae on 03/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationMapViewModel: BaseViewModel {

    @Published var placemark: CLPlacemark?

    private var usecase: GatewayType { gateway }

    override init(gateway: Gateway = Gateway(),
         router: BaseRouterType) {
        super.init(gateway: gateway, router: router)
        usecase.observe(didChangeAuthorizationStatus: nil,
                        didUpdateLocationsLocations: nil,
                        didDecodePlacemarks: { [weak self] placemarks in
                            self?.placemark = placemarks.first
                        },
                        errorCompletion: nil)
    }

    func didSelectLocation(location: CLLocation) {
        usecase.resolve(location: location) { [weak self] set in
            guard let pm = set.first else { return }
            self?.router?.show(route: .weatherDetailViewController(placemark: pm, city: nil))
            self?.router?.rootNavigationViewController?
                .viewControllers
                .map { $0 as? HomeViewController }
                .compactMap { $0 }
                .first?
                .viewControllers?
                .map { $0 as? LocatioonListViewController }
                .compactMap { $0 }
                .first?.recentMapLocation? ( pm )
        }
    }
}
