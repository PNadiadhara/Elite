//
//  GeocodingData.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct GeocodingData: Codable {
    let results: [Results]
}
struct Results: Codable {
    let formatted_address: String
    let geometry: GeometryContainer
}
struct GeometryContainer: Codable {
    let location: LocationContainer
}
struct LocationContainer: Codable {
    let lat: Double
    let lng: Double
}
