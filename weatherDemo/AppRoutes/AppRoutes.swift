//
//  AppRoutes.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum AppRoutes {
    case
    homeTabViewController,
    locationListViewController,
    locationMapViewController,
    weatherDetailViewController(placemark: CLPlacemark?, city: String?),
    loadingViewController

    var viewController: UIViewController {
        switch self {
        case .homeTabViewController:
            let vc = HomeViewController(routes: [.locationListViewController, .locationMapViewController])
            vc.viewModel = HomeViewModel(router: vc)
            return vc
        case .locationListViewController:
            let vc = LocatioonListViewController()
            vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "location.fill"), selectedImage: nil)
            return vc
        case .locationMapViewController:
            let vc = LocationMapViewController()
            vc.viewModel = LocationMapViewModel(router: vc)
            vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "globe"), selectedImage: nil)
            return vc
        case .weatherDetailViewController(placemark: let placemark, city: let city):
            let vc = WeatherDetailViewController()
            vc.viewModel = WeatherDetailViewModel(router: vc,
                                                  cityName: city,
                                                  placemark: placemark)
            return vc
        case .loadingViewController:
            return LoadingViewController()
        }
    }
}
