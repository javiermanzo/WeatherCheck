//
//  CityModel.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation
import WeatherData

struct CityModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let createdAt: Double
    var weather: WeatherResponseModel?

    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
