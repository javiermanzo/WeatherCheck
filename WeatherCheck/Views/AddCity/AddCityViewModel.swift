//
//  AddCityViewModel.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation
import MapKit
import LocationData

protocol AddCityDelegate: AnyObject {
    func didAddCity(_ city: CityModel)
}

final class AddCityViewModel {

    private weak var delegate: AddCityDelegate?
    var lastLocation: LocationModel?

    init(delegate: AddCityDelegate? = nil) {
        self.delegate = delegate
    }

    @MainActor
    func getCurrentLocation() async -> LocationModel? {
        if await checkLocationEnabled() {
            do {
                let location = try await LocationData.shared.requestCurrentLocation()
                return location
            } catch {
                print(error)
            }
        }

        return nil
    }

    @MainActor
    func checkLocationEnabled() async -> Bool {
        let status = await LocationData.shared.checkLocationAuthorizationStatus()

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            return false
        }
    }

    func getLocationData(coordinate: CLLocationCoordinate2D) async -> LocationModel? {
        do {
            let location = try await LocationData.shared.getLocationData(latitude: coordinate.latitude, longitude: coordinate.longitude)
            lastLocation = location
            return location
        } catch {
            print(error)
        }

        return nil
    }

    func addCity() -> Bool {
        if let lastLocation,
           let cityName = lastLocation.name {
            let city = CityModel(id: lastLocation.id, name: cityName, latitude: lastLocation.latitude, longitude: lastLocation.longitude, createdAt: Date().timeIntervalSince1970)
            delegate?.didAddCity(city)
            return true
        }

        return false
    }
}
