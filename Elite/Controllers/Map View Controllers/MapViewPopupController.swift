//
//  MapViewPopupController.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
protocol MapViewPopupControllerDelegate: AnyObject {
    func getMilesFromUser(miles: String)
}
class MapViewPopupController: UIViewController {
    //MARK: - Outlets and Properties
    public var basketBallCourts = [BasketBall]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    public var handBallResults = [HandBall](){
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
