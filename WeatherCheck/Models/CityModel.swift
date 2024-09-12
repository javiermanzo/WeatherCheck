//
//  CityModel.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation

struct CityModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let latitud: Double
    let longitud: Double
    let createdAt: Double
    
    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
