//
//  HomeViewModel.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class HomeViewModel: BaseViewModel {
    var locationUseCase: GatewayType { gateway }
}

extension HomeViewModel {
    func startMonitoring(locationStatus: ((CLAuthorizationStatus) -> Void)?) {
        locationUseCase.observe(didChangeAuthorizationStatus: locationStatus,
                                didUpdateLocationsLocations: nil,
                                didDecodePlacemarks: { placemarks in
                                    print(placemarks)
        },
                                errorCompletion: nil)
    }
}
