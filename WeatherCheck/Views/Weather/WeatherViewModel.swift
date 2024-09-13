//
//  WeatherViewModel.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import Foundation

protocol WeatherViewModelDelegate: AnyObject {
    func reloadTableView()
}

final class WeatherViewModel {
    weak var delegate: WeatherViewModelDelegate?
    private let repository: WeatherRepositoryProtocol
    var city: CityModel

    init(city: CityModel, repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.city = city
        self.repository = repository

        requestWeather()
    }

    func requestWeather() {
        Task {
            let response = await repository.requestWeather(latitude: city.latitude, longitude: city.longitude, details: true)

            switch response {
            case .success(let weather):
                let updatedCity = CityModel(id: city.id, name: city.name, latitude: city.latitude, longitude: city.longitude, createdAt: city.createdAt, weather: weather)

                city = updatedCity

                await MainActor.run {
                    delegate?.reloadTableView()
                }
            case .cancelled:
                break
            case  .error(let error):
                print(error)
            }
        }
    }
}
