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

class MapViewController: UIViewController, MapViewPopupControllerDelegate {
    func setMarkerOnMapFromTableView(_ address: String) {
        
    }
    
    
    
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
    @IBOutlet weak var popupSearchButton: UIButton!
    let popUpVC = MapViewPopupController()
    
    private var googleMapsMVEditingState = GoogleMapsMVState.noMarkersShown {
        didSet{
            clearMarkers()
            changeMapViewState(to: googleMapsMVEditingState)
        }
    }
    private var googleMapsHelper = GoogleMapHelper()

    private var userLocation = CLLocation()
    private var handballCourts = [HandBall]()
    private var basketballCourts = [BasketBall]()
    private var handballResults = [HandBall]() {
        didSet{
//            googleMapsMapView.reloadInputViews()
//            googleMapsMVEditingState = .showHandBallMarkers

        }
    }
    
    private var basketballResults = [BasketBall](){
        didSet{
            googleMapsMapView.reloadInputViews()
            googleMapsMVEditingState = .showBasketBallMarkers
        }
    }
    
    var range: Double = MilesInMetersInfo.twoMiles {
        didSet{
            basketballResults = GoogleMapHelper.getBasketBallParksNearMe(userLocation, basketballCourts, range: range)
            handballResults = GoogleMapHelper.getHandBallParksNearMe(userLocation, handballCourts, range: range)
            googleMapsMapView.reloadInputViews()
        }
    }
    var viewStatus: ViewStatus = .notPressed
    var pickerView = UIPickerView()
    var typeValue = String()
    static var parkSelected = String()
    var locationManager = LocationManager()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callFlagFeatures()
        
        callSetups()

        //        addCustomMakers()
        locationManager.delegate = self
        locationManager.getUserLocation()
        googleMapsHelper.delegate = self
        googleMapsHelper.loadAllParkData()
    }
    
    private func callFlagFeatures(){
        if Flag.isDemo {
            googleMapsMVEditingState = .showHandBallMarkers
            //          setupWest4Marker()
            userLocation = CLLocation.init(latitude: 40.7563454, longitude: -73.9239496)
        }
        
        if !Flag.isSearchBarOnMapReady {
            popupSearchButton.isHidden = true
            googleMapsSearchBar.isHidden = true 
        }
    }
    
    private func callSetups(){
        setupClosePopViewBttn()
        setupMapViewSettings()

        setupPickerView()
        
    }
    
    
    
    private func setupMapViewSettings(){
        googleMapsMapView.delegate = self
        googleMapsMapView.bringSubviewToFront(eliteView)
        //googleMapsSearchBar.delegate = self
        googleMapsMapView.settings.compassButton = true
        googleMapsMapView.settings.myLocationButton = true
        googleMapsMapView.isMyLocationEnabled = true
        if Flag.isSearchBarOnMapReady == false {
            googleMapsSearchBar.isHidden = true 
        }
        
        
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
    
    //    private func getUsersLocations(){
    //        locationManager.requestWhenInUseAuthorization()
    //        if CLLocationManager.locationServicesEnabled(){
    //
    //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    //            locationManager.startUpdatingLocation()
    //            googleMapsMapView.settings.compassButton = true
    //            googleMapsMapView.settings.myLocationButton = true
    //            googleMapsMapView.isMyLocationEnabled = true
    //        }
    //    }
    
    
    private func clearMarkers(){
        googleMapsMapView.clear()
    }
    private func test () {

    }
    private func changeMapViewState(to state: GoogleMapsMVState) {
        switch state {
        case .showBasketBallMarkers:
            print("Show basketball")
            basketballIcon.setImage(UIImage(named: "basketballEmpty"), for: .normal)
            handballIcon.setImage(UIImage(named: "handballWhite"), for: .normal)
            addMarkers(courts: basketballResults, type: .basketball)
        case .showHandBallMarkers:
            print("Show handball")
            basketballIcon.setImage(UIImage(named: "basketballEmptyWhite"), for: .normal)
            handballIcon.setImage(UIImage(named: "handballBlueEmpty"), for: .normal)
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
            self.getMilesFromUser(miles: self.typeValue)
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
    
    
    private func callMoreActionSheet(){
        let createAGame = UIAlertAction.init(title: "Create A Game", style: .default) { (susses) in
            self.goToCreateAGameView()
        }
        let goToLeaderBoard = UIAlertAction.init(title: "LeaderBoard", style: .default) { (sucsses) in
            self.goToLeaderBoard()
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .destructive
            , handler: nil)
        if !Flag.isLeaderBoardUp {
            let ac = UIAlertController.init(title: "Let's Play a game", message: "You have the options to create a game from here or cancel", preferredStyle: .actionSheet)
            ac.addAction(createAGame)
            ac.addAction(cancel)
            let backView = (ac.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            backView.backgroundColor = .eliteDarkMode
            self.present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController.init(title: "Options", message: "You have the options to create a game or go to our leaderBoard", preferredStyle: .actionSheet)
            ac.addAction(createAGame)
            ac.addAction(goToLeaderBoard)
            ac.addAction(cancel)
            let backView = (ac.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            backView.backgroundColor = .eliteDarkMode
            self.present(ac, animated: true, completion: nil)
        }
    }
    private func goToCreateAGameView(){
        let createGameVC = CreateGameViewController.init(nibName: "CreateGameViewController", bundle: nil)
        createGameVC.originViewController = .mapViewController
        createGameVC.parkSelected = MapViewController.parkSelected
        present(createGameVC, animated: true)
    }
    private func goToLeaderBoard(){
        
    }
    //MARK: - Actions
    @IBAction func showBasketBallMarkers(_ sender: UIButton) {
        basketballResults = GoogleMapHelper.getBasketBallParksNearMe(userLocation, basketballCourts, range: range)
        if case .showHandBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
            
        }
        
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
        }
    }
    
    @IBAction func showHandBallMarkers(_ sender: UIButton) {
        handballResults = GoogleMapHelper.getHandBallParksNearMe(userLocation, handballCourts, range: range)
        if case .showBasketBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
        
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
    }
    
    @IBAction func closePopView(_ sender: UIButton) {
        eliteView.animHide()
        viewStatus = .notPressed
        
    }
    @IBAction func moreBttnPressed(_ sender: UIButton){
        callMoreActionSheet()
    }
    @IBAction func searchButtonPressed(){
        let popView = MapViewPopupController()
        self.present(popView, animated: true)
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
        MapViewController.parkSelected = marker.title!
        
        return true
    }
    
}
extension MapViewController: LocationManagerDelegate {
    func didGetLocation(location: CLLocation) {
        self.userLocation = location
        var customStartPosition = GMSCameraPosition()
        if Flag.isDemo{
            
            customStartPosition = GMSCameraPosition.camera(withLatitude: 40.7563454, longitude: -73.9239496, zoom: 14.0)
        } else {
            
            customStartPosition = GMSCameraPosition.camera(withLatitude: ( self.userLocation.coordinate.latitude), longitude: ( self.userLocation.coordinate.longitude), zoom: 14.0)
        }
        
        googleMapsMapView.animate(to: customStartPosition)
        basketballResults = GoogleMapHelper.getBasketBallParksNearMe(userLocation, basketballCourts, range: range)
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

extension MapViewController: FetchDataDelegate {
    func didLoadData(basketballCourts: [BasketBall], handballCourts: [HandBall]) {
        self.basketballCourts = basketballCourts
        self.handballCourts = handballCourts
        BasketBall.allBasketBallCourts = basketballCourts
        HandBall.allHandBallCourts = handballCourts

//        var numberOfNils = 0
//        let sorted = handballCourts.sorted { $0.nameOfPlayground!.lowercased() < $1.nameOfPlayground!.lowercased() }
//        for basketballCourt in sorted{
//            if basketballCourt.lat == nil {
//                var lats = Double()
//                var lons = Double()
//                GooglePlacesClient.fetchLatAndLon(from: basketballCourt.nameOfPlayground!) { (lat, lon) in
//                    if let lat = lat {
//                        switch lat {
//                        case .failure(let error):
//                            print(error)
//                        case .success(let lat):
//                            lats = lat
//                        }
//                    }
//                    if let lon = lon {
//                        switch lon {
//                        case .failure(let error):
//                            print(error)
//                        case .success(let lon):
//                            lons = lon
//                        }
//                    }
//                    numberOfNils += 1
//                    print("\(basketballCourt.nameOfPlayground): \"lat\": \"\(lats)\",\n \"lon\": \"\(lons)\"")
//                }
//            }
//        }
//        print("NILS \(numberOfNils)")
    }
    
    func errorLoadingData(error: AppError) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    
}

