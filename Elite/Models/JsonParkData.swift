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

struct JsonHandballCourtInfo: Codable {
    let results: [HandBall]
}
struct HandBall: Codable, Court {
    var type: SportType = .handball
    let propertyID: String?
    let playgroundID: String?
    let nameOfPlayground: String?
    let location: String?
    let numberOfCourts: String?
    let accessible: String?
    let lat: String?
    let lng: String?
    enum CodingKeys: String,CodingKey {
        case propertyID = "Prop_ID"
        case playgroundID = "Playground_ID"
        case nameOfPlayground = "Name"
        case location = "Location"
        case numberOfCourts = "Num_of_Courts"
        case accessible = "Accessible"
        case lat =  "lat"
        case lng = "lon"
    }
}

struct JsonBasketBallCourtInfo: Codable {
    let results: [BasketBall]
}
struct BasketBall: Codable, Court {
    var type: SportType = .basketball
    let propertyID: String?
    let playgroundID: String?
    let nameOfPlayground: String?
    let location: String?
    let numberOfCourts: String?
    let accessible: String?
    var lat: String?
    var lng: String?
    enum CodingKeys: String,CodingKey {
        case propertyID = "Prop_ID"
        case playgroundID = "Playground_ID"
        case nameOfPlayground = "Name"
        case location = "Location"
        case numberOfCourts = "Num_of_Courts"
        case accessible = "Accessible"
        case lat =  "lat"
        case lng = "lon"
    }
}

enum SportType {
    case basketball, handball
}

protocol Court {
    var type: SportType { get }
    var propertyID: String? { get }
    var playgroundID: String? { get }
    var nameOfPlayground: String? { get }
    var location: String? { get }
    var numberOfCourts: String? { get }
    var accessible: String? { get }
    var lat: String? { get }
    var lng: String? { get }
}
