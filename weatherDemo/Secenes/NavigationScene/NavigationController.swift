//
//  NavigationController.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit

protocol BaseRouterType: class {
    var rootNavigationViewController: NavigationController? { get }
    func show(route: AppRoutes)
    func show(error: Error)
}

class NavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setViewControllers([AppRoutes.homeTabViewController.viewController], animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViewControllers([AppRoutes.homeTabViewController.viewController], animated: false)
    }

}

extension UIViewController: BaseRouterType {
    var rootNavigationViewController: NavigationController? {
        navigationController as? NavigationController
    }

    func show(route: AppRoutes) {
        rootNavigationViewController?.show(route.viewController, sender: nil)
    }

    func show(error: Error) {
        let alertVC = UIAlertController(title: "Error",
                                        message: "\(error.localizedDescription)",
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: false, completion: nil)
    }

}
