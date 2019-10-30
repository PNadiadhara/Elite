//
//  GooglePlacesClient.swift
//  Elite
//
//  Created by Leandro Wauters on 10/23/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import GooglePlaces

//protocol GooglePlacesDelegate: AnyObject {
//
//}
class GooglePlacesClient {
    
    static func fetchLatAndLon(from name: String, completion: @escaping(Result< Double, AppError>?, Result<Double, AppError>?) -> Void) {

        let escapedString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let endPoint = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(escapedString ?? name)&inputtype=textquery&fields=geometry&key=\(PrivateInfoFile.GoogleMapsApiKey)"
        guard let url = URL.init(string: endPoint) else {
            completion(.failure(AppError.badURL("Bad URL")), .failure(AppError.badURL("Bad URL")))
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(AppError.networkError(error)), .failure(AppError.networkError(error)))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(GooglePlaceResult.self, from: data)
                    completion(.success((result.candidates.first?.geometry.location.lat)!), .success((result.candidates.first?.geometry.location.lng)!))
                } catch {
                    completion(.failure(AppError.jsonDecodingError(error)), .failure(AppError.jsonDecodingError(error)))
                }
            }
        }
        task.resume()
    }
}
