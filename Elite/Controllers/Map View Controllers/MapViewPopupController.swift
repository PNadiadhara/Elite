//
//  MapViewPopupController.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
protocol MapViewPopupControllerDelegate: AnyObject {
    func setMarkerOnMapFromTableView(_ address: String)
}
class MapViewPopupController: UIViewController {
    //MARK: - Outlets and Properties
    public var basketBallCourts = [BasketBallData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    public var handBallResults = [HandBallData](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    weak var delegate: MapViewPopupControllerDelegate?
    @IBOutlet weak var milesView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewSettings()
        DBService.fetchBasketBallParks {[weak self] (error, courts) in
            if let error = error {
                print("error is: ",error)
            }
            if let courts = courts {
                self?.basketBallCourts = courts
            }
        }
    }
    
    private func setupViewSettings(){
        milesView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableViewCell()
    }
    
    private func setupTableViewCell(){
        tableView.register(UINib(nibName: "ParkInfoCell", bundle: nil), forCellReuseIdentifier: "ParkInfoCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
    }
    
    //MARK: - Actions
    @IBAction func bringDownView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func goback(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
   
}
extension MapViewPopupController: UISearchBarDelegate{}
extension MapViewPopupController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketBallCourts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParkInfoCell", for: indexPath) as? ParkInfoCell else {
            fatalError("issue with linking the nib file")
        }
        let settingCells = basketBallCourts[indexPath.row]
        cell.parkNameLabel?.text = settingCells.name
        cell.parkAddressLabel?.text = settingCells.location
        cell.parkNameLabel?.textColor = .white
        cell.parkAddressLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = basketBallCourts[indexPath.row]
        delegate?.setMarkerOnMapFromTableView(address.location)
    }
}
