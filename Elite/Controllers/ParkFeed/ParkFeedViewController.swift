//
//  ParkFeedViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 11/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

enum ParkFeedView {
    case recentActivity, messageBoard
}
class ParkFeedViewController: UIViewController {

    var parkId: String!
    var parkName: String!
    
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var recentActivityButton: RoundedButton!
    @IBOutlet weak var messageBoardButton: RoundedButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var parkViewFeed: ParkFeedView! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var parkActivity = [GameModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var messageBoardPosts = [MessageBoardPost]()

    override func viewDidLoad() {
        super.viewDidLoad()
        parkNameLabel.text = parkName
        parkViewFeed = .recentActivity
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RecentActivityCell", bundle: nil), forCellReuseIdentifier: "RecentActivityCell")
        fetchParkGames()
        // Do any additional setup after loading the view.
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, parkId: String, parkName: String) {
        self.parkName = parkName
        self.parkId = parkId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchParkGames() {
        DBService.fetchGamesPlayedAtPark(parkId: parkId) { (error, gamesAtPark) in
            if let error = error {
                self.showAlert(title: "Error fetching parks", message: error.localizedDescription)
            }
            if let gamesAtPark = gamesAtPark {
                self.parkActivity = gamesAtPark.sorted{$0.gameEndTime!.stringToDate() > $1.gameEndTime!.stringToDate()}
            }
        }
    }
    
    @IBAction func recentActivityPressed(_ sender: Any) {
        
    }
    
    @IBAction func messageBoardPressed(_ sender: Any) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
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

extension ParkFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch parkViewFeed {
        case .recentActivity:
            return parkActivity.count
        case .messageBoard:
            return messageBoardPosts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch parkViewFeed {
        case .recentActivity:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityCell", for: indexPath) as? RecentActivityCell else {fatalError()}
            let activity = parkActivity[indexPath.row]
            cell.setupCell(with: activity)
            return cell
        case .messageBoard:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
