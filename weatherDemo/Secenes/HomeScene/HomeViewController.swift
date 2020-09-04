//
//  HomeViewController.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UITabBarController {

    var viewModel: HomeViewModel? {
        didSet {
            startObserving()
        }
    }
    private var routes = [AppRoutes]()

    init(routes: [AppRoutes]) {
        super.init(nibName: nil, bundle: nil)
        self.routes = routes
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBar.isHidden = true
        setViewControllers([AppRoutes.loadingViewController.viewController],
                            animated: false)
    }

    private func startObserving() {
        viewModel?.startMonitoring(locationStatus: { [weak self] status in
            self?.showLoadiingVC(isLoading: status != .authorizedAlways && status != .authorizedWhenInUse )
        })
    }

    private func showLoadiingVC(isLoading: Bool) {
        navigationController?.setNavigationBarHidden(isLoading, animated: false)
        tabBar.isHidden = isLoading
        setViewControllers(isLoading
                                ? [AppRoutes.loadingViewController.viewController]
                                : routes.map { $0.viewController },
                            animated: false)
    }

}
