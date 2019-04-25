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




    
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var basketBallButton: UIButton!
    @IBOutlet weak var handBallButton: UIButton!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basketBallButton.setImage(UIImage(named: "basketballEmpty"), for: .normal)

        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        leaderboardTableView.separatorStyle = .none
        leaderboardTableView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
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
