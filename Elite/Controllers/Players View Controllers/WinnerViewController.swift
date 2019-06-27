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
    
    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var winnerTitle: UILabel!
    @IBOutlet weak var playersImage: CircularImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var userResultLabel: UILabel!
    @IBOutlet weak var reportUser: UIButton!
    @IBOutlet weak var retryButton: RoundedButton!
    @IBOutlet weak var continueButton: RoundedButton!
    
    
    override func viewDidLoad() {
       MultiPeerConnectivityHelper.shared.multipeerActionHandlerDelegate = self
        super.viewDidLoad()
        confettiView = SAConfettiView(frame: view.bounds)
        setupConfetti()

//        demoBugPrevention()
//        blurView()
        // Do any additional setup after loading the view.
    }
    

    func setupConfetti(){
        self.view.addSubview(confettiView)
        view.sendSubviewToBack(confettiView)
        confettiView.type = .Confetti
        confettiView.intensity = 0.80
        setupUI()
    }
//    func demoBugPrevention() {
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
//            self.winnerTeam = .redTeam
//            self.animateView(winnerTeam: Teams.redTeam)
//        }
//    }
    func blurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
    }
    
    func setupUI() {
        if !isTie {
            guard let winner = winner,
            let loser = loser else {return}
            if winner.username == TabBarViewController.currentGamer.username {
                confettiView.startConfetti()
                winnerTitle.text = "Congratulations \(winner.username)"
                userResultLabel.text = "You won!!!"
                continueButton.isHidden = false
            } else {
                winnerTitle.text = "Sorry \(loser.username)"
                userResultLabel.text = "You lost"
                retryButton.isHidden = false
                confirmButton.isHidden = false
                
            }
        } else {
            winnerTitle.text = "Players chose different winners"
            userResultLabel.text = "Try again? or Report?"
            reportUser.isHidden = false
        }
    }
    
    func retryGame() {
        dismiss(animated: true)
        actionHandlerDelegate?.userPressedRetry()

    }
    
    func sendRetryAction() {
        let action = MultiPeerConnectivityHelper.Action.retryWinnerVote.rawValue
        let dataToSend = DataToSend(action: action, data: nil, team: nil)
        MultiPeerConnectivityHelper.shared.convertDataToSendToDataAndSend(dataToSend: dataToSend)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let parkRankingInfoEndGame = ParkRankingInfoEndGameViewController()
    
    }
    
    @IBAction func retryButtonPressed(_ sender: Any) {
        sendRetryAction()
        retryGame()
    }
    
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        // TO DO: Let the user know that confirming the game will be null

        

//        let rankingChangeViewController = RankingChangeViewController.init(nibName: "RankingChangeViewController", bundle: nil)
//        present(rankingChangeViewController, animated: true)
//
    }
//   func animateView(winnerTeam: Teams) {
//        UIView.transition(with: winnerView, duration: 1, options: [.transitionFlipFromRight], animations: {
//
//            self.winnerPlayers = self.fetchWinnerPlayers(game: self.game)
//            self.loserPlayers = self.fetchLoserPlayers(game: self.game)
//            self.winnerTitle.isHidden = false
//            self.userResultLabel.isHidden = false
//            if winnerTeam == .redTeam{
//              self.winnerTitle.text = "Red team won!"
//            }
//            if winnerTeam == .blueTeam {
//                self.winnerTitle.text = "Blue team won!"
//            }
//            if self.winnerPlayers.contains(TabBarViewController.currentGamer.gamerID) {
//                self.confettiView.startConfetti()
//                self.userResultLabel.text = "You won!"
////                self.cheerView.start()
//                self.playersImage.image = UIImage(named: TabBarViewController.currentGamer.username + "Winner")
//            } else {
//                self.userResultLabel.text = "You lost"
//                self.playersImage.image = UIImage(named: TabBarViewController.currentGamer.username + "Loser")
//            }
//            self.playersImage.isHidden = false
//            self.continueButton.isHidden = false
//            self.activityIndicator.isHidden = true
//            self.loadingLabel.isHidden = true
//        })
////        UIView.transition(with: cat, duration: 1.0, options: [.transitionFlipFromRight], animations: {
////            self.cat.setImage(UIImage(named: "dog"), for: .normal)
////        })
//    }


}

extension WinnerViewController: MultipeerConnectivityActionHandlerDelegate {
    func userDidQuitGame() {
        
    }
    
    func userPressedRetry() {
        invitationAlert(title: "Opponent wants to retry voting", message: "Accept") { (action) in
            if action.title == "Yes" {
                self.retryGame()
            } else {
                //TO DO:
                //show alert asking to report
                // move to next vc
            }
        }
    }
    
    
}
