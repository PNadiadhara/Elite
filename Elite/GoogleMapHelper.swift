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
        var basketballFileName = String()
        if Flag.isDemo {
            basketballFileName = "parks"
        } else {
            basketballFileName = "basketballCourtInfo"
        }
        if let handballCourtDataFilePath = Bundle.main.path(forResource: "handballCourtInfo", ofType: "json"), let basketballCourtDataFilePath = Bundle.main.path(forResource: basketballFileName, ofType: "json"){
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
    
    static func getHandballCourtClosestToUsersLocation(closestToLocation: CLLocation, handballCourts: [HandBall]) -> HandBall? {
        var closestLocation: HandBall?
        var smallestDistance: CLLocationDistance!
        if handballCourts.count == 0 {
            return nil
        }
        for handBallCourt in handballCourts {
            let location = CLLocation(latitude: (Double(handBallCourt.lat ?? "0.0"))!, longitude: (Double(handBallCourt.lng ?? "0.0"))!)
            let distance = location.distance(from: closestToLocation)
            if smallestDistance == nil || distance < smallestDistance {
                closestLocation = handBallCourt
                smallestDistance = distance
            }
        }
        return closestLocation
    }
    // For the Json Data
//    func setCordinates(_ park: [[String:String]]) {
//        for property in park {
//            if property["lat"] == nil || property["lon"] == nil {
//                if let address = property["Location"] {
//                    GeocodingApiClient.createLocations(userInput: address){(results, appError) in
//                        if let appError = appError {
//                            print(appError.localizedDescription)
//                        }
//                        if let results = results {
//                            for item in results {
//                                property["lat"] = item.geometry.location.lat
//                                property["lon"] = item.geometry.location.lng
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }

}
