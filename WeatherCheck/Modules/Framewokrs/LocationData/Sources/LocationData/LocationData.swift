//
//  LocationData.swift
//
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation
import CoreLocation

public final class LocationData {

    public static let shared: LocationData = LocationData()

    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        return manager
    }()

    private var locationDelegate: LocationDelegate?

    private init() { }

    public func getLocationData(latitude: Double, longitude: Double) async throws -> LocationModel {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        if let placemarks = try? await geocoder.reverseGeocodeLocation(location),
           let placemark = placemarks.first,
           let id = generateId(placemark: placemark) {
            return LocationModel(id: id, name: placemark.locality, latitude: latitude, longitude: longitude)
        } else {
            throw LocationError.noLocationAvailable
        }
    }

    private func generateId(placemark: CLPlacemark) -> String? {
        let city = placemark.locality ?? ""
        let administrativeArea = placemark.administrativeArea ?? ""
        let country = placemark.country ?? ""

        let combinedString = "\(city)\(administrativeArea)\(country)"

        return !combinedString.isEmpty ? combinedString : nil
    }

    public func checkLocationAuthorizationStatus(requestIfPending: Bool = true) async -> CLAuthorizationStatus {
        let manager = CLLocationManager()
        var status = manager.authorizationStatus

        if requestIfPending, status == .notDetermined {
            return await withCheckedContinuation { continuation in
                manager.requestWhenInUseAuthorization()
                status = manager.authorizationStatus
                continuation.resume(returning: status)
            }
        }

        return status
    }

    
    public func requestCurrentLocation() async throws -> LocationModel {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationError.servicesDisabled
        }

        return try await withCheckedThrowingContinuation { continuation in
            locationDelegate = LocationDelegate { locations, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let location = locations.first {
                    Task {
                        do {
                            let locationData = try await self.getLocationData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            continuation.resume(returning: locationData)
                        } catch {
                            continuation.resume(throwing: LocationError.noLocationAvailable)
                        }
                    }
                } else {
                    continuation.resume(throwing: LocationError.noLocationAvailable)
                }
                self.locationDelegate = nil
            }

            locationManager.delegate = locationDelegate
            locationManager.requestLocation()
        }
    }
}
