//
//  LocationDelegate.swift
//
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation
import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    private var onUpdateLocation: (([CLLocation], Error?) -> Void)?
    private var onUpdateStatus: ((CLAuthorizationStatus) -> Void)?

    init(onUpdateLocation: @escaping ([CLLocation], Error?) -> Void) {
        self.onUpdateLocation = onUpdateLocation
    }

    init(onUpdateStatus: @escaping ((CLAuthorizationStatus) -> Void)) {
        self.onUpdateStatus = onUpdateStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onUpdateLocation?(locations, nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onUpdateLocation?([], error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onUpdateStatus?(status)
    }
}
