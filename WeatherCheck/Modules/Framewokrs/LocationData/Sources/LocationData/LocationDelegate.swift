//
//  LocationDelegate.swift
//
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation
import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    private let onUpdate: ([CLLocation], Error?) -> Void

    init(onUpdate: @escaping ([CLLocation], Error?) -> Void) {
        self.onUpdate = onUpdate
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onUpdate(locations, nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onUpdate([], error)
    }
}
