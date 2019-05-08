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

class MapViewController: UIViewController, MapViewPopupControllerDelegate {
    
    
    // MARK: - Outlets and Properties
    
    
    @IBOutlet weak var eliteView: UIView!
    @IBOutlet weak var closeViewBttn: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var googleMapsMapView: GMSMapView!
    @IBOutlet weak var parkTitle: UILabel!
    @IBOutlet weak var parkAddress: UILabel!
    @IBOutlet weak var googleMapsSearchBar: UISearchBar!
    
    @IBOutlet weak var handballIcon: UIButton! 
    @IBOutlet weak var basketballIcon: UIButton!
    let popUpVC = MapViewPopupController()
    private var googleMapsMVEditingState = GoogleMapsMVState.noMarkersShown {
        didSet{
            clearMarkers()
            changeMapViewState(to: googleMapsMVEditingState)
        }
    } // default state
    
    private var locationManager = CLLocationManager()
    
    private var userLocation = CLLocation.init(latitude: 40.7311, longitude: -74.0009){
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
        didSet{
            googleMapsMapView.reloadInputViews()
        }
    }
    var viewStatus: ViewStatus = .notPressed
    var pickerView = UIPickerView()
    var typeValue = String()
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
        callSetups()
        loadAllParkData()
        addCustomMakers()
        
    }
    private func callSetups(){
        setupClosePopViewBttn()
        setupMapViewSettings()
        getUsersLocations()
        setupPickerView()
        setupWest4Marker()
    }
    
    
    
    private func setupMapViewSettings(){
        googleMapsMapView.delegate = self
        googleMapsMapView.bringSubviewToFront(eliteView)
        googleMapsSearchBar.delegate = self
        
    }
    private func setupWest4Marker(){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.7311, longitude: -74.0009)
        marker.title = "West 4th Park"
        marker.snippet = "272 6th Ave, New York, NY 10012"
        marker.map = googleMapsMapView
    }
    
    private func setupPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupClosePopViewBttn(){
        closeViewBttn.layer.cornerRadius = 5
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
            handballIcon.setImage(UIImage.init(named: "handballWhite"), for: .normal)
            addMarkers(courts: basketballResults, type: .basketball)
        case .showHandBallMarkers:
            print("Show handball")
            basketballIcon.setImage(UIImage.init(named: "basketballEmptyWhite"), for: .normal)
            addMarkers(courts: handballResults, type: .handball)
        case .noMarkersShown:
            clearMarkers()
            
        }
    }
    private func presentPickerView(){
        let alertContoller = UIAlertController.init(title: "Pick A Show", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alertContoller.isModalInPopover = true //A Boolean value indicating whether the view controller should be presented modally by a popover.
        //For color of title of alert controller
        let attributedString = NSAttributedString(string: "Choose A Range (Miles)", attributes: [
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
            print("you have selected " + self.typeValue)
        }
        alertContoller.addAction(cancelAction)
        alertContoller.addAction(okAction)
        self.present(alertContoller, animated: true, completion: nil)
        // changing the color
        let subview = (alertContoller.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 10
        subview.backgroundColor = .eliteDarkMode
    }
    private func noCourtsNearMeAlert(type: SportType){
        let alertController = UIAlertController.init(title: "No \(type) courts near you", message: "Would you like to increase your range?", preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "Yes", style: .default) { (success) in
            self.presentPickerView()
            
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
                marker.icon = GMSMarker.markerImage(with: .orange)
            case .handball:
                marker.icon = GMSMarker.markerImage(with: .eliteBlue)
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
    
    func getMilesFromUser(miles: String) {
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
            print("No range Selected")
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
    
    private func callMoreActionSheet(){
        let ac = UIAlertController.init(title: "Options", message: "You have the options to create a game or go to our leaderBoard", preferredStyle: .actionSheet)
        let createAGame = UIAlertAction.init(title: "Create A Game", style: .default) { (susses) in
            self.goToCreateAGameView()
        }
        let goToLeaderBoard = UIAlertAction.init(title: "LeaderBoard", style: .default) { (sucsses) in
            self.goToLeaderBoard()
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .destructive
            , handler: nil)
        
        ac.addAction(createAGame)
        ac.addAction(goToLeaderBoard)
        ac.addAction(cancel)
        let backView = (ac.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        backView.backgroundColor = .eliteDarkMode
        
        
        self.present(ac, animated: true, completion: nil)
    }
    private func goToCreateAGameView(){
        let createGameVC = CreateGameViewController.init(nibName: "CreateGameViewController", bundle: nil)
              createGameVC.originViewController = .mapViewController
         present(createGameVC, animated: true)
    }
    private func goToLeaderBoard(){
        
    }
    //MARK: - Actions
    @IBAction func showBasketBallMarkers(_ sender: UIButton) {
        if case .showHandBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
            
        }
        
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
        }
        basketballIcon.setImage(UIImage(named: "basketballEmpty"), for: .normal)
        handballIcon.setImage(UIImage(named: "handballWhite"), for: .normal)
    }
    
    @IBAction func showHandBallMarkers(_ sender: UIButton) {
        if case .showBasketBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
        
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
        basketballIcon.setImage(UIImage(named: "basketballEmptyWhite"), for: .normal)
        handballIcon.setImage(UIImage(named: "handballBlueEmpty"), for: .normal)
    }
    
    @IBAction func closePopView(_ sender: UIButton) {
        eliteView.animHide()
        
    }
    @IBAction func moreBttnPressed(_ sender: UIButton){
        callMoreActionSheet()
    }
    
}
//MARK: - Extensions
extension MapViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        parkTitle.text = marker.title
        parkAddress.text = marker.snippet
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
       // let currentUsersLocation = locations.last
//        self.userLocation = currentUsersLocation!
        self.userLocation = CLLocation.init(latitude: 40.7311, longitude: -74.0009)
//        let startPosition = GMSCameraPosition.camera(withLatitude: ( self.userLocation.coordinate.latitude), longitude: ( self.userLocation.coordinate.longitude), zoom: 14.0)
        let customStartPostion = GMSCameraPosition.camera(withLatitude: 40.7311, longitude: -74.0009, zoom: 14.0)
        googleMapsMapView.animate(to: customStartPostion)
        self.locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MilesInMetersInfo.rangesInMiles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MilesInMetersInfo.rangesInMiles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeValue = "1"
        } else if row == 1 {
            typeValue = "2"
        } else if row == 2 {
            typeValue = "5"
        } else if row == 3 {
            typeValue = "10"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleForRange = MilesInMetersInfo.rangesInMiles[row]
        return NSAttributedString(string: titleForRange, attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
    }
}
