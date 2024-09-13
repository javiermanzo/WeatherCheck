//
//  WeatherRepository.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation
import Harbor
import WeatherData

struct WeatherRepository: WeatherRepositoryProtocol {

    private let dataSource = WeatherDataSource()

    func requestWeather(latitude: Double, longitude: Double, details: Bool = false) async -> HResponseWithResult<WeatherResponseModel> {
        return await WeatherData.requestWeather(latitude: latitude, longitude: longitude, details: details)
    }

    func fetchSavedCities() -> [CityModel] {
        return dataSource.fetchSavedCities() ?? []
    }

    func saveCities(_ cities: [CityModel]) {
        dataSource.saveCities(cities)
    }

    func saveOrUpdateCity(_ city: CityModel) {
        dataSource.saveOrUpdateCity(city)
    }

    func deleteSavedCity(_ city: CityModel) {
        dataSource.deleteSavedCity(city)
    }

    func clearSavedCities() {
        dataSource.clearSavedCities()
    }
}

