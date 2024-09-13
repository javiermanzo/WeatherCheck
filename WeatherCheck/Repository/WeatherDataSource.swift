//
//  WeatherDataSource.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import Foundation
import Storage

protocol WeatherDataSourceProtocol {
    func saveCities(_ cities: [CityModel])
    func saveOrUpdateCity(_ city: CityModel)
    func fetchSavedCities() -> [CityModel]?
    func deleteSavedCity(_ city: CityModel)
    func clearSavedCities()
}

final class WeatherDataSource: WeatherDataSourceProtocol {
    private let storage = Storage(identifier: "weather-check")

    private enum StorageKeys: String {
        case cities
    }

    func saveCities(_ cities: [CityModel]) {
        storage.add(value: cities, forKey: StorageKeys.cities.rawValue)
    }

    func saveOrUpdateCity(_ city: CityModel) {
        if var cities = fetchSavedCities() {
            if let index = cities.firstIndex(where: { $0.id == city.id }) {
                cities[index] = city
            } else {
                cities.append(city)
            }
            saveCities(cities)
        } else {
            saveCities([city])
        }
    }

    func fetchSavedCities() -> [CityModel]? {
        return storage.value(forKey: StorageKeys.cities.rawValue, type: [CityModel].self)
    }

    func deleteSavedCity(_ city: CityModel) {
        if var cities = fetchSavedCities(),
           let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities.remove(at: index)
            saveCities(cities)
        }
    }

    func clearSavedCities() {
        storage.clear()
    }
}


