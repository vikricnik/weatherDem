//
//  LoadingViewController.swift
//  weatherDemo
//
//  Created by dies irae on 01/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import PinLayout
import FlexLayout

class LoadingViewController: UIViewController {
    let activity = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activity.tintColor = .black
        activity.style = .large
        view.addSubview(activity)
        activity.pin.size(CGSize(width: 50, height: 50)).hCenter().vCenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activity.startAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activity.stopAnimating()
    }

}
