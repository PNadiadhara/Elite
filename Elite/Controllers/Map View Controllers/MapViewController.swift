//
//  MapViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import GoogleMaps

enum GoogleMapsMVState {
    case showHandBallMarkers
    case showBasketBallMarkers
    case noMarkersShown
}

class MapViewController: UIViewController {
    // MARK: - Outlets and Properties
    @IBOutlet weak var googleMapsMapView: GMSMapView!
    
    private var googleMapsMVEditingState = GoogleMapsMVState.noMarkersShown
    
    private var locationManager = CLLocationManager()
    
    private var userLocation = CLLocation()
    
    private var handballResults = [HandBall]()
    
    private var basketballResults = [BasketBall]()
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersLocations()
    }
    
    private func getUsersLocations(){
        
    }
    
    @IBAction func showBasketBallMarkers(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            googleMapsMapView.settings.compassButton = true
            googleMapsMapView.settings.myLocationButton = true
            googleMapsMapView.isMyLocationEnabled = true
        }
    }
    
    @IBAction func showHandBallMarkers(_ sender: UIButton) {
    }
    
    
}
extension MapViewController: GMSMapViewDelegate
 {
   
}
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationValue: CLLocationCoordinate2D = manager.location!.coordinate // fix the force unwrapp
        print("lat: \(locationValue.latitude) and lng: \(locationValue.longitude) ")
        let currentUsersLocation = locations.last
        self.userLocation = currentUsersLocation!
        let startPosition = GMSCameraPosition.camera(withLatitude: ( self.userLocation.coordinate.latitude), longitude: ( self.userLocation.coordinate.longitude), zoom: 14.0)
        googleMapsMapView.animate(to: startPosition)
        self.locationManager.stopUpdatingLocation()
    }
}
