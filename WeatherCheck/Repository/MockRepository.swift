//
//  MockRepository.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import Foundation
import Harbor
import WeatherData

struct MockRepository: WeatherRepositoryProtocol {
    func requestWeather(latitude: Double, longitude: Double, details: Bool) async -> HResponseWithResult<WeatherResponseModel> {
        let weather =  WeatherResponseModel(
            current: WeatherModel(
                date: Int(Date().timeIntervalSince1970),
                temperature: 26.0,
                feelsLike: 27.0,
                pressure: 1015,
                humidity: 70,
                dewPoint: 18.5,
                clouds: 20,
                windSpeed: 5.5,
                windDeg: 180,
                details: [
                    WeatherDetailsModel(
                        id: 800,
                        main: "Clear",
                        description: "clear sky",
                        icon: "01d"
                    )
                ]
            ),
            hourly: [
                WeatherModel(
                    date: Int(Date().timeIntervalSince1970 + 3600),
                    temperature: 24.5,
                    feelsLike: 25.0,
                    pressure: 1014,
                    humidity: 65,
                    dewPoint: 17.0,
                    clouds: 15,
                    windSpeed: 4.5,
                    windDeg: 170,
                    details: [
                        WeatherDetailsModel(
                            id: 801,
                            main: "Clouds",
                            description: "few clouds",
                            icon: "02d"
                        )
                    ]
                ),
                WeatherModel(
                    date: Int(Date().timeIntervalSince1970 + 7200),
                    temperature: 23.0,
                    feelsLike: 23.5,
                    pressure: 1013,
                    humidity: 60,
                    dewPoint: 16.5,
                    clouds: 10,
                    windSpeed: 4.0,
                    windDeg: 160,
                    details: [
                        WeatherDetailsModel(
                            id: 800,
                            main: "Clear",
                            description: "clear sky",
                            icon: "01d"
                        )
                    ]
                )
            ],
            daily: [
                WeatherDailyModel(
                    date: Int(Date().timeIntervalSince1970 + 86400),
                    temperature: TemperatureModel(min: 18.0, max: 28.0),
                    details: [
                        WeatherDetailsModel(
                            id: 800,
                            main: "Clear",
                            description: "clear sky",
                            icon: "01d"
                        )
                    ]
                ),
                WeatherDailyModel(
                    date: Int(Date().timeIntervalSince1970 + 172800),
                    temperature: TemperatureModel(min: 17.0, max: 27.0),
                    details: [
                        WeatherDetailsModel(
                            id: 801,
                            main: "Clouds",
                            description: "few clouds",
                            icon: "02d"
                        )
                    ]
                )
            ]
        )

        return .success(weather)
    }

    func fetchSavedCities() -> [CityModel] {
        
        let currentDate = Date().timeIntervalSince1970
        let oneDayInSeconds: TimeInterval = 86400

        return [
            CityModel(id: "1", name: "Buenos Aires", latitude: -34.6037, longitude: -58.3816, createdAt: currentDate - (2 * oneDayInSeconds)),
            CityModel(id: "2", name: "Bogotá", latitude: 4.7110, longitude: -74.0721, createdAt: currentDate - oneDayInSeconds),
            CityModel(id: "3", name: "Ciudad de México", latitude: 19.4326, longitude: -99.1332, createdAt: currentDate)
        ]
    }


}
