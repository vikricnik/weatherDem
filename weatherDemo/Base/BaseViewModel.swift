//
//  BaseViewModel.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import CoreLocation

class BaseViewModel {

    let gateway: Gateway
    weak var router: BaseRouterType?

    init(gateway: Gateway = Gateway(), router: BaseRouterType) {
        self.gateway = gateway
        self.router = router
    }
}
