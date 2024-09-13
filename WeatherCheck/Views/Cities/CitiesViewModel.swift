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
    }

    func getSavedCities() {
        cities = Set(repository.getCities())

        delegate?.reloadTableView()

        for city in cities {
            requestWeather(city: city)
        }
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
                            let city = CityModel(id: location.id, name: cityName, latitude: location.latitude, longitude: location.longitude, createdAt: Date().timeIntervalSince1970)
                            
                            requestWeather(city: city)
                            
                            currentCity = city
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

    func requestWeather(city: CityModel) {
        Task {
            let response = await repository.requestWeather(latitude: city.latitude, longitude: city.longitude, details: false)

            switch response {
            case .success(let weather):
                let updatedCity = CityModel(id: city.id, name: city.name, latitude: city.latitude, longitude: city.longitude, createdAt: city.createdAt, weather: weather)
                cities.insert(updatedCity)

                await MainActor.run {
                    delegate?.reloadTableView
                }
            case .cancelled:
                break
            case  .error(let error):
                print(error)
            }
        }
    }
}

// MARK: - CitiesViewModelDelegate
extension CitiesViewModel: AddCityDelegate {
    func didAddCity(_ city: CityModel) {
        cities.insert(city)
        delegate?.reloadTableView()
        
        requestWeather(city: city)
    }
}
