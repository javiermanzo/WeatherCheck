//
//  EmptyStateView.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import UIKit

class EmptyStateView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(title: String, buttonTitle: String, target: Any?, action: Selector) {
        super.init(frame: .zero)
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.addTarget(target, action: action, for: .touchUpInside)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(titleLabel)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),

            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])
    }
}
