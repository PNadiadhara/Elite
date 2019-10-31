//
//  WinnerViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import SAConfettiView

class WinnerViewController: UIViewController {
    
    



    public var winner: GamerModel?
    public var loser: GamerModel?
    public var isTie = Bool()
    private var confettiView = SAConfettiView()
    weak var actionHandlerDelegate: MultipeerConnectivityActionHandlerDelegate?
//    var parkId = String()
    

    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var tieView: UIView!

    @IBOutlet weak var playersImage: CircularImageView!

    @IBOutlet weak var userResultLabel: UILabel!
    @IBOutlet weak var reportUser: UIButton!

    @IBOutlet weak var continueButton: RoundedButton!
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
         hostUpdateGameModelToFireBase()
//        fetchParkId()


    }
    




    
    func hostUpdateGameModelToFireBase(){
        DBService.updateGamesByLocation(parkId: GameModel.parkId ?? "Error", sport: GameModel.gameName!)
        if MultiPeerConnectivityHelper.shared.role == .Host {
//            MultiPeerConnectivityHelper.shared.sendParkID(parkId: GameModel.parkId ?? "") {
                let timeStamp = Date.getISOTimestamp()
                let gameDuration = MainTimer.shared.timeString(time: MainTimer.totalTime)
                GameModel.updateGameModel(gameEndTime: timeStamp.formatISODateString(dateFormat: "MMM d, yyyy hh:mm a"), winners: [winner!.gamerID], losers: [loser!.gamerID], duration: gameDuration) {
                    guard let game = GameModel.game else {
                        print("Game is nil")
                        return
                    }
                    DBService.postGame(gamePost: game, completion: { (error) in
                        if let error = error {
                            self.showAlert(title: "Error sending game to Firebase", message: error.localizedDescription)
                            
                        } 
                        
                        
                    })
                }
//                MultiPeerConnectivityHelper.shared.endSession()
            
//        }
        }
    }
    
    func setupUI() {
        confettiView = SAConfettiView(frame: view.bounds)
        setupConfetti(confettiView: confettiView, intensity: 0.80)
        if !isTie {
            guard let winner = winner else {return}
            if winner.username == TabBarViewController.currentGamer.username {
                confettiView.startConfetti()
                userResultLabel.text = "You won!"
                continueButton.isHidden = false
                playersImage.image = UIImage(named: "winner")
            } else {
                userResultLabel.text = "You lost"
                continueButton.isHidden = false
                playersImage.image = UIImage(named: "loser")
            }
        } else {
            tieView.isHidden = false
        }
    }
    

    func segueToLeaderBoard() {
        let parkRankingInfoEndGame = ParkRankingInfoEndGameViewController()
        self.navigationController?.pushViewController(parkRankingInfoEndGame, animated: true)
    }
    

    
    @IBAction func continueButtonPressed(_ sender: Any) {

        segueToLeaderBoard()

    }



}




