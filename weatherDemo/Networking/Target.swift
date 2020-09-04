//
//  WeatherTarget.swift
//  weatherDemo
//
//  Created by dies irae on 02/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import Combine
import CoreLocation
import UIKit

enum Target: TargetType {

    private var apiKey: String {
        switch self {
        case .currentForCity:
            return "188ffd2ae11611d39516ad8f06a2a097"
        case .current:
            return "188ffd2ae11611d39516ad8f06a2a097"
        case .detail:
            return "188ffd2ae11611d39516ad8f06a2a097"
        case .mapImage:
            return "Aj6gojfxiAKb3WzZbQG2Z6zy8mRm2cRKJL0NDIi7pbgMk-SA81u9DlpWdn05elfO"
        }
    }

    case
    currentForCity(city: String),
    current(location: CLLocation),
    detail(location: CLLocation),
    mapImage(locatiuonName: String, size: CGSize)

    var schema: String {
        return "https"
    }

    var host: String {
        switch self {
        case .currentForCity:
            return "api.openweathermap.org"
        case .current:
            return "api.openweathermap.org"
        case .detail:
            return "api.openweathermap.org"
        case .mapImage:
            return "dev.virtualearth.net"
        }
    }

    var header: [String: String] {
        return [:]
    }

    var body: Data? {
        nil
    }

    var httpMethod: String {
        return "GET"
    }

    var path: String {
        switch self {
        case .currentForCity:
            return "/data/2.5/weather"
        case .current:
            return "/data/2.5/weather"
        case .detail:
            return "/data/2.5/onecall"
        case .mapImage(locatiuonName: let location, _):
            return "/REST/v1/Imagery/Map/AerialWithLabels/\(location)"
        }
    }

    var queryItems:  [URLQueryItem]? {
        switch self {
        case .currentForCity(city: let city):
            return [
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "units", value: "metric")
            ]
        case .current(location: let loc):
            return [
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "lat", value: "\(loc.coordinate.latitude)"),
                URLQueryItem(name: "lon", value: "\(loc.coordinate.longitude)"),
                URLQueryItem(name: "units", value: "metric")
            ]
        case .detail(location: let loc):
            return [
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "lat", value: "\(loc.coordinate.latitude)"),
                URLQueryItem(name: "lon", value: "\(loc.coordinate.longitude)"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "exclude", value: "current"),
            ]
        case .mapImage(locatiuonName: _, size: let size):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "mapSize", value: "\(Int(size.width)),\(Int(size.height))"),
            ]
        }
    }

}
