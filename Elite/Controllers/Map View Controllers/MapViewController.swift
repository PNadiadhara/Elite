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



class MapViewController: UIViewController, MapViewPopupControllerDelegate {
    func setMarkerOnMapFromTableView(_ address: String) {
        
    }

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var googleMapsMapView: GMSMapView!
    @IBOutlet weak var handballIcon: UIButton! 
    @IBOutlet weak var basketballIcon: UIButton!
    @IBOutlet weak var parkDetailView: RoundedTopCornersView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkAddressLabel: UILabel!
    @IBOutlet weak var eliteUserImage: UIImageView!
    @IBOutlet weak var eliteUserName: UILabel!
    
    let popUpVC = MapViewPopupController()
    let rankingHelper = RankingHelper()
    private var googleMapsMVEditingState = GoogleMapsMVState.noMarkersShown {
        didSet{
            googleMapsHelper.clearMarkers(mapView: googleMapsMapView)
            changeMapViewState(to: googleMapsMVEditingState)
        }
    }
    private var googleMapsHelper = GoogleMapHelper()

    private var userLocation = CLLocation()
    private var handballCourts = [HandBall]()
    private var basketballCourts = [BasketBall]()
    private var handballResults = [HandBall]()
    
    private var basketballResults = [BasketBall](){
        didSet{
            googleMapsMapView.reloadInputViews()
            googleMapsMVEditingState = .showBasketBallMarkers
        }
    }
    
    var range: Double = MilesInMetersInfo.twoMiles {
        didSet{
            basketballResults = googleMapsHelper.getBasketBallParksNearMe(userLocation, basketballCourts, range: range)
            handballResults = googleMapsHelper.getHandBallParksNearMe(userLocation, handballCourts, range: range)
            googleMapsMapView.reloadInputViews()
        }
    }

    var pickerView = UIPickerView()
    var typeValue = String()
    static var parkSelected = String()
    var locationManager = LocationManager()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        googleMapsMapView.bringSubviewToFront(parkDetailView)
        callFlagFeatures()
        googleMapsHelper.setupMapViewSettings(mapView: googleMapsMapView)
        callSetups()
        GameModel.gameName = GameName.basketball.rawValue
        locationManager.delegate = self
        googleMapsMapView.delegate = self
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
    }
    
    private func callSetups(){
        setupPickerView()
    }
    private func findRankingAtPark(parkId: String,sport: String) {
        rankingHelper.findRankingByPark(parkId: parkId, sport: sport) { (gamers, error) in
            if let error = error {
                self.showAlert(title: "No elite", message: error.localizedDescription)
            }
            if let gamers = gamers {
                if let elite = gamers.first {
                    self.eliteUserImage.image = nil
                    self.eliteUserName.text = elite.username
                    guard let profileImage = elite.profileImage,
                    let profileImageUrl = URL(string: profileImage) else {return}
                    self.eliteUserImage.kf.setImage(with: profileImageUrl)
                } else {
                    self.eliteUserName.text = "No elite at this location"
                    self.eliteUserImage.image = nil
                }
            }
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
    


    private func changeMapViewState(to state: GoogleMapsMVState) {
        switch state {
        case .showBasketBallMarkers:
            print("Show basketball")
            basketballIcon.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.5137254902, blue: 0.2039215686, alpha: 1)
            handballIcon.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
            googleMapsHelper.addMarkers(courts: basketballResults, type: .basketball, mapView: googleMapsMapView)
        case .showHandBallMarkers:
            print("Show handball")
            basketballIcon.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
            handballIcon.backgroundColor = #colorLiteral(red: 0, green: 0.6754498482, blue: 0.9192627668, alpha: 1)
            googleMapsHelper.addMarkers(courts: handballResults, type: .handball, mapView: googleMapsMapView)
        case .noMarkersShown:
            googleMapsHelper.clearMarkers(mapView: googleMapsMapView)
            
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
    
    


    private func goToLeaderBoard(){
        let leaderBoardVC = LeaderboardViewController(nibName: nil, bundle: nil, parkId: GameModel.parkId!, sport: GameModel.gameName!,parkName: GameModel.parkSelected!)
        self.navigationController?.pushViewController(leaderBoardVC, animated: true)
    }
    
    private func goToParkFeed() {
        
        let parkFeed = ParkFeedViewController(nibName: nil, bundle: nil, parkId: GameModel.parkId!, parkName: GameModel.parkSelected!)
        let navController = UINavigationController(rootViewController: parkFeed)
        navController.isNavigationBarHidden = true
        present(navController, animated: true)
    }
    //MARK: - Actions
    @IBAction func showBasketBallMarkers(_ sender: UIButton) {
        parkDetailView.isHidden = true
        basketballResults = googleMapsHelper.getBasketBallParksNearMe(userLocation, basketballCourts, range: range)
        GameModel.gameName = GameName.basketball.rawValue
        if case .showHandBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
        }
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showBasketBallMarkers
        }
    }
    
    @IBAction func showHandBallMarkers(_ sender: UIButton) {
        parkDetailView.isHidden = true
        handballResults = googleMapsHelper.getHandBallParksNearMe(userLocation, handballCourts, range: range)
        GameModel.gameName = GameName.handball.rawValue
        if case .showBasketBallMarkers = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
        
        if case .noMarkersShown = googleMapsMVEditingState {
            googleMapsMVEditingState = .showHandBallMarkers
        }
    }
    @IBAction func searchPressed(_ sender: Any) {
        let searchVC = SearchCourtViewController()
        if googleMapsMVEditingState == .showBasketBallMarkers {
            searchVC.gameName = GameName.basketball.rawValue
            searchVC.basketBallCourts = basketballCourts
        }
        if googleMapsMVEditingState == .showHandBallMarkers {
            searchVC.gameName = GameName.handball.rawValue
            searchVC.handBallCourts = handballCourts
        }
        present(searchVC, animated: true)
    }
    
    @IBAction func mapDetailViewCancelPressed(_ sender: Any) {
        parkDetailView.isHidden = true
    }
    
    @IBAction func mapDetailLeaderboardPressed(_ sender: Any) {
       goToLeaderBoard()
    }
    
    @IBAction func mapDetailPlayPressed(_ sender: Any) {
        let oneVsOneVc = OneVsOneViewController()
        
            oneVsOneVc.gameName = GameModel.gameName
            GameModel.gameTypeSelected = "1 vs. 1"
        
        MultiPeerConnectivityHelper.shared.hostGame()
        MultiPeerConnectivityHelper.shared.role = .Host

        
        GameModel.gameTypeSelected = "1 vs. 1"
        // multipeerConnectivityHelper.hostGame()
        self.navigationController?.pushViewController(oneVsOneVc, animated: true)
    }
    
    @IBAction func mapDetailFeedPressed(_ sender: Any) {
        goToParkFeed()
    }
    
}
//MARK: - Extensions
extension MapViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        parkDetailView.isHidden = false
        let position = marker.position
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 14.0)
        mapView.animate(to: camera)
        let index = Int(marker.title!)!
        if googleMapsMVEditingState == .showBasketBallMarkers {
            let bbCourt = basketballResults[index]
            parkNameLabel.text = bbCourt.nameOfPlayground!
            GameModel.parkSelected = bbCourt.nameOfPlayground!
            GameModel.parkId = bbCourt.propertyID
            GameModel.parkLat = bbCourt.lat
            GameModel.parkLon = bbCourt.lng
            parkAddressLabel.text = bbCourt.location
            findRankingAtPark(parkId: bbCourt.propertyID!, sport: SportType.basketball.rawValue)
        }
        if googleMapsMVEditingState == .showHandBallMarkers {
            let hbCourt = handballResults[index]
            parkNameLabel.text = hbCourt.nameOfPlayground!
            GameModel.parkSelected = hbCourt.nameOfPlayground!
            GameModel.parkId = hbCourt.propertyID
            GameModel.parkLat = hbCourt.lat
            GameModel.parkLon = hbCourt.lng
            parkAddressLabel.text = hbCourt.location
            findRankingAtPark(parkId: hbCourt.propertyID!, sport: SportType.handball.rawValue)
        }
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
        basketballResults = googleMapsHelper.getBasketBallParksNearMe(userLocation, basketballCourts, range: range)
        handballResults = googleMapsHelper.getHandBallParksNearMe(userLocation, handballCourts, range: range)
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
    }
    
    func errorLoadingData(error: AppError) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    
}

