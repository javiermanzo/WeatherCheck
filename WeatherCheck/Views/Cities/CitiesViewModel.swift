//
//  CitiesViewModel.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation
import LocationData

protocol CitiesViewModelDelegate: AnyObject {
    func reloadTableView()
}

final class CitiesViewModel {
    weak var delegate: CitiesViewModelDelegate?
    private let repository: WeatherRepositoryProtocol
    var currentCity: CityModel?
    private var cities: Set<CityModel> = []

    var sortedCities: [CityModel] {
        Array(cities).sorted(by: { $0.createdAt < $1.createdAt })
    }

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
        cities = Set(repository.getCities())
    }

    func getCurrentCity() {
        Task { @MainActor in
            let status = await LocationData.shared.checkLocationAuthorizationStatus()

            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                do {
                    let location = try await LocationData.shared.requestCurrentLocation()

                    if let cityName = location.name {
                        await MainActor.run {
                            currentCity = CityModel(id: location.id, name: cityName, latitud: location.latitude, longitud: location.longitude, createdAt: Date().timeIntervalSince1970)
                            delegate?.reloadTableView()
                        }
                    }
                } catch {
                    print(error)
                }
            default:
                break
            }
        }
    }
}

// MARK: - CitiesViewModelDelegate
extension CitiesViewModel: AddCityDelegate {
    func didAddCity(_ city: CityModel) {
        cities.insert(city)
        delegate?.reloadTableView()
    }
}
