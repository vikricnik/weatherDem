//
//  WeatherDetailViewController.swift
//  weatherDemo
//
//  Created by dies irae on 03/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import Combine

class WeatherDetailViewController: UIViewController {
    var viewModel: WeatherDetailViewModel? {
        didSet {
            subscribe()
        }
    }

    private var cancellables: Set<AnyCancellable> = []
    private var detailView: WeatherDetailView? { view as? WeatherDetailView }

    override func loadView() {
        view = WeatherDetailView(frame: .zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let size = CGSize(width: view.frame.size.width, height: view.frame.size.height / 3)
        viewModel?.loadImageWithSize(size: size)
    }

    private func subscribe() {
        viewModel?.$currentWeatherResponse
            .sink() { [weak self] response in
                if let response = response {
                    self?.detailView?.addCurrentWeather(current: response)
                }
            }
            .store(in: &cancellables)

        viewModel?.$detailWeatherResponse
            .sink() { [weak self] response in
                if let response = response {
                    self?.detailView?.addDetailWeather(detail: response)
                }
            }
            .store(in: &cancellables)

        viewModel?.$mapData
            .sink() { [weak self] data in
                if let data = data {
                    self?.detailView?.imageView.image = UIImage(data: data)
                }
            }
            .store(in: &cancellables)
    }
}
