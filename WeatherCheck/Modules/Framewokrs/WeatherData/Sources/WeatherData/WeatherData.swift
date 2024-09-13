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
    internal static var apiKey = "e286a159a583b9251688d27bebc25783"

    public static func setUpApiKey(_ apiKey: String) {
        Self.apiKey = apiKey
    }

    public static func requestWeather(latitude: Double, longitude: Double, details: Bool = false) async -> HResponseWithResult<WeatherResponseModel> {
        return await WeatherGetRequest(latitude: latitude, longitude: longitude, details: details).request()
    }
}
