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
    func requestWeather(latitud: Double, longitud: Double, details: Bool) async -> HResponseWithResult<WeatherResponseModel>
    func getCities() -> [CityModel]
}

struct WeatherRepository: WeatherRepositoryProtocol {
    func requestWeather(latitud: Double, longitud: Double, details: Bool = false) async -> HResponseWithResult<WeatherResponseModel> {
        return await WeatherData.requestWeather(latitud: latitud, longitud: longitud, details: details)
    }

    func getCities() -> [CityModel] {
        return [
            CityModel(id: "1", name: "Buenos Aires", latitud: -34.6037, longitud: -58.3816, createdAt: Date().timeIntervalSince1970),
            CityModel(id: "1", name: "Buenos Aires", latitud: -34.6037, longitud: -58.3816, createdAt: Date().timeIntervalSince1970),
            CityModel(id: "2", name: "Bogotá", latitud: 4.7110, longitud: -74.0721, createdAt: Date().timeIntervalSince1970),
            CityModel(id: "3", name: "Ciudad de México", latitud: 19.4326, longitud: -99.1332, createdAt: Date().timeIntervalSince1970)
        ]
    }

}

