//
//  SearchCourtViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 11/1/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class SearchCourtViewController: UIViewController {

    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var gameName = String()
    var basketBallCourts = [BasketBall]()
    var handBallCourts = [HandBall]()
    var selectedBasketBallCourt: BasketBall?
    var selectedHandBallCourt: HandBall?
    var basketBallResults = [BasketBall]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var handBallResult = [HandBall] () {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ParkInfoCell", bundle: nil), forCellReuseIdentifier: "ParkInfoCell")
    }


    

}

extension SearchCourtViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if gameName == GameName.basketball.rawValue {
            basketBallResults = basketBallCourts.filter{($0.nameOfPlayground?.lowercased().contains(searchText.lowercased()))!}
            
        }

        if gameName == GameName.handball.rawValue {
            handBallResult = handBallCourts.filter{($0.nameOfPlayground?.lowercased().contains(searchText.lowercased()))!}
            
        }

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}

extension SearchCourtViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gameName == GameName.basketball.rawValue {
            return basketBallResults.count
        }
        
        if gameName == GameName.handball.rawValue {
            return handBallResult.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParkInfoCell", for: indexPath) as? ParkInfoCell else {
            fatalError()
        }
        if gameName == GameName.basketball.rawValue {
            let bbCourt = basketBallResults[indexPath.row]
            cell.parkNameLabel.text = bbCourt.nameOfPlayground
            cell.parkAddressLabel.text = bbCourt.location
        }
        if gameName == GameName.handball.rawValue {
            let hbCourt = handBallResult[indexPath.row]
            cell.parkNameLabel.text = hbCourt.nameOfPlayground
            cell.parkAddressLabel.text = hbCourt.location
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if gameName == GameName.basketball.rawValue {
            selectedBasketBallCourt = basketBallResults[indexPath.row]
        }
        if gameName == GameName.handball.rawValue {
            selectedHandBallCourt = handBallResult[indexPath.row]
        }
        let optionVC = OptionsViewController()
        optionVC.delegate = self
        optionVC.modalPresentationStyle = .overCurrentContext
        present(optionVC, animated: true)
    }
}

extension SearchCourtViewController: OptionsViewDelegate {
    func leaderboardPressed() {
        
    }
    
    func playPressed() {
        
    }
    
    
}
