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
protocol MapViewControllerDelegate: AnyObject {
    func makerDidTapOnMap()
}
enum ViewVisibiltyState {
    case visibile
    case invisible
}
class MapViewController: UIViewController {
    // MARK: - Outlets and Properties
    
    
    @IBOutlet weak var eliteView: UIView!
    @IBOutlet weak var closeViewBttn: CircularButton!
    
    @IBOutlet weak var googleMapsMapView: GMSMapView!
    //    private let delegate: MapViewControllerDelegate?
    private var stateOfPopUpView = ViewVisibiltyState.invisible
    private var googleMapsMVEditingState = GoogleMapsMVState.noMarkersShown {
        didSet{
            clearMarkers()
            changeMapViewState(to: googleMapsMVEditingState)
        }
    } // default state
    
    private var locationManager = CLLocationManager()
    
    private var userLocation = CLLocation(){
        didSet{
            getBasketBallParksNearMe(userLocation, basketballResults)
            getHandBallParksNearMe(userLocation, handballResults)
        }
    }
    
    private var handballResults = [HandBall]() {
        didSet{
            googleMapsMapView.reloadInputViews()
        }
    }
    
    private var basketballResults = [BasketBall](){
        didSet{
            googleMapsMapView.reloadInputViews()
        }
    }
    var range: Double?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersLocations()
       setupClosePopViewBttn()
        googleMapsMapView.delegate = self
        googleMapsMapView.bringSubviewToFront(eliteView)
        eliteView.isHidden = true
        loadAllParkData()
        
        
    }
    private func setupClosePopViewBttn(){
        closeViewBttn.layer.borderColor = UIColor.red.cgColor
        closeViewBttn.backgroundColor = .red
    }
   
    private func getUsersLocations(){
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
    
    private func loadAllParkData(){
        if let handballCourtDataFilePath = Bundle.main.path(forResource: "handballCourtInfo", ofType: "json"), let basketballCourtDataFilePath = Bundle.main.path(forResource: "basketballCourtInfo", ofType: "json"){
            let handballCourtDataUrl = URL.init(fileURLWithPath: handballCourtDataFilePath)
            let basketballCourtDataUrl = URL.init(fileURLWithPath: basketballCourtDataFilePath)
            if let jsonHandBallParkData = try? Data.init(contentsOf: handballCourtDataUrl), let jsonBasketBallParkData = try? Data.init(contentsOf: basketballCourtDataUrl){
                do {
                    handballResults = try JSONDecoder().decode([HandBall].self, from: jsonHandBallParkData)
                    basketballResults = try JSONDecoder().decode([BasketBall].self, from: jsonBasketBallParkData)
                    print("handball Courts: \(handballResults.count), basketball Courts: \(basketballResults.count)")
                } catch {
                    print(error)
                }
            } else {
                print("issue with converting the urls into data")
            }
        } else {
            print("issue with the json file paths")
        }
    }
    
    private func clearMarkers(){
        googleMapsMapView.clear()
    }
    
    private func changeMapViewState(to state: GoogleMapsMVState) {
        switch state {
        case .showBasketBallMarkers:
            print("Show basketball")
            addMarkers(courts: basketballResults, type: .basketball)
        case .showHandBallMarkers:
            print("Show handball")
            addMarkers(courts: handballResults, type: .handball)
        case .noMarkersShown:
            clearMarkers()
            
        }
    }
    private func noCourtsNearMeAlert(type: SportType){
        let alertController = UIAlertController.init(title: "No \(type) courts near you", message: "Would you like to increase your range?", preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "Yes", style: .default) { (success) in
            let popViewVC = MapViewPopupController()
            popViewVC.modalPresentationStyle = .overCurrentContext
            self.present(popViewVC, animated: true, completion:  nil)
            
        }
        let noAction = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
    private func addMarkers(courts: [Court], type: SportType) {
        var googleMarkers = [GMSMarker]()
        
        let filteredCourts = courts.filter { $0.type == type}
        print("Number of courts: ",filteredCourts.count)
        for court in filteredCourts {
            let locations = CLLocationCoordinate2D(latitude: Double(court.lat ?? "0.0")!, longitude:  Double(court.lng ?? "0.0")!)
            let marker = GMSMarker()
            marker.title = court.nameOfPlayground ?? "No name"
            marker.snippet = court.location ?? "No location"
            marker.position = locations
            switch court.type {
            case .basketball:
                marker.icon = GMSMarker.markerImage(with: .orange)
            case .handball:
                marker.icon = UIImage.init(named: "eliteMarker")
                //marker.iconView = UIImage.init(named: "eliteMarker")
            }
            googleMarkers.append(marker)
        }
        if filteredCourts.count == 0 {
            noCourtsNearMeAlert(type: type)
            
        }
        googleMarkers.forEach { (marker) in
            marker.map = googleMapsMapView
        }
        
    }
    
    private func getBasketBallParksNearMe(_ currentLocation: CLLocation, _ courtLocations: [BasketBall]){
        loadAllParkData()
        var courtArr = [BasketBall]()
        for court in courtLocations {
            let lat = court.lat ?? "0.0"
            let lng = court.lng ?? "0.0"
            let courtLocation = CLLocation(latitude: CLLocationDegrees(Double(lat)!), longitude: CLLocationDegrees(Double(lng)!))
            let distanceInMeters = courtLocation.distance(from: currentLocation)
        
            if distanceInMeters <= MilesInMetersInfo.oneMile {
                courtArr.append(court)
            }
        }
        basketballResults = courtArr
        print(basketballResults.count)
    }
    
    private func getHandBallParksNearMe(_ currentLocation: CLLocation, _ courtLocations: [HandBall]){
        
        var courtArr = [HandBall]()
        for court in courtLocations {
            let lat = court.lat ?? "0.0"
            let lng = court.lng ?? "0.0"
            let courtLocation = CLLocation(latitude: CLLocationDegrees(Double(lat)!), longitude: CLLocationDegrees(Double(lng)!))
            let distanceInMeters = courtLocation.distance(from: currentLocation)
            if distanceInMeters <= MilesInMetersInfo.oneMile {
                courtArr.append(court)
            }
        }
        handballResults = courtArr
    }
    
    //MARK: - Actions
    @IBAction func test(_ sender: UIButton) {
        if stateOfPopUpView == .invisible {
            stateOfPopUpView = .visibile
            eliteView.animShow()
        } else {
            stateOfPopUpView = .invisible
            eliteView.animHide()
        }
    }
    @IBAction func showBasketBallMarkers(_ sender: UIButton) {
        if case .showHandBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
            
        }
        
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
        }
    }
    
    @IBAction func showHandBallMarkers(_ sender: UIButton) {
        if case .showBasketBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
        
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
    }
    
    @IBAction func closePopView(_ sender: CircularButton) {
        eliteView.animHide()
        
    }
    
}
//MARK: - Extensions
extension MapViewController: GMSMapViewDelegate
 {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        eliteView.isHidden = false
        eliteView.animShow()
        return true
    }

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


