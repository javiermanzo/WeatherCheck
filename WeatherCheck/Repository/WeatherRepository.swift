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
    func requestWeather(latitude: Double, longitude: Double, details: Bool = false) async -> HResponseWithResult<WeatherResponseModel> {
        return await WeatherData.requestWeather(latitude: latitude, longitude: longitude, details: details)
    }

    func fetchSavedCities() -> [CityModel] {
        return []
    }

}

