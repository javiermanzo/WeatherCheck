//
//  LocationModel.swift
//
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation

public struct LocationModel: Codable, Identifiable {
    public let id: String
    public let name: String?
    public let latitude: Double
    public let longitude: Double
}
