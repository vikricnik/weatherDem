//
//  LocatioonListView.swift
//  weatherDemo
//
//  Created by dies irae on 02/09/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout
import Combine

class LocatioonListView: UIView {

    let container = UIView()
    let tableView = UITableView(frame: .zero, style: .grouped)
    var resultSearchController = UISearchController()
    let textfield: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.black.cgColor
        tf.placeholder = "Add Location"
        return tf
    }()
    let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return btn
    }()
    let searchBar = UISearchBar(frame: .zero)

    private var cancellables: Set<AnyCancellable> = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        container.flex
            .addItem()
            .justifyContent(.spaceBetween)
            .define { flex in
                flex.addItem(searchBar)
                    .height(10%)
                flex.addItem(tableView)
                    .height(80%)
                flex.addItem()
                    .height(10%)
                    .padding(10)
                    .direction(.row)
                    .define { flex in
                        flex.addItem(textfield)
                            .grow(1)
                        flex.addItem(button)
                            .marginLeft(10)
                }

        }

        addSubview(container)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink() { [unowned self] notification in
                guard self.textfield.isFirstResponder else { return }
                if let keyboardFrame: NSValue = notification
                    .userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                    as? NSValue {

                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    self.container.pin.bottom(keyboardHeight)
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .sink() { [unowned self] _ in
                guard self.textfield.isFirstResponder else { return }
                self.container.pin.bottom(self.pin.safeArea.bottom)
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        container.pin.all(pin.safeArea)
        container.flex.layout()
    }
}
