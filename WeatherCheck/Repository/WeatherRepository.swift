//
//  WeatherRepository.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation
import Harbor
import WeatherData


protocol WeatherRepositoryProtocol {
    func requestWeather(latitude: Double, longitude: Double, details: Bool) async -> HResponseWithResult<WeatherResponseModel>
    func getCities() -> [CityModel]
}

struct WeatherRepository: WeatherRepositoryProtocol {
    func requestWeather(latitude: Double, longitude: Double, details: Bool = false) async -> HResponseWithResult<WeatherResponseModel> {
        return await WeatherData.requestWeather(latitude: latitude, longitude: longitude, details: details)
    }

    func getCities() -> [CityModel] {
        return [
            CityModel(id: "1", name: "Buenos Aires", latitude: -34.6037, longitude: -58.3816, createdAt: Date().timeIntervalSince1970),
            CityModel(id: "2", name: "Bogotá", latitude: 4.7110, longitude: -74.0721, createdAt: Date().timeIntervalSince1970),
            CityModel(id: "3", name: "Ciudad de México", latitude: 19.4326, longitude: -99.1332, createdAt: Date().timeIntervalSince1970)
        ]
    }

}

