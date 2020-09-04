//
//  LocationMapViewController.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import Combine
import CoreLocation
import MapKit

class LocationMapViewController: UIViewController {

    var viewModel: LocationMapViewModel?

    private var cancellables: Set<AnyCancellable> = []
    private var mapView: LocationMapView? { view as? LocationMapView }
    private var placemark: CLPlacemark? {
        didSet {
            if let location = placemark?.location {
                self.mapView?.mapView.setCenter(location.coordinate, animated: true)
                self.mapView?.mapView.addAnnotation(placemark!)
            }
        }
    }

    override func loadView() {
        view = LocationMapView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView?.mapView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnMap))
        mapView?.mapView.addGestureRecognizer(tap)

        viewModel?.$placemark
            .sink() { [weak self] placemark in
                if let placemark = placemark, placemark != self?.placemark {
                    self?.placemark = placemark
                }
            }
            .store(in: &cancellables)
    }

    @objc func didTapOnMap(tap: UITapGestureRecognizer) {
        guard let mv = mapView else { return }
        let point = tap.location(in: mv.mapView)
        let coord = mv.mapView.convert(point, toCoordinateFrom: mv.mapView)
        let loc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        viewModel?.didSelectLocation(location: loc)
    }
}

extension LocationMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
    }
}

extension CLPlacemark: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        self.location!.coordinate
    }

    public var title: String? {
        self.locality
    }
}
