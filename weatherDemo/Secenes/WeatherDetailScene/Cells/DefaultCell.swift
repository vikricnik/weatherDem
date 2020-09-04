//
//  DefaultCell.swift
//  weatherDemo
//
//  Created by dies irae on 03/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit

class DefaultCell: UITableViewCell {

    var titleLabel: UILabel {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }

    var detailLabel: UILabel {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont.preferredFont(forTextStyle: .callout)
        lbl.numberOfLines = 0
        lbl.textAlignment = .right
        return lbl
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 1) Set the contentView's width to the specified size parameter
        contentView.pin.width(size.width)

        // 2) Layout contentView flex container
        layout()

        // Return the flex container new size
        return contentView.frame.size
    }

    func viewFor(key: String, value: String) -> UIView {
        let view = UIView(frame: .zero)

        let keyLbl = titleLabel
        keyLbl.text = key

        let valueLbl = detailLabel
        valueLbl.text = value
        view.flex.define { flex in
            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .define { flex in
                    flex.addItem(keyLbl)
                    flex.addItem(valueLbl)
            }
        }
        return view

    }

    func update(minute: Minutely) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.flex.define { flex in

            if let ts = Double(exactly: minute.dt) {
                let date = Date(timeIntervalSince1970: ts)
                flex.addItem(viewFor(key: "Time", value: DateFormatter.current.string(from: date)))
            }
            if let p = minute.precipitation {
                flex.addItem(viewFor(key: "Precipitation", value: "\(p)"))
            }

        }
        .padding(10)
    }

    func update(hour: Hourly) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.flex.define { flex in

            if let ts = Double(exactly: hour.dt) {
                let date = Date(timeIntervalSince1970: ts)
                flex.addItem(viewFor(key: "Time", value: DateFormatter.current.string(from: date)))
            }
            if let p = hour.weather?.first?.main {
                flex.addItem(viewFor(key: "Main", value: p))
            }
            if let p = hour.weather?.first?.weatherDescription {
                flex.addItem(viewFor(key: "Description", value: p))
            }
            if let p = hour.rain?.the3H {
                flex.addItem(viewFor(key: "Rain 3H", value: "\(p)%"))
            }
            if let p = hour.temp {
                flex.addItem(viewFor(key: "Temperature", value: "\(p)C"))
            }
            if let p = hour.feelsLike {
                flex.addItem(viewFor(key: "Feels Like", value: "\(p)C"))
            }
            if let p = hour.pressure {
                flex.addItem(viewFor(key: "Pressure", value: "\(p)"))
            }
            if let p = hour.humidity {
                flex.addItem(viewFor(key: "Humidity", value: "\(p)%"))
            }
            if let p = hour.clouds {
                flex.addItem(viewFor(key: "Clouds", value: "\(p)%"))
            }
            if let p = hour.visibility {
                flex.addItem(viewFor(key: "Visibility", value: "\(p)%"))
            }
            if let p = hour.windSpeed {
                flex.addItem(viewFor(key: "Wind Speed", value: "\(p) km/h"))
            }
            if let p = hour.rain?.the1H {
                flex.addItem(viewFor(key: "Rain 1H", value: "\(p)%"))
            }
            if let p = hour.rain?.the3H {
                flex.addItem(viewFor(key: "Rain 3H", value: "\(p)%"))
            }

        }
        .padding(10)
    }

    func update(day: Daily) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.flex.define { flex in

            if let ts = Double(exactly: day.dt) {
                let date = Date(timeIntervalSince1970: ts)
                flex.addItem(viewFor(key: "Time", value: DateFormatter.current.string(from: date)))
            }
            if let p = day.weather?.first?.weatherDescription {
                flex.addItem(viewFor(key: "Description", value: p))
            }
            if let p = day.weather?.first?.main {
                flex.addItem(viewFor(key: "Main", value: p))
            }
            if let dt = day.sunrise, let ts = Double(exactly: dt) {
                let date = Date(timeIntervalSince1970: ts)
                flex.addItem(viewFor(key: "Sunrise", value: DateFormatter.current.string(from: date)))
            }
            if let dt = day.sunset, let ts = Double(exactly: dt) {
                let date = Date(timeIntervalSince1970: ts)
                flex.addItem(viewFor(key: "Sunset", value: DateFormatter.current.string(from: date)))
            }
            if let p = day.temp?.max {
                flex.addItem(viewFor(key: "Max Temperature", value: "\(p)C"))
            }
            if let p = day.temp?.min {
                flex.addItem(viewFor(key: "Min Temperature", value: "\(p)C"))
            }
            if let p = day.temp?.morn {
                flex.addItem(viewFor(key: "Morning Temperature", value: "\(p)C"))
            }
            if let p = day.temp?.day {
                flex.addItem(viewFor(key: "Day Temperature", value: "\(p)C"))
            }
            if let p = day.temp?.eve {
                flex.addItem(viewFor(key: "Evening Temperature", value: "\(p)C"))
            }
            if let p = day.temp?.night {
                flex.addItem(viewFor(key: "Night Temperature", value: "\(p)C"))
            }
            if let p = day.pressure {
                flex.addItem(viewFor(key: "Pressure", value: "\(p)"))
            }
            if let p = day.humidity {
                flex.addItem(viewFor(key: "Humidity", value: "\(p)%"))
            }
            if let p = day.clouds {
                flex.addItem(viewFor(key: "Clouds", value: "\(p)%"))
            }
            if let p = day.windSpeed {
                flex.addItem(viewFor(key: "Wind Speed", value: "\(p) km/h"))
            }
            if let p = day.rain {
                flex.addItem(viewFor(key: "Rain", value: "\(p)%"))
            }

        }
        .padding(10)
    }

}

extension DateFormatter {
    static let current: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
}
