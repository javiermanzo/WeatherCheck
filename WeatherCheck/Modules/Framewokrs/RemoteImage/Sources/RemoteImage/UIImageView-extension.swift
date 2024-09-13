//
//  UIImageView-extension.swift
//  
//
//  Created by Javier Manzo on 12/09/2024.
//

import UIKit

public extension UIImageView {
    func setImage(from url: URL, placeholder: UIImage? = nil) async {
        self.image = placeholder

        do {
            let image = try await ImageLoader.shared.loadImage(from: url)

            await MainActor.run {
                self.image = image
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
