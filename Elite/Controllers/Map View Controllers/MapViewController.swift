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
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersLocations()
        googleMapsMapView.delegate = self
        googleMapsMapView.bringSubviewToFront(eliteView)
       // eliteView.isHidden = true
        loadAllParkData()
        
        
    }
    private func stepupSearchView(){
//        searchThisAreaView.layer.cornerRadius = 5
//        googleMapsMapView.addSubview(searchThisAreaView)
        
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
        if filteredCourts.count == 0 {
//            showAlert(title: "No \(type) courts near you", message: "Would you like to increase your range?")
            noCourtsNearMeAlert(type: type)
            
        }
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
                marker.icon = GMSMarker.markerImage(with: .blueberry)
            }
            googleMarkers.append(marker)
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
////            eliteView.isHidden = false
//            UIView.animate(withDuration: 0.3, delay: 1, options: [], animations: {
//                self.eliteView.transform = CGAffineTransform.init(scaleX: 0, y: -500)
//            }, completion: nil)
        } else {
            stateOfPopUpView = .invisible
            eliteView.animHide()
////            eliteView.isHidden = true
//            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
//                self.eliteView.frame = CGRect(x: self.eliteView.safeAreaLayoutGuide.layoutFrame.origin.x, y: self.eliteView.safeAreaLayoutGuide.layoutFrame.origin.y + self.eliteView.safeAreaLayoutGuide.layoutFrame.height, width: self.eliteView.frame.width, height: 0)
//            }, completion: nil)
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
    
    
}
//MARK: - Extensions
extension MapViewController: GMSMapViewDelegate
 {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
   let popVC = MapViewPopupController()
//        marker.title = popVC.nameOfPark.text
//        marker.snippet = popVC.parkAddress.text
        popVC.modalPresentationStyle = .overCurrentContext
        self.present(popVC, animated: true, completion: nil)
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


