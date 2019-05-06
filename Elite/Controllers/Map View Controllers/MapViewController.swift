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

enum ViewStatus {
    case pressed
    case notPressed
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
    let popUpVC = MapViewPopupController()
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
    var range: Double = MilesInMetersInfo.oneMile {
        didSet {
            getBasketBallParksNearMe(userLocation, basketballResults)
            getHandBallParksNearMe(userLocation, handballResults)
            addCustomMakers()
            googleMapsMapView.reloadInputViews()
           
        }
    }
<<<<<<< HEAD
    var typeValue = String()
    var viewStatus: ViewStatus = .notPressed
=======
    var range: Double?
    var viewStatus: ViewStatus = .notPressed

>>>>>>> 84494ce5dc96bce6723c2d18687190469533b4ff
    private var customArr = [[
        "Prop_ID": "",
        "Name": "Museum of the Moving Image",
        "Location": "36-01 35th Ave, Astoria, NY 11106",
        "Num_of_Courts": "2",
        "BasketballCourt": true,
        "HandballCourt": true,
        "lat": 40.7563454,
        "lon": -73.9239496],
                             [
                                "Prop_ID": "",
                                "Name": "Sean's Place",
                                "Location": "36-01 35th Ave, Astoria, NY 11106",
                                "Num_of_Courts": "2",
                                "BasketballCourt": true,
                                "HandballCourt": true,
                                "lat": 40.7609461,
                                "lon": -73.91873679999999],
                             [
                                "Prop_ID": "",
                                "Name": "Dutch Kills Playground",
                                "Location": "36th Avenue &, Crescent St, Long Island City, NY 11106",
                                "Num_of_Courts": "2",
                                "BasketballCourt": true,
                                "HandballCourt": true,
                                "lat": 40.7575695,
                                "lon": -73.93307639999999],
                             [
                                "Prop_ID": "",
                                "Name": "Playground Thirty-Five",
                                "Location": "Playground Thirty-Five, 4016 35th Ave, Long Island City, NY 11101, USA",
                                "Num_of_Courts": "2",
                                "BasketballCourt": true,
                                "HandballCourt": true,
                                "lat": 40.7548488,
                                "lon": -73.9221125],
                             [
                                "Prop_ID": "",
                                "Name": "Synergy Fitness Clubs",
                                "Location": "23-35 Broadway, Astoria, NY 11106",
                                "Num_of_Courts": "2",
                                "BasketballCourt": true,
                                "HandballCourt": true,
                                "lat": 40.7638374,
                                "lon": -73.92885819999999]
    ]

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersLocations()
        setupClosePopViewBttn()
        googleMapsMapView.delegate = self
        googleMapsMapView.bringSubviewToFront(eliteView)
        eliteView.isHidden = true
        loadAllParkData()
        addCustomMakers()
        
    }
    private func setupClosePopViewBttn(){
        closeViewBttn.layer.borderColor = UIColor.red.cgColor
        closeViewBttn.backgroundColor = .red
    }
    private func getMilesFromUser(miles: String){
        switch miles {
        case "1":
            range = MilesInMetersInfo.oneMile
        case "2":
            range = MilesInMetersInfo.twoMiles
            
        case "5":
            range = MilesInMetersInfo.fiveMiles
        case "10":
            range = MilesInMetersInfo.tenMiles
        default:
            showAlert(title: "Out of range", message: "you have tried to exceed the range limit")
        }
    }
    
    private func showPickerViewAlert(){
        let alertContoller = UIAlertController.init(title: "Pick A Show", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alertContoller.isModalInPopover = true //A Boolean value indicating whether the view controller should be presented modally by a popover.
        //For color of title of alert controller
        let attributedString = NSAttributedString(string: "Title", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.orange
            ])
        alertContoller.setValue(attributedString, forKey: "attributedTitle")
        let pickerViewFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        alertContoller.view.addSubview(pickerViewFrame)
        pickerViewFrame.dataSource = self
        pickerViewFrame.delegate = self
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (success) in
            self.getMilesFromUser(miles: self.typeValue)
        }
        alertContoller.addAction(cancelAction)
        alertContoller.addAction(okAction)
        self.present(alertContoller, animated: true, completion: nil)
        // changing the color
        let subview = (alertContoller.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 10
        subview.backgroundColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 1.0)
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
            self.showPickerViewAlert()
        }
        let noAction = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addCustomMakers(){
        for arr in customArr {
            let marker = GMSMarker()
            marker.title = arr["Name"] as? String
            marker.snippet = arr["Location"] as? String
            let locations = CLLocationCoordinate2D(latitude: arr["lat"] as! Double, longitude:  arr["lon"] as! Double)
            marker.position = locations
            marker.icon = UIImage.init(named: "eliteForBBall")
            marker.map = googleMapsMapView
            
        }
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
//                marker.icon = GMSMarker.markerImage(with: .orange)
                marker.icon = UIImage.init(named: "eliteForBBall")
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
<<<<<<< HEAD
            if distanceInMeters <= range {
=======
        

            if distanceInMeters <= MilesInMetersInfo.oneMile {

            if distanceInMeters <= range ?? 0.0 {
>>>>>>> 84494ce5dc96bce6723c2d18687190469533b4ff
                courtArr.append(court)
            }
            
        }
<<<<<<< HEAD
        print("Basketball Range is now: \(range)")
=======
        }
>>>>>>> 84494ce5dc96bce6723c2d18687190469533b4ff
        basketballResults = courtArr
        print("# of BasketBall Courts: ",basketballResults.count)
    }
    
    private func getHandBallParksNearMe(_ currentLocation: CLLocation, _ courtLocations: [HandBall]){
        
        var courtArr = [HandBall]()
        for court in courtLocations {
            let lat = court.lat ?? "0.0"
            let lng = court.lng ?? "0.0"
            let courtLocation = CLLocation(latitude: CLLocationDegrees(Double(lat)!), longitude: CLLocationDegrees(Double(lng)!))
            let distanceInMeters = courtLocation.distance(from: currentLocation)
<<<<<<< HEAD
            if distanceInMeters <= range {
=======
            if distanceInMeters <= MilesInMetersInfo.fiveMiles {
>>>>>>> 84494ce5dc96bce6723c2d18687190469533b4ff
                courtArr.append(court)
            }
            
        }
        print("handball Range is now: \(range)")
        
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
    @IBAction func createAGame(_ sender: UIButton){
    
//        tabBarController?.present(CreateGameViewController(), animated: true, completion: nil)
    }
    
}
//MARK: - Extensions
extension MapViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        eliteView.isHidden = false
        if viewStatus == .notPressed{
          viewStatus = .pressed
            eliteView.animShow()
        } else {
            viewStatus = .notPressed
            eliteView.animHide()
        }
        
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

extension MapViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MilesInMetersInfo.miles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MilesInMetersInfo.miles[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeValue = "1"
        } else if row == 1 {
            typeValue = "2"
        } else if row == 2 {
            typeValue = "2"
        } else if row == 3 {
            typeValue = "5"
        } else if row == 4 {
            typeValue = "10"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleForMiles = MilesInMetersInfo.miles[row]
        return NSAttributedString(string: titleForMiles, attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
    }
}
