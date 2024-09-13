//
//  UINavigationController-extension.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import UIKit

extension UINavigationController {
    func setStyle() {
        self.view.backgroundColor = .systemBackground
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = .systemBackground
        self.navigationBar.barTintColor = .systemBackground
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    }
}
