//
//  AllNYCParkInfo.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/12/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct AllBasketballCourtInfo: Codable {
    let results: [BasketBallResultsContainer]
    
}
struct BasketBallResultsContainer: Codable {
    let propertyID: String?
//    let playgroundID: String?
    let nameOfPlayground: String?
    let basketBallCourtLocation: String?
    let numberOfBasketBallCourts: String?
    let accessible: String?
    let lat: String?
    let lng: String?
    enum CodingKeys: String,CodingKey {
        case propertyID = "Prop_ID"
//        case playgroundID = "Playground_ID"
        case nameOfPlayground = "Name"
        case basketBallCourtLocation = "Location"
        case numberOfBasketBallCourts = "Num_of_Courts"
        case accessible = "Accessible"
        case lat =  "lat"
        case lng = "lon"
    }
}
struct AllHandballCourtInfo: Codable {
    let results: [HandBallResultsContainer]
}
struct HandBallResultsContainer: Codable {
    let propertyID: String?
//    let playgroundID: String?
    let nameOfPlayground: String?
    let handBallCourtLocation: String?
    let numberOfHandBallCourts: String?
    let accessible: String?
    let lat: String?
    let lng: String?
    enum CodingKeys: String,CodingKey {
        case propertyID = "Prop_ID"
//        case playgroundID = "Playground_ID"
        case nameOfPlayground = "Name"
        case handBallCourtLocation = "Location"
        case numberOfHandBallCourts = "Num_of_Courts"
        case accessible = "Accessible"
        case lat =  "lat"
        case lng = "lon"
    }
}
