//
//  LocationMapView.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import FlexLayout
import PinLayout

class LocationMapView: UIView {

    let rootContainer = UIView()
    let mapView = MKMapView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        rootContainer.flex.define({ flex in
            flex.addItem(mapView)
                .width(100%)
                .height(100%)
        })
//        rootContainer.flex.addItem(mapView)
        addSubview(rootContainer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rootContainer.pin.all(pin.safeArea)
        rootContainer.flex.layout()
    }
}
