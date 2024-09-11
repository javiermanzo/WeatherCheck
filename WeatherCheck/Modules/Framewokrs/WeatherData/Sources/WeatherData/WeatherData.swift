//
//  WeatherData.swift
//
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation
import Harbor

public final class WeatherData {

    internal static let baseUrl = "https://api.openweathermap.org"
    internal static var apiKey = ""

    public static func setUpApiKey(_ apiKey: String) {
        Self.apiKey = apiKey
    }

    public static func requestWeather(latitud: Double, longitud: Double, details: Bool = false) async -> HResponseWithResult<WeatherResponseModel> {
        return await WeatherGetRequest(latitud: latitud, longitud: longitud, details: details).request()
    }
}
