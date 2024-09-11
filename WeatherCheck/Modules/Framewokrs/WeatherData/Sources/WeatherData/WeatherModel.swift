//
//  WeatherModel.swift
//  
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation

public struct WeatherResponseModel: Codable {
    public var current: WeatherModel
    public var hourly: [WeatherModel]?
    public var daily: [WeatherDailyModel]?
}

public struct WeatherModel: Codable, Identifiable {
    public let id: String = UUID().uuidString
    public let date: Int
    public let temperature: Double
    public let feelsLike: Double
    public let pressure: Int
    public let humidity: Int
    public let dewPoint: Double
    public let clouds: Int
    public let windSpeed: Double
    public let windDeg: Int
    public let details: [WeatherDetailsModel]

    public enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case dewPoint = "dew_point"
        case clouds = "clouds"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case details = "weather"
    }
}

public struct WeatherDailyModel: Codable, Identifiable {
    public let id: String = UUID().uuidString
    public let date: Int
    public let temperature: TemperatureModel
    public let details: [WeatherDetailsModel]

    public enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case details = "weather"
    }
}

public struct TemperatureModel: Codable {
    public let min: Double
    public let max: Double
}

public struct WeatherDetailsModel: Codable, Identifiable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String

    public var iconUrl: String {
        "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}

