//
//  GoogleMapHelper.swift
//  Elite
//
//  Created by Leandro Wauters on 5/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import GoogleMaps

class GoogleMapHelper {
  
    
    static func getUsersLocations(locationManager: CLLocationManager){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    static func loadAllParkData(completion: @escaping(Data,Data) -> Void){
        if let handballCourtDataFilePath = Bundle.main.path(forResource: "handballCourtInfo", ofType: "json"), let basketballCourtDataFilePath = Bundle.main.path(forResource: "basketballCourtInfo", ofType: "json"){
            let handballCourtDataUrl = URL.init(fileURLWithPath: handballCourtDataFilePath)
            let basketballCourtDataUrl = URL.init(fileURLWithPath: basketballCourtDataFilePath)
            if let jsonHandBallParkData = try? Data.init(contentsOf: handballCourtDataUrl), let jsonBasketBallParkData = try? Data.init(contentsOf: basketballCourtDataUrl){
                completion(jsonHandBallParkData,jsonBasketBallParkData)
            } else {
                print("issue with converting the urls into data")
            }
        } else {
            print("issue with the json file paths")
        }
    }
    static func getBasketBallParksNearMe(_ currentLocation: CLLocation, _ courtLocations: [BasketBall], range: Double) -> [BasketBall]{
        //        loadAllParkData()
        var courtArr = [BasketBall]()
        for court in courtLocations {
            let lat = court.lat ?? "0.0"
            let lng = court.lng ?? "0.0"
            let courtLocation = CLLocation(latitude: CLLocationDegrees(Double(lat)!), longitude: CLLocationDegrees(Double(lng)!))
            let distanceInMeters = courtLocation.distance(from: currentLocation)
            
            if distanceInMeters <= range {
                courtArr.append(court)
            }
            
        }
        return courtArr
    }
    static func getHandBallParksNearMe(_ currentLocation: CLLocation, _ courtLocations: [HandBall], range: Double) -> [HandBall]{
        
        var courtArr = [HandBall]()
        for court in courtLocations {
            let lat = court.lat ?? "0.0"
            let lng = court.lng ?? "0.0"
            let courtLocation = CLLocation(latitude: CLLocationDegrees(Double(lat)!), longitude: CLLocationDegrees(Double(lng)!))
            let distanceInMeters = courtLocation.distance(from: currentLocation)
            if distanceInMeters <= range {
                courtArr.append(court)
            }
        }
        return courtArr
    }
    

    static func getBasketballCourtClosestToUsersLocation(closestToLocation: CLLocation, basketballCourts: [BasketBall]) -> BasketBall? {
        var closestLocation: BasketBall?
        var smallestDistance: CLLocationDistance!
        if basketballCourts.count == 0 {
            return nil
        }
        for basketBallCourt in basketballCourts {
            let location = CLLocation(latitude: (Double(basketBallCourt.lat ?? "0.0"))!, longitude: (Double(basketBallCourt.lng ?? "0.0"))!)
            let distance = location.distance(from: closestToLocation)
            if smallestDistance == nil || distance < smallestDistance {
                closestLocation = basketBallCourt
                smallestDistance = distance
            }
        }

        
        return closestLocation
    }
}
