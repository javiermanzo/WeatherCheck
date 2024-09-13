//
//  WeatherGetRequest.swift
//  
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation
import Harbor

struct WeatherGetRequest: HGetRequestProtocol {
    typealias Model = WeatherResponseModel
    let url: String = "\(WeatherData.baseUrl)/data/3.0/onecall"
    var headerParameters: [String: String]?
    var queryParameters: [String: String]?
    let pathParameters: [String: String]? = nil
    let needsAuth: Bool = false
    var retries: Int? = nil
    let timeout: TimeInterval = 15

    init(latitude: Double, longitude: Double, details: Bool = false) {
        queryParameters = [
            "lat": "\(latitude)",
            "lon": "\(longitude)",
            "units": "metric",
        ]

        if !details {
            queryParameters?["exclude"] = "minutely,hourly,daily"
        }

        queryParameters?["appid"] = WeatherData.apiKey
    }
}

