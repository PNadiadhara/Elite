//
//  GeocodingClient.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import GooglePlaces

protocol GeocodingDelegate: AnyObject {
    func didGetLatAndLon()
}
final class GeocodingApiClient {
    
    var placesClient: GMSPlacesClient!
    
    static func convertLatLngToAddress(lat: Double, lng: Double,  callBack: @escaping([Results]?,AppError?) -> Void){
        let endPointStr = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&key=\(PrivateInfoFile.GoogleMapsApiKey)"
        // create a url for the endpoint
        guard let url = URL.init(string: endPointStr) else {
            print("bad url: \(endPointStr)")
            return
        }
        let request = URLRequest.init(url: url)
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            if let error = error {
                callBack(nil, AppError.networkError(error))
            }
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                print("Bad Status Code")
                return
            }
            if let data = data {
                do {
                    let geocodingResults = try JSONDecoder().decode(GeocodingData.self, from: data)
                    let results = geocodingResults.results
                    callBack(results, nil)
                } catch {
                    callBack(nil, AppError.jsonDecodingError(error))
                }
            }
        }
        task.resume()
        
    }
    

    static func createLocations(userInput: String,  callBack: @escaping([Results]?,AppError?) -> Void){
        //Creating a edgecase for when there is a space
        let formatteduserInputStr = userInput.replacingOccurrences(of: " ", with: "+")
        //create a constant for the endpoint
        let endPointStr = "https://maps.googleapis.com/maps/api/geocode/json?address=\(formatteduserInputStr)&key=\(PrivateInfoFile.GoogleMapsApiKey)"
        // create a url for the endpoint
        guard let url = URL.init(string: endPointStr) else {
            print("bad url: \(endPointStr)")
            return
        }
        //
        let request = URLRequest.init(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                callBack(nil, AppError.networkError(error))
            }
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                print("Bad Status Code")
                return
            }
            if let data = data {
                do {
                    let geocodingResults = try JSONDecoder().decode(GeocodingData.self, from: data)
                    let results = geocodingResults.results
                    callBack(results, nil)
                } catch {
                    callBack(nil, AppError.jsonDecodingError(error))
                }
            }
        }
        task.resume()
    }
}
