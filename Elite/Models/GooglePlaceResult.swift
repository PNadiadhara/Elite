//
//  GooglePlaceResult.swift
//  Elite
//
//  Created by Leandro Wauters on 10/23/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct GooglePlaceResult: Codable {
    let candidates: [Candidate]
    let status: String
}

// MARK: - Candidate
struct Candidate: Codable {
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location

}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: - Viewport








