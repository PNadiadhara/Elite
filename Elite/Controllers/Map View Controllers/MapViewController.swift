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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    @IBAction func showBasketBallMarkers(_ sender: UIButton) {
    }
    
    @IBAction func showHandBallMarkers(_ sender: UIButton) {
    }
    
    
}
extension MapViewController: GMSMapViewDelegate
 {
   
}
