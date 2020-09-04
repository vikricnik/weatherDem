//
//  LocationListViewController.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import Combine
import CoreLocation

class LocatioonListViewController: UIViewController {

    lazy var viewModel: LocatioonListViewModel = {
        return LocatioonListViewModel(router: self)
    }()

    private var currentPlacemark: CLPlacemark?
    private var locations = ["London", "Paris", "Berlin"]
    private var recentMapLocations: Set<CLPlacemark> = []
    private var cancellables: Set<AnyCancellable> = []
    private var searchIsActive: Bool {
        listView?.searchBar.searchTextField.text != "" &&
        listView?.searchBar.searchTextField.text != nil &&
        listView?.searchBar.searchTextField.text != " "
    }
    private var searchItems: [Searchable] = [Searchable]()

    var listView: LocatioonListView? {
        return view as? LocatioonListView
    }

    var recentMapLocation: ((CLPlacemark) -> Void)?

    override func loadView() {
        view = LocatioonListView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        listView?.searchBar.autocapitalizationType = .none
        listView?.searchBar.delegate = self // Monitor when the search button is tapped.
        recentMapLocation = { [weak self] pm in
            self?.recentMapLocations.insert(pm)
            self?.listView?.tableView.reloadData()
        }

        viewModel.$currentPlacemark
            .sink() { [weak self] place in
                if self?.currentPlacemark != place {
                    self?.currentPlacemark = place
                    self?.listView?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    @objc func didTapCTAButton() {
        listView?.textfield.resignFirstResponder()
        if let location = listView?.textfield.text, location != "" {
            locations.append(location)
        }
        listView?.textfield.text = nil
        listView?.tableView.reloadData()
    }

    // MARK: = Private
    func setupView() {
        listView?.tableView.delegate = self
        listView?.tableView.dataSource = self
        listView?.tableView.estimatedRowHeight = 100
        listView?.tableView.estimatedSectionHeaderHeight = 50
        listView?.tableView.tableHeaderView = UIView(frame: .zero)
        listView?.tableView.tableFooterView = UIView(frame: .zero)
        listView?.button.addTarget(self, action: #selector(didTapCTAButton), for: .touchUpInside)
        listView?.textfield.delegate = self
        listView?.button.flex.display(.none)
    }
}

extension LocatioonListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapCTAButton()
        return false
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        listView?.button.flex.display(.flex)
        self.listView?.layoutSubviews()

        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        listView?.button.flex.display(.none)
        self.listView?.layoutSubviews()

        return true
    }

}

extension LocatioonListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems.removeAll()
        if currentPlacemark?.searchParameter.lowercased().contains(searchText.lowercased()) == true {
            searchItems.append(currentPlacemark!)
        }
        searchItems.append(
            contentsOf: locations.filter({
                $0.lowercased().contains(searchText.lowercased())
            }))
        searchItems.append(
            contentsOf: recentMapLocations
                .filter({
                    $0.searchParameter
                    .lowercased()
                    .contains(searchText.lowercased())
                })
        )
        listView?.tableView.reloadData()
    }
}

extension LocatioonListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !searchIsActive else { return searchItems.count }
        if section == 0 {
            return currentPlacemark == nil ? 0 : 1
        } else if section == 1 {
            return locations.count
        } else if section == 2 {
            return recentMapLocations.count
        } else {
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard !searchIsActive else { return 1 }
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = c
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.accessoryType = .disclosureIndicator

        guard !searchIsActive else {
            cell.textLabel?.text = searchItems[indexPath.row].searchParameter
            return
        }

        if indexPath.section == 0 {
            cell.textLabel?.text = currentPlacemark?.locality
        } else if indexPath.section == 1 {
            cell.textLabel?.text = locations[indexPath.row]
        } else if indexPath.section == 2 {
            cell.textLabel?.text = recentMapLocations.map({ $0 })[indexPath.row].locality
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard !searchIsActive else {
            return "Search Results"
        }

        if currentPlacemark != nil && section == 0 {
            return "Current Location"
        } else if section == 1 && locations.count != 0 {
            return "Custom Locations"
        } else if section == 2 && recentMapLocations.count != 0 {
            return  "Recent Map Locations"
        }

        return nil

    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 1 {
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        if editingStyle == .delete && indexPath.section == 2 {
            recentMapLocations.remove(recentMapLocations.map({ $0 })[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard !searchIsActive else {
            return .none
        }

        return indexPath.section == 0 ? .none : .delete
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !searchIsActive else {
            if let pm = searchItems[indexPath.row] as? CLPlacemark {
                viewModel.didTapCurrentLocation(placemark: pm)
            } else if let str = searchItems[indexPath.row] as? String {
                viewModel.didSelectCity(city: str)
            }
            return
        }
        if indexPath.section == 0, let placemark = currentPlacemark {
            viewModel.didTapCurrentLocation(placemark: placemark)
        } else if indexPath.section == 1 {
            viewModel.didSelectCity(city: locations[indexPath.row])
        } else if indexPath.section == 2 {
            viewModel.didTapCurrentLocation(placemark: recentMapLocations.map({ $0 })[indexPath.row])
        }
    }
}

protocol Searchable {
    var searchParameter: String { get }
}

extension CLPlacemark: Searchable {
    var searchParameter: String {
        self.locality ?? subLocality ?? name ?? ""
    }
}

extension String: Searchable {
    var searchParameter: String {
        self
    }
}
