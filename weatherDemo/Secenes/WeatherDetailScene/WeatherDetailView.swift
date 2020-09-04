//
//  WeatherDetailView.swift
//  weatherDemo
//
//  Created by dies irae on 03/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import PinLayout
import FlexLayout

class WeatherDetailView: UIView  {
    let container = UIView()
    let imageView = UIImageView(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .grouped)
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Minute", "Hourly", "Daily"])
        return sc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        tableView.backgroundColor = .white
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = .lightGray
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(didTapSegment), for: .valueChanged)
        segment.flex.display(.none)
        container.flex
            .define { flex in
                flex.addItem(imageView)
                    .height(30%)
                flex.addItem(tableView)
                    .height(65%)
                flex.addItem(segment)
                    .height(5%)
        }
        addSubview(container)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        container.pin.all(pin.safeArea)
        container.flex.layout()
    }

    var detailResponse: DetailWeatherResponse?
    func addDetailWeather(detail: DetailWeatherResponse) {
        segment.flex.display(.flex)
        container.flex.layout()
        self.detailResponse = detail
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionFooterHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func addCurrentWeather(current: CurrentWeatherResponse) {
        let header = UIView(frame: .zero)

        header.flex.define { flex in
            flex.addItem(viewForCurrentSection(current: current))
            if let view = viewFor(sys: current.sys) {
                flex.addItem(view)
                .paddingVertical(10)
            }
            if let view = viewFor(weathers: current.weather) {
                flex.addItem(view)
                .paddingVertical(10)
            }
            if let view = viewFor(coord: current.coord) {
                flex.addItem(view)
                .paddingVertical(10)
            }
            if let view = viewFor(main: current.main) {
                flex.addItem(view)
                .paddingVertical(10)
            }
            if let view = viewFor(wind: current.wind) {
                flex.addItem(view)
                .paddingVertical(10)
            }
            if let view = viewFor(rain: current.rain) {
                flex.addItem(view)
                .paddingVertical(10)
            }
            if let view = viewFor(clouds: current.clouds) {
                flex.addItem(view)
                .paddingVertical(10)
            }
        }
        .padding(10)

        header.flex.width(self.frame.size.width)
        header.flex.layout(mode: .adjustHeight)

        tableView.tableHeaderView = header
    }

    private func viewFor(weathers: [Weather]) -> UIView? {
        guard !weathers.isEmpty else { return nil }

        let container = UIView(frame: .zero)

        container.flex.define { flex in
            weathers.forEach {
                flex.addItem(viewFor(weather: $0))
            }
        }

        return container
    }

    private func viewFor(weather: Weather) -> UIView {
        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(descriptionView(key: "ID", value: "\(weather.id)"))
            if let main = weather.main {
                flex.addItem(descriptionView(key: "Main", value: main))
            }
            if let weatherDescription = weather.weatherDescription {
                flex.addItem(descriptionView(key: "Weather Description", value: weatherDescription))
            }
            flex.addItem()
                .backgroundColor(.black)
                .width(100%)
                .height(1)
        }

        return container
    }

    private func viewFor(sys: Sys?) -> UIView? {
        guard let sys = sys else { return nil }

        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(sectionLabel(text: "Local data:"))
            flex.addItem(descriptionView(key: "Type", value: "\(sys.type)"))
            flex.addItem(descriptionView(key: "ID", value: "\(sys.id)"))
            if let country = sys.country {
                flex.addItem(descriptionView(key: "Country", value: country))
            }
            if let sunset = sys.sunset,
                let t = Double(exactly: sunset) {
                let date = Date(timeIntervalSince1970: t)
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.medium
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeZone = .current
                let localDate = dateFormatter.string(from: date)
                flex.addItem(descriptionView(key: "Sunset", value: localDate))
            }
            if let sunrise = sys.sunrise,
                let t = Double(exactly: sunrise) {
                let date = Date(timeIntervalSince1970: t)
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.medium
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeZone = .current
                let localDate = dateFormatter.string(from: date)
                flex.addItem(descriptionView(key: "Sunrise", value: localDate))
            }
        }

        return container
    }

    private func viewFor(clouds: Clouds?) -> UIView? {
        guard let clouds = clouds else { return nil }

        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(sectionLabel(text: "Clouds:"))
            if let cloud = clouds.all {
                flex.addItem(descriptionView(key: "Percentage", value: "\(cloud) %"))
            }
        }

        return container
    }

    private func viewFor(rain: Rain?) -> UIView? {
        guard let rain = rain else { return nil }

        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(sectionLabel(text: "Rain:"))
            if let h = rain.the1H {
                flex.addItem(descriptionView(key: "1H", value: "\(h) mm"))
            }
            if let h = rain.the3H {
                flex.addItem(descriptionView(key: "3H", value: "\(h) mm"))
            }
        }

        return container
    }

    private func viewFor(wind: Wind?) -> UIView? {
        guard let wind = wind else { return nil }

        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(sectionLabel(text: "Wind:"))
            if let speed = wind.speed {
                flex.addItem(descriptionView(key: "Speed", value: "\(speed)"))
            }
            if let deg = wind.deg {
                flex.addItem(descriptionView(key: "Deg", value: "\(deg)"))
            }
        }

        return container
    }

    private func viewFor(main: Main?) -> UIView? {
        guard let main = main else { return nil }

        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(sectionLabel(text: "Main:"))
            if let temp = main.temp {
                flex.addItem(descriptionView(key: "Temperature", value: "\(temp)"))
            }
            if let feelsLike = main.feelsLike {
                flex.addItem(descriptionView(key: "Feels Like", value: "\(feelsLike)"))
            }
            if let tempMin = main.tempMin {
                flex.addItem(descriptionView(key: "Temperature min", value: "\(tempMin)"))
            }
            if let tempMax = main.tempMax {
                flex.addItem(descriptionView(key: "Temperature max", value: "\(tempMax)"))
            }
            if let pressure = main.pressure {
                flex.addItem(descriptionView(key: "Pressure", value: "\(pressure)"))
            }
            if let humidity = main.humidity {
                flex.addItem(descriptionView(key: "Humidity", value: "\(humidity)"))
            }
        }

        return container
    }

    private func viewFor(coord: Coord?) -> UIView? {
        guard let coord = coord else { return nil }

        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(sectionLabel(text: "Coordinates:"))
            if let lat = coord.lat {
                flex.addItem(descriptionView(key: "Latitude", value: "\(lat)"))
            }
            if let lon = coord.lon {
                flex.addItem(descriptionView(key: "Longitude", value: "\(lon)"))
            }
        }

        return container
    }

    private func sectionLabel(text: String) -> UILabel {
        let titleLbl = UILabel(frame: .zero)
        titleLbl.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLbl.text = text
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        return titleLbl
    }

    private func viewForCurrentSection(current: CurrentWeatherResponse) -> UIView {
        let container = UIView(frame: .zero)

        container.flex.define { flex in
            flex.addItem(sectionLabel(text: "Current Weather"))
            let str = DateFormatter.current.string(from: Date(timeIntervalSince1970: Double(exactly: current.dt)!))
            flex.addItem(descriptionView(key: "Time", value: str))
            flex.addItem(descriptionView(key: "Timezone", value: "\(current.timezone)"))
            flex.addItem(descriptionView(key: "ID", value: "\(current.id)"))
            if let name = current.name {
                flex.addItem(descriptionView(key: "Name", value: name))
            }
            if let code = current.cod {
                flex.addItem(descriptionView(key: "Code", value: "\(code)"))
            }
            if let base = current.base {
                flex.addItem(descriptionView(key: "Base", value: base))
            }
            if let visibility = current.visibility {
                flex.addItem(descriptionView(key: "Visibility", value: "\(visibility)"))
            }
        }

        return container
    }

    private func descriptionView(key: String, value: String) -> UIView {
        let titleLbl = UILabel(frame: .zero)
        titleLbl.font = UIFont.preferredFont(forTextStyle: .body)
        titleLbl.text = key + ":"
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left

        let detailLbl = UILabel(frame: .zero)
        detailLbl.font = UIFont.preferredFont(forTextStyle: .callout)
        detailLbl.text = value
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .right

        let view = UIView(frame: .zero)
        view.flex
            .direction(.row)
            .justifyContent(.spaceBetween)
            .define { flex in
                flex.addItem(titleLbl)
                flex.addItem(detailLbl)
        }

        return view
    }

    @objc func didTapSegment() {
        tableView.reloadData()
    }
}

extension WeatherDetailView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return detailResponse?.filteredMinutely?.count ?? 0
        }
        if segment.selectedSegmentIndex == 1 {
            return detailResponse?.filteredHourly?.count ?? 0
        }

        if segment.selectedSegmentIndex == 2 {
            return detailResponse?.filteredDaily?.count ?? 0
        }

        return 0

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segment.selectedSegmentIndex == 0 {
            return "Minutes"
        }
        if segment.selectedSegmentIndex == 1 {
            return "Hours"
        }

        if segment.selectedSegmentIndex == 2 {
            return "Days"
        }

        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: DefaultCell
        if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = c as! DefaultCell
        } else {
            cell = DefaultCell(style: .default, reuseIdentifier: "cell")
        }

        if segment.selectedSegmentIndex == 0 {
            cell.update(minute: detailResponse!.filteredMinutely![indexPath.row])
        }
        if segment.selectedSegmentIndex == 1 {
            cell.update(hour: detailResponse!.filteredHourly![indexPath.row])
        }

        if segment.selectedSegmentIndex == 2 {
            cell.update(day: detailResponse!.filteredDaily![indexPath.row])
        }

        return cell
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let cell = cell as? DefaultCell else { return }
//        if segment.selectedSegmentIndex == 0 {
//            cell.update(minute: detailResponse!.filteredMinutely![indexPath.row])
//        }
//        if segment.selectedSegmentIndex == 1 {
//            cell.update(hour: detailResponse!.filteredHourly![indexPath.row])
//        }
//
//        if segment.selectedSegmentIndex == 2 {
//            cell.update(day: detailResponse!.filteredDaily![indexPath.row])
//        }
//    }
}


extension DetailWeatherResponse {
    var filteredMinutely: [Minutely]? {
        minutely?.sorted(by: { $0.dt < $1.dt })
    }
    var filteredDaily: [Daily]? {
        daily?.sorted(by: { $0.dt < $1.dt })
    }
    var filteredHourly: [Hourly]? {
        hourly?.sorted(by: { $0.dt < $1.dt })
    }
}
