//
//  CitiesViewModel.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation
import LocationData
import WeatherData

protocol CitiesViewModelDelegate: AnyObject {
    func reloadTableView()
}

final class CitiesViewModel {
    weak var delegate: CitiesViewModelDelegate?
    private let repository: WeatherRepositoryProtocol
    var currentCity: CityModel?
    private var cities: [CityModel] = []

    var sortedCities: [CityModel] {
        Array(cities).sorted(by: { $0.createdAt < $1.createdAt })
    }

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func fetchData() {
        getCurrentCity()
        fetchSavedCities()
    }

    func updateCitiesWeather() {
        requestWeatherAndUpdateCurrentCity()

        for city in cities {
            requestWeatherAndUpdateCity(city)
        }
    }

    private func fetchSavedCities() {
        cities = repository.fetchSavedCities()

        delegate?.reloadTableView()

        for city in cities {
            requestWeatherAndUpdateCity(city)
        }
    }

    private func getCurrentCity() {
        Task { @MainActor in
            let status = await LocationData.shared.checkLocationAuthorizationStatus()

            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                do {
                    let location = try await LocationData.shared.requestCurrentLocation()

                    if let cityName = location.name {
                        let city = CityModel(id: location.id, name: cityName, latitude: location.latitude, longitude: location.longitude, createdAt: Date().timeIntervalSince1970)

                        await MainActor.run {
                            currentCity = city
                            delegate?.reloadTableView()
                        }

                        requestWeatherAndUpdateCurrentCity()
                    }
                } catch {
                    print(error)
                }
            default:
                break
            }
        }
    }

    func requestWeatherAndUpdateCurrentCity() {
        Task {
            if let currentCity = self.currentCity,
               let weather = await requestWeather(city: currentCity) {
                let updatedCurrentCity = updateCity(currentCity, weather: weather)
                self.currentCity = updatedCurrentCity
                await MainActor.run {
                    delegate?.reloadTableView()
                }
            }
        }
    }

    func requestWeatherAndUpdateCity(_ city: CityModel) {
        Task {
            if let weather = await requestWeather(city: city) {
                let updatedCity = updateCity(city, weather: weather)
                await MainActor.run {
                    replaceOrAddCity(updatedCity)
                    repository.saveOrUpdateCity(updatedCity)
                    delegate?.reloadTableView()
                }
            }
        }
    }

    private func requestWeather(city: CityModel) async -> WeatherResponseModel? {
        let response = await repository.requestWeather(latitude: city.latitude, longitude: city.longitude, details: false)

        switch response {
        case .success(let weather):
            return weather
        case .cancelled:
            return nil
        case  .error(let error):
            print(error)
            return nil
        }
    }

    private func updateCity(_ city: CityModel, weather: WeatherResponseModel) -> CityModel {
        let updatedCity = CityModel(id: city.id, name: city.name, latitude: city.latitude, longitude: city.longitude, createdAt: city.createdAt, weather: weather)
        return updatedCity
    }

    private func replaceOrAddCity(_ city: CityModel) {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index] = city
        } else {
            cities.append(city)
        }
    }
}

// MARK: - CitiesViewModelDelegate
extension CitiesViewModel: AddCityDelegate {
    func didAddCity(_ city: CityModel) {
        replaceOrAddCity(city)
        delegate?.reloadTableView()

        repository.saveOrUpdateCity(city)
        requestWeatherAndUpdateCity(city)
    }
}
