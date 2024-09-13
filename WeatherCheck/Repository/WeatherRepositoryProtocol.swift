//
//  WeatherRepositoryProtocol.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import Foundation
import Harbor
import WeatherData

protocol WeatherRepositoryProtocol {
    func requestWeather(latitude: Double, longitude: Double, details: Bool) async -> HResponseWithResult<WeatherResponseModel>
    func fetchSavedCities() -> [CityModel]
}
