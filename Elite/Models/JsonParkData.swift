//
//  JsonParkData.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct JsonParkData: Codable {
    let results: [ResultsContainer]
}
struct ResultsContainer: Codable {
    let propertyID: String?
    let playgroundID: String?
    let schoolID: String?
    let status: String?
    let name: String?
    let streetLocation: String?
    let accessible: String?
    let accessibleLevel: String?
    let adaptiveSwing: String?
    let lat: String?
    let lng: String?
    enum CodingKeys: String,CodingKey {
        case propertyID = "Prop_ID"
        case playgroundID = "Playground_ID"
        case schoolID = "School_ID"
        case status = "Status"
        case name = "Name"
        case streetLocation = "Location"
        case accessible = "Accessible" // Accessible For this who are disabled
        case accessibleLevel = "Level"
        case adaptiveSwing = "Adaptive_Swing"
        case lat =  "lat"
        case lng = "lon"
    }
}
