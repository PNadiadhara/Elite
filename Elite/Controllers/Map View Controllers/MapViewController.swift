//
//  MapViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController {
    private var parks = [ResultsContainer]()
    private var mapView: GMSMapView? {
        didSet{
            DispatchQueue.main.async {
                self.mapView?.reloadInputViews()
            }
        }
    }
    private var localParkResults = [Results]() {
        didSet{
            DispatchQueue.main.async {
                self.mapView?.reloadInputViews()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoogleMarkers()
        mapView?.delegate = self
        
    }
   private func createGoogleMarkers(){
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate 40.712776,-74.005974 at zoom level 6.
    loadParkData()
        let camera = GMSCameraPosition.camera(withLatitude: 40.712776, longitude: -74.005974, zoom: 12.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = self.mapView
        // Creates a marker in the center of the map.
        //let marker = GMSMarker()
        var markers = [GMSMarker]()
    
        for park in parks {
            let locations = CLLocationCoordinate2D(latitude: Double(park.lat ?? "0.0")!, longitude:  Double(park.lng ?? "0.0")!)
            let marker = GMSMarker()
            marker.position = locations
            marker.icon = GMSMarker.markerImage(with: .orange)
            markers.append(marker)
            if markers.count == 30 {
                break
            }
        }
    markers.forEach { (marker) in
           marker.map = mapView
        
        
    }
    
    }
    private func loadParkData(){
                if let filePath = Bundle.main.path(forResource: "JsonModel", ofType: "json"){
                    let myUrl = URL.init(fileURLWithPath: filePath)
                    if let data = try? Data.init(contentsOf: myUrl){
                        do {
                           parks =  try JSONDecoder().decode([ResultsContainer].self, from: data)
        
                            print("number of parks: \(parks.count) ")
                        } catch {
                            print(error)
                        }
                    } else {
                        print("issue with converting the url into data")
                    }
                } else {
                    print("issue with the json file path")
                }
        }
}
extension MapViewController: GMSMapViewDelegate
 {
   
}
