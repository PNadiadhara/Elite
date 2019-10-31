//
//  GoogleMapHelper.swift
//  Elite
//
//  Created by Leandro Wauters on 5/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import GoogleMaps

protocol FetchDataDelegate: AnyObject {
    func didLoadData(basketballCourts: [BasketBall] , handballCourts: [HandBall])
    func errorLoadingData(error: AppError)
}

class GoogleMapHelper {
  
    weak var delegate: FetchDataDelegate?
    

    public func setupMapViewSettings(mapView: GMSMapView ){
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true

    }
    
    public func clearMarkers(mapView: GMSMapView){
        mapView.clear()
    }
    
    public func addMarkers(courts: [Court], type: SportType, mapView: GMSMapView) {
        var googleMarkers = [GMSMarker]()
        
        let filteredCourts = courts.filter { $0.type == type}
        print("Number of courts: ",filteredCourts.count)
        for court in filteredCourts {
            let locations = CLLocationCoordinate2D(latitude: Double(court.lat ?? "0.0")!, longitude:  Double(court.lng ?? "0.0")!)
            let marker = GMSMarker()
            marker.title = court.nameOfPlayground ?? "No name"
            marker.snippet = court.location ?? "No location"
            marker.position = locations
            GameModel.formattedAddress = marker.snippet
            switch court.type {
            case .basketball:
                marker.icon = GMSMarker.markerImage(with: .orange)
            case .handball:
                marker.icon = GMSMarker.markerImage(with: .eliteBlue)
                //marker.iconView = UIImage.init(named: "eliteMarker")
            }
            googleMarkers.append(marker)
        }
        googleMarkers.forEach { (marker) in
            marker.map = mapView
        }
    }
    public func loadAllParkData(){
        var basketballFileName = String()
        var basketBallCourts = [BasketBall]()
        var handBallCourts = [HandBall]()
        if Flag.isDemo {
            basketballFileName = "parks"
        } else {
            basketballFileName = "basketballCourtInfo"
        }
        guard let basketballCourtDataFilePath = Bundle.main.path(forResource: "basketballCourtInfo", ofType: "json"),
            let handballCourtDataFilePath = Bundle.main.path(forResource: "handballCourtInfo", ofType: "json") else {
                delegate?.errorLoadingData(error:  AppError.noFilesFound("No files found"))
                return
        }
        let handballCourtDataUrl = URL.init(fileURLWithPath: handballCourtDataFilePath)
        let basketballCourtDataUrl = URL.init(fileURLWithPath: basketballCourtDataFilePath)
        guard let basketballParkData = try? Data.init(contentsOf: basketballCourtDataUrl), let handballParkData = try? Data.init(contentsOf: handballCourtDataUrl) else {
            delegate?.errorLoadingData(error: AppError.noData("Error converting data"))
            return}
                    do {
                        handBallCourts = try JSONDecoder().decode([HandBall].self, from: handballParkData)
                        basketBallCourts = try JSONDecoder().decode([BasketBall].self, from: basketballParkData)
                        delegate?.didLoadData(basketballCourts: basketBallCourts, handballCourts: handBallCourts)
                    } catch {

                        delegate?.errorLoadingData(error: AppError.jsonDecodingError(error))
                    }
    }
    public func getBasketBallParksNearMe(_ currentLocation: CLLocation, _ courtLocations: [BasketBall], range: Double) -> [BasketBall]{
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
    public func getHandBallParksNearMe(_ currentLocation: CLLocation, _ courtLocations: [HandBall], range: Double) -> [HandBall]{
        
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
