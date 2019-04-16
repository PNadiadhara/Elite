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
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var searchDelegate: SearchForPlayerDelegate!
    var gamers = [GamerModel](){
        didSet {
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.separatorStyle = .none
        searchBar.delegate = self
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
    func searchForPlayers(gamer: String){
        DBService.fetchAllGamers { (error, gamers) in
            if let error = error {
                self.showAlert(title: "Error fetching bloggers", message: error.localizedDescription)
            }
            if let gamers = gamers{
                self.gamers = gamers.filter{$0.username.lowercased().contains(gamer.lowercased())
                }
            }
        }
    }



}

extension SearchPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {return UITableViewCell()}
        let gamerToSet = gamers[indexPath.row]
        cell.userText.text = gamerToSet.username
        cell.userText.font = Constants.getHelveticaNeue(size: 25, type: "Regular")
        cell.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = AppDelegate.authservice.getCurrentUser() else {return}
        let gamer = gamers[indexPath.row]
        let invitation = Invitation(invitationId: "", sender: user.uid, reciever: gamer.gamerID, message: "Invitation", approval: false)
        DBService.postInvitation(invitation: invitation) { (error) in
            print("Error posting message")
        }
        searchDelegate.gamerSelected(gamer: gamer)
        searchDelegate.invitationCreated(invitation: invitation)
        dismiss(animated: true)
    }
}

extension SearchPlayerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForPlayers(gamer: searchText)
    }
}
