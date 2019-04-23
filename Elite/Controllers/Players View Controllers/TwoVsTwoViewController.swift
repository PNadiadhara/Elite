//
//  TwoVsTwoViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

protocol twoVsTwoSearchDelegate: AnyObject {
    func redTwoPlayer(redTwoPlayer: GamerModel?)
    func blueOnePlayer(blueOnePlayer: GamerModel?)
    func blueTwoPlayer(blueTwoPlayer: GamerModel?)
}
class TwoVsTwoViewController: UIViewController {

    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var redPlayerOneImage: CircularRedImageView!
    @IBOutlet weak var redPlayerOneLabel: UILabel!
    @IBOutlet weak var redPlayerTwoImage: CircularRedImageView!
    @IBOutlet weak var redPlayerTwoLabel: UILabel!
    @IBOutlet weak var bluePlayerOneImage: CircularBlueImageView!
    @IBOutlet weak var bluePlayerOneLabel: UILabel!
    @IBOutlet weak var bluePlayerTwoImage: CircularBlueImageView!
    @IBOutlet weak var bluePlayerTwoLabel: UILabel!
    @IBOutlet weak var redPlayerTwoButton: UIButton!
    @IBOutlet weak var bluePlayerOneButton: UIButton!
    @IBOutlet weak var bluePlayerTwoButton: UIButton!
    
    
    
    
    
    var redTwoPlayer: GamerModel?
    var blueOnePlayer: GamerModel?
    var blueTwoPlayer: GamerModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        redPlayerOneLabel.text = TabBarViewController.currentUser.displayName
        if let redTwoPlayer = redTwoPlayer{
            redPlayerTwoLabel.text = redTwoPlayer.username
        }
        if let blueOnePlayer = blueOnePlayer {
           bluePlayerOneLabel.text = blueOnePlayer.username
        }
        if let blueTwoPlayer = blueTwoPlayer {
           bluePlayerTwoLabel.text = blueTwoPlayer.username
        }
        
    }
    @IBAction func addPlayerPressed(_ sender: UIButton) {
        let searchPlayerVc = SearchPlayerViewController.init(nibName: "SearchPlayerViewController", bundle: nil)
        searchPlayerVc.modalPresentationStyle = .fullScreen
        searchPlayerVc.twoVsTwoSearchDelegate = self
        searchPlayerVc.gameType = .twoVsTwo
        switch sender.tag {
        case 0:
            searchPlayerVc.teamRole = .redTwo
        case 1:
            searchPlayerVc.teamRole = .blueOne
        case 2:
            searchPlayerVc.teamRole = .blueTwo
            
        default:
            return
            
        }
        
        present(searchPlayerVc, animated: true)
        
    }

    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension TwoVsTwoViewController: twoVsTwoSearchDelegate {
    func redTwoPlayer(redTwoPlayer: GamerModel?) {
        self.redTwoPlayer = redTwoPlayer
    }
    
    func blueOnePlayer(blueOnePlayer: GamerModel?) {
        self.blueOnePlayer = blueOnePlayer
        
    }
    
    func blueTwoPlayer(blueTwoPlayer: GamerModel?) {
        self.blueTwoPlayer = blueTwoPlayer
    }
    
    
}
