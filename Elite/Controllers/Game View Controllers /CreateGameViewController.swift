//
//  CreateGameViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import GoogleMaps
protocol CreateGameViewControllerDelegate: AnyObject {
    func generateQRCodeOfUser(qrString: String?, qrImage: UIImageView?)
}

enum OriginViewController {
    case mapViewController
}
class CreateGameViewController: UIViewController {

    @IBOutlet weak var fiveVsFiveView: UIView!
    @IBOutlet weak var oneVsOneView: UIView!
    @IBOutlet weak var twoVsTwoView: UIView!
//    @IBOutlet weak var changeSportView: UIView!
    @IBOutlet weak var selectedSportView: UIView!
    @IBOutlet weak var locationHeader: UIView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var animatedTopLeft: UIView!
    @IBOutlet weak var animatedTopRight: UIView!
    @IBOutlet weak var animatedBottomLeft: UIView!
    @IBOutlet weak var chooseSportLabel: UILabel!
    @IBOutlet weak var middleAnimatedView: UIView!
    @IBOutlet weak var handBallView: UIView!
    @IBOutlet weak var basketBallView: UIView!
    @IBOutlet weak var basketBallImage: UIImageView!
    @IBOutlet weak var basketBallLabel: UILabel!
    @IBOutlet weak var handballLabel: UILabel!
    @IBOutlet weak var handballImage: UIImageView!
    
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var animatedBottomRight: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var parkSelectedLabel: UILabel!
    
    var userStr: String?
    var userQrImage: UIImageView?
    weak var delegate: CreateGameViewControllerDelegate?
    var closestPark = String()
    //let multipeerConnectivityHelper = MultiPeerConnectivityHelper()
    var gameName: GameName! {
        didSet {
            if gameName == .handball {
                if let closestCourt = GoogleMapHelper.getHandballCourtClosestToUsersLocation(closestToLocation: userLocation, handballCourts: handballResults) {
                    closestHandballcourt = closestCourt
                }
            }
            if gameName == .basketball {
                if let closestCourt = GoogleMapHelper.getBasketballCourtClosestToUsersLocation(closestToLocation: userLocation, basketballCourts: basketballResults) {
                    closestBasketballcourt = closestCourt
                }
            }
        }
    }
    var closestBasketballcourt: BasketBall! {
        didSet {
            if originViewController != .mapViewController {
                parkSelectedLabel.text = closestBasketballcourt.nameOfPlayground
            }
            
        }
    }
    var closestHandballcourt: HandBall! {
        didSet {
            if originViewController != .mapViewController {
                parkSelectedLabel.text = closestHandballcourt.nameOfPlayground
            }
            
        }
    }
    var originViewController: OriginViewController?
    var animatedViews = [UIView]()
    var parkSelected = String()
    public var handballResults = [HandBall]()
    public var basketballResults = [BasketBall]()
    private var locationManager = CLLocationManager()
    private var userLocation = CLLocation(){
        didSet{
            
//            closestBasketballcourt = GoogleMapHelper.getBasketballCourtClosestToUsersLocation(closestToLocation: userLocation, basketballCourts: basketballResults)
//            closestHandballcourt = GoogleMapHelper.getHandballCourtClosestToUsersLocation(closestToLocation: userLocation, handballCourts: handballResults)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllParkData()
        animatedViews = [animatedTopRight,animatedTopLeft,animatedBottomLeft,animatedBottomRight]
        setupViewTapGestures()
        if originViewController == .mapViewController {
            cancelButton.isHidden = false
            parkSelectedLabel.text = parkSelected
        }
        locationManager.delegate = self
        if Flag.isDemo {
            
        } else {
            GoogleMapHelper.getUsersLocations(locationManager: locationManager)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.155343473, green: 0.1647959352, blue: 0.1777093709, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        selectedSportView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
        selectedSportView.layer.borderWidth = 5
        selectedSportView.layer.cornerRadius = selectedSportView.bounds.width / 2
        selectedSportView.layer.masksToBounds = true
        middleAnimatedView.layer.cornerRadius = selectedSportView.bounds.width / 2
        middleAnimatedView.layer.masksToBounds = true
        parkSelectedLabel.layer.cornerRadius = 20
        parkSelectedLabel.layer.masksToBounds = true
        
    //        changeSportView.layer.borderWidth = 0
    }
    func setupUI() {
        
    }
    
    private func loadAllParkData(){
        GoogleMapHelper.loadAllParkData { (handballCourt, basketballCourt) in
            do {
                self.handballResults = try JSONDecoder().decode([HandBall].self, from: handballCourt)
                self.basketballResults = try JSONDecoder().decode([BasketBall].self, from: basketballCourt)
            } catch {
                print(error)
            }
        }
    }
    func setupViewTapGestures(){
        
        let changeParkTap = UITapGestureRecognizer(target: self, action: #selector(changeParkPressed))
        parkSelectedLabel.addGestureRecognizer(changeParkTap)
        if originViewController != .mapViewController {
          parkSelectedLabel.isUserInteractionEnabled = true
        }
        
        
        let basketBallTap = UITapGestureRecognizer(target: self, action: #selector(basketBallPressed))
        basketBallView.addGestureRecognizer(basketBallTap)
        let handBallTap = UITapGestureRecognizer(target: self, action: #selector(handBallPressed))
        handBallView.addGestureRecognizer(handBallTap)
//        let selectedSportTap = UITapGestureRecognizer(target: self, action: #selector(selectedSportPressed))
//        selectedSportView.addGestureRecognizer(selectedSportTap)
        
        
    }
    func addTapToGameTypeView() {
        let oneVsOneTap = UITapGestureRecognizer(target: self, action: #selector(oneVsOnePressed))
        oneVsOneView.addGestureRecognizer(oneVsOneTap)
        
        let twoVsTwoTap = UITapGestureRecognizer(target: self, action: #selector(twoVstwoPressed))
        twoVsTwoView.addGestureRecognizer(twoVsTwoTap)
        
        let fiveVsFiveTap = UITapGestureRecognizer(target: self, action: #selector(fiveVsFivePressed))
        fiveVsFiveView.addGestureRecognizer(fiveVsFiveTap)
        
        let qrViewTap = UITapGestureRecognizer(target: self, action: #selector(qrCodePressed))
        qrCodeView.addGestureRecognizer(qrViewTap)
    }
    func animateViews(){
        let views = [oneVsOneView,twoVsTwoView,fiveVsFiveView,qrCodeView]
        if gameName == .basketball {
            basketBallView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.6078431373, blue: 0.1450980392, alpha: 1)
            handBallView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
            basketBallImage.image = UIImage(named: "basketballEmptyWhite")
            basketBallLabel.textColor = .white
            handballImage.image = UIImage(named: "handballBlueEmpty")
            handballLabel.textColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
            middleAnimatedView.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            for playerView in views{
                playerView?.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.6078431373, blue: 0.1450980392, alpha: 1)
                playerView?.layer.borderWidth = 3
                
            }
        } else {
            handBallView.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
            basketBallView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
            handballImage.image = UIImage(named: "handballWhite")
            handballLabel.textColor = .white
            basketBallImage.image = UIImage(named: "basketballEmpty")
            basketBallLabel.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            middleAnimatedView.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
            for playerView in views{
                playerView?.layer.borderColor = #colorLiteral(red: 0, green: 0.6754498482, blue: 0.9192627668, alpha: 1)
                playerView?.layer.borderWidth = 3
                
            }
        }
        UIView.animate(withDuration: 2.0, delay: 0, options: [], animations: {
            self.animatedTopLeft.transform = CGAffineTransform(translationX: -600, y: 0)
            
        })
        UIView.animate(withDuration: 2.0, delay: 0 , options: [], animations: {
            self.animatedTopRight.transform = CGAffineTransform(translationX: 600, y: 0)
            
        })
        UIView.animate(withDuration: 2.0, delay: 0 , options: [], animations: {
            self.animatedBottomLeft.transform = CGAffineTransform(translationX: 0, y: 600)
            
        })
        UIView.animate(withDuration: 2.0, delay: 0 , options: [], animations: {
            self.animatedBottomRight.transform = CGAffineTransform(translationX: 0, y: 600)
            
        })
        UIView.animate(withDuration: 0.5) {
            self.chooseSportLabel.alpha = 0
        }
        
        UIView.animate(withDuration: 1) {
            self.middleAnimatedView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
    }
    @objc func oneVsOnePressed() {
        let oneVsOneVc = OneVsOneViewController()
        oneVsOneVc.modalPresentationStyle = .fullScreen
        oneVsOneVc.modalTransitionStyle = .flipHorizontal
        oneVsOneVc.gameName = gameName
        oneVsOneVc.gameTypeSelected = .oneVsOne
        oneVsOneVc.parkSelected = parkSelected
        MultiPeerConnectivityHelper.shared.hostGame()
       // multipeerConnectivityHelper.hostGame()
        present(oneVsOneVc, animated: true)
    }
    @objc func twoVstwoPressed() {
        let twoVsTwoVc = TwoVsTwoViewController.init(nibName: "TwoVsTwoViewController", bundle: nil)
        twoVsTwoVc.modalPresentationStyle = .fullScreen
        twoVsTwoVc.modalTransitionStyle = .flipHorizontal
        twoVsTwoVc.gameName = gameName
        twoVsTwoVc.gameTypeSelected = .twoVsTwo
        present(twoVsTwoVc, animated: true)
    }
    @objc func fiveVsFivePressed() {
        let fiveVsFiveVc = FiveVsFiveViewController.init(nibName: "FiveVsFiveViewController", bundle: nil)
        fiveVsFiveVc.modalPresentationStyle = .fullScreen
        present(fiveVsFiveVc, animated: true)
    }
    @objc func qrCodePressed() {
        let qrCodeVC = QrCodeViewController.init(nibName: "QrCodeViewController", bundle: nil)
        // code for generate QRCode
        delegate?.generateQRCodeOfUser(qrString: userStr!, qrImage: userQrImage!)
        present(qrCodeVC, animated: true)
       
    }
    
    @objc func changeParkPressed() {
        let parkListVC = ParkListViewController.init(nibName: "ParkListViewController", bundle: nil)
        if gameName == .basketball {
            parkListVC.basketBallCourts = basketballResults
            
        } else {
            parkListVC.handBallCourts = handballResults
        }
        parkListVC.gameName = gameName
        parkListVC.userLocation = userLocation
        parkListVC.typeOfList = .ParkList
        parkListVC.modalPresentationStyle = .overCurrentContext
        present(parkListVC, animated: true)
    }
    
    @objc func basketBallPressed() {
        gameName = .basketball
        showParkLabels()
        print("basketBall PRessed")
        addTapToGameTypeView()
        middleAnimatedView.transform = CGAffineTransform.identity
        animatedViews.forEach{$0.transform = CGAffineTransform.identity}
         animateViews()


        
    }
    @objc func handBallPressed() {
        gameName = .handball
        showParkLabels()
        print("handBall PRessed")
        addTapToGameTypeView()
        middleAnimatedView.transform = CGAffineTransform.identity
        animatedViews.forEach{$0.transform = CGAffineTransform.identity}
        animateViews()

    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func showParkLabels() {
        parkSelectedLabel.isHidden = false
        currentLocationLabel.isHidden = false
    }

}
extension CreateGameViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationValue: CLLocationCoordinate2D = manager.location!.coordinate // fix the force unwrapp
        print("lat: \(locationValue.latitude) and lng: \(locationValue.longitude) ")
        if Flag.isDemo{
            self.userLocation = CLLocation.init(latitude: 40.7563454, longitude: -73.9239496)
        } else {
            self.userLocation = locations.last!
        }

        self.locationManager.stopUpdatingLocation()
    }
}

