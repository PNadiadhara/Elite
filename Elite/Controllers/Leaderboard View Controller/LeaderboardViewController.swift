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


    var parkId: String!
    var sport: String!
    private var players = [GamerModel]() {
        didSet {
            DispatchQueue.main.async {
                self.leaderboardTableView.reloadData()
            }
        }
    }

    
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var firstPlayerImage: CircularRedImageView!
    @IBOutlet weak var secondPlayerImage: CircularBlueImageView!
    @IBOutlet weak var thirdPlayerImage: CircularGreenImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        leaderboardTableView.separatorStyle = .none
        leaderboardTableView.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
    }

    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, parkId: String, sport: String) {
        super.init(nibName: nil, bundle: nil)
        self.parkId = parkId
        self.sport = sport
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {return UITableViewCell()}

        for player in players {
            cell.setupCell(with: player, indexPathRow: indexPath.row, parkId: parkId, sport: sport)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
