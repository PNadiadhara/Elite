//
//  GeolocationData.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct GeolocationData: Codable {
    let location: CurrentLocationContainer
}
struct CurrentLocationContainer: Codable {
    let lat: Double
    let lng: Double
}
