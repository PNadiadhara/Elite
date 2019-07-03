//
//  CourtsModel.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 6/28/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class BasketBallData {
    var accessible: String
    var location: String
    var name: String
    var numberOfCourts: String
    var propertyID: String
    var longitude: String
    var latitude: String
    
    init(accessible: String, location: String, name: String, numberOfCourts: String, propertyID: String, longitude: String, latitude: String) {
        self.accessible = accessible
        self.location = location
        self.name = name
        self.numberOfCourts = numberOfCourts
        self.propertyID = propertyID
        self.longitude = longitude
        self.latitude = latitude
    }
    
    // Reading the firebase data
    init(dict: [String: Any]) {
        self.accessible = dict[ParkCollectionKeys.Accessible] as? String ?? "no accessibility"
        self.location = dict[ParkCollectionKeys.Location] as? String ?? "no location"
        self.name = dict[ParkCollectionKeys.Name] as? String ?? "no park name"
        self.numberOfCourts = dict[ParkCollectionKeys.Num_of_Courts] as? String ?? "no courts"
        self.propertyID = dict[ParkCollectionKeys.Prop_ID] as? String ?? "no park id"
        self.longitude = dict[ParkCollectionKeys.Lon] as? String ?? "no lon"
        self.latitude =  dict[ParkCollectionKeys.Lat] as? String ?? "no lat"
    }
    
}

class HandBallData {
    var accessible: String
    var location: String
    var name: String
    var numberOfCourts: String
    var propertyID: String
    var longitude: String
    var latitude: String
    
    init(accessible: String, location: String, name: String, numberOfCourts: String, propertyID: String, longitude: String, latitude: String) {
        self.accessible = accessible
        self.location = location
        self.name = name
        self.numberOfCourts = numberOfCourts
        self.propertyID = propertyID
        self.longitude = longitude
        self.latitude = latitude
    }
    
    // Reading the firebase data
    init(dict: [String: Any]) {
        self.accessible = dict[ParkCollectionKeys.Accessible] as? String ?? "no accessibility"
        self.location = dict[ParkCollectionKeys.Location] as? String ?? "no location"
        self.name = dict[ParkCollectionKeys.Name] as? String ?? "no park name"
        self.numberOfCourts = dict[ParkCollectionKeys.Num_of_Courts] as? String ?? "no courts"
        self.propertyID = dict[ParkCollectionKeys.Prop_ID] as? String ?? "no park id"
        self.longitude = dict[ParkCollectionKeys.Lon] as? String ?? "no lon"
        self.latitude =  dict[ParkCollectionKeys.Lat] as? String ?? "no lat"
    }
}
