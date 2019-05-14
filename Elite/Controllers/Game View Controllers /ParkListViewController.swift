//
//  ParkListViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import GoogleMaps

class ParkListViewController: UIViewController {

    @IBOutlet weak var parkListTableView: UITableView!
    
    public var basketBallCourts = [BasketBall]() {
        didSet {
            DispatchQueue.main.async {
                self.parkListTableView.reloadData()
            }
        }
    }
    public var basketBallResults = [BasketBall]()
    public var handBallCourts = [HandBall]()
    public var handBallResults = [HandBall](){
        didSet {
            DispatchQueue.main.async {
                self.parkListTableView.reloadData()
            }
        }
    }
    public var gameName: GameName!
    public var userLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkListTableView.dataSource = self
        parkListTableView.delegate = self
        parkListTableView.register(UINib(nibName: "ParkInfoCell", bundle: nil), forCellReuseIdentifier: "ParkInfoCell")
        parkListTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        fetchClosestParks()
        // Do any additional setup after loading the view.
    }
    
    func fetchClosestParks() {
        if gameName == .basketball {
        basketBallResults = GoogleMapHelper.getBasketBallParksNearMe(userLocation, basketBallCourts, range: MilesInMetersInfo.twoMiles).reversed()
        } else {
        handBallResults = GoogleMapHelper.getHandBallParksNearMe(userLocation, handBallCourts, range: MilesInMetersInfo.twoMiles).reversed()
        }
    }
    @IBAction func tapPressed(){
        dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ParkListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gameName == .basketball {
            return basketBallResults.count
        } else {
            return handBallResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParkInfoCell", for: indexPath) as? ParkInfoCell else {return UITableViewCell()}
        if gameName == .basketball {
            let court = basketBallResults[indexPath.row]
            cell.parkNameLabel.text = court.nameOfPlayground
            cell.parkAddressLabel.text = court.location
        } else {
            let court = handBallResults[indexPath.row]
            cell.parkNameLabel.text = court.nameOfPlayground
            cell.parkAddressLabel.text = court.location
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}
