//
//  LeaderboardViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

enum FilterCollectionBy {
    case myParks
    case boroughs
}

class LeaderboardViewController: UIViewController {


    let boroughs = ["Queens", "Brooklyn", "Manhattan", "Bronx", "Staten Island"]
    let myParks = ["Astoria Park", "American Park", "Woodside Park"]
    var filterBy: FilterCollectionBy = .myParks  {
        didSet {
            DispatchQueue.main.async {
                self.leaderboardCollectionView.reloadData()
            }
        }
    }
    @IBOutlet weak var leaderboardCollectionView: UICollectionView!
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var basketBallButton: UIButton!
    @IBOutlet weak var handBallButton: UIButton!
    @IBOutlet weak var filterByButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basketBallButton.setImage(UIImage(named: "basketballEmpty"), for: .normal)
        filterByButton.setTitle("Boroughs", for: .normal)
        leaderboardCollectionView.delegate = self
        leaderboardCollectionView.dataSource = self
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        leaderboardTableView.separatorStyle = .none
        leaderboardTableView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        leaderboardCollectionView.register(UINib(nibName: "BoroughCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BoroughCollectionViewCell")
        leaderboardTableView.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
    }
    @IBAction func basketBallPressed(_ sender: Any) {
        basketBallButton.setImage(UIImage(named: "basketballEmpty"), for: .normal)
        handBallButton.setImage(UIImage(named: "handballWhite"), for: .normal)
        
    }
    @IBAction func handBallPressed(_ sender: Any) {
        handBallButton.setImage(UIImage(named: "handballBlueEmpty"), for: .normal)
        basketBallButton.setImage(UIImage(named: "basketballEmptyWhite"), for: .normal)
    }
    
    @IBAction func filterByPressed(_ sender: UIButton) {
        if filterBy == .myParks {
            filterBy = .boroughs
            filterByButton.setTitle("My parks", for: .normal)
        } else {
            filterBy = .myParks
            filterByButton.setTitle("Boroughs", for: .normal)
        }
    }
    
}

extension LeaderboardViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterBy == .myParks{
            return myParks.count
        } else {
            return boroughs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoroughCollectionViewCell", for: indexPath) as? BoroughCollectionViewCell else {return UICollectionViewCell()}
        if filterBy == .myParks{
            let myPark = myParks[indexPath.row]
            cell.cellLabel.text = myPark
            cell.cellImage.image = UIImage(named: "nycParksLogo")
            cell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            let borough = boroughs[indexPath.row]
            cell.cellLabel.text = borough
            switch borough {
            case "Queens":
                cell.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.2, blue: 0.6784313725, alpha: 1)
                cell.cellImage.image = UIImage(named: "queensIcon")
            case "Brooklyn":
                cell.backgroundColor = #colorLiteral(red: 0.4235294118, green: 0.7450980392, blue: 0.2705882353, alpha: 1)
                cell.cellImage.image = UIImage(named: "queensIcon")
            case "Manhattan":
                cell.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.2078431373, blue: 0.1803921569, alpha: 1)
                cell.cellImage.image = UIImage(named: "Manhattan")
            case "Bronx":
                cell.backgroundColor = #colorLiteral(red: 0, green: 0.5764705882, blue: 0.2352941176, alpha: 1)
                cell.cellImage.image = UIImage(named: "queensIcon")
            case "Staten Island":
                cell.backgroundColor = #colorLiteral(red: 0, green: 0.2235294118, blue: 0.6509803922, alpha: 1)
                cell.cellImage.image = UIImage(named: "StatenIsland")
                
            default:
                print("No borough")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 274, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 274.0
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        let rightInstets = (self.view.frame.size.width / 2) - (cellWidth / 2)
        let leftInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 23
    }
}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {return UITableViewCell()}
        cell.rankingLabel.text = 1.description
        cell.userName.text = "@Ibraheem"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
