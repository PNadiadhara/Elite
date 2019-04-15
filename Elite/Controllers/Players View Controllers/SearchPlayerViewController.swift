//
//  SearchPlayerViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/11/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class SearchPlayerViewController: UIViewController {
    
    @IBOutlet weak var friendSearchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.register(UINib(nibName: "UserFeedCell", bundle: nil), forCellReuseIdentifier: "UserFeedCell")
        // Do any additional setup after loading the view.
    }
    @IBAction func friendsPressed(_ sender: UIButton) {
    }
    @IBAction func scanCodePressed(_ sender: UIButton) {
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    



}

extension SearchPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {return UITableViewCell()}
        cell.userText.text = "@Ibrahim"
        tableView.separatorStyle = .none
        cell.userText.font = Constants.getHelveticaNeue(size: 25, type: "Regular")
        cell.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        cell.userImage.image = UIImage(named: "ibraheem")
        cell.trophyImage.image = UIImage(named: "GoldMedal")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
