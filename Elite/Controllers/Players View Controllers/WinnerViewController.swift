//
//  WinnerViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class WinnerViewController: UIViewController {
    
    var invitation: Invitation!
    var game: GameModel!
    var winnerConfirmationId = String()
    var currentPlayer: CurrentPlayer?
    
    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var winnerTitle: UILabel!
    @IBOutlet weak var playersImage: CircularImageView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWinner()
        continueButton.isHidden = true
//        blurView()
        // Do any additional setup after loading the view.
    }

    func blurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
    }
    @IBAction func continuePressed(_ sender: UIButton) {
        DBService.deleteWinningConfirmation(winningConfirmationId: winnerConfirmationId) { (error) in
            if let error = error{
                print(error)
            }
        }
        if let currentPlayer = currentPlayer{
            DBService.deleteCurrentPlayer(currentPlayer: currentPlayer) { (error) in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    func animateView(winnerTeam: String) {
        UIView.transition(with: winnerView, duration: 1, options: [.transitionFlipFromRight], animations: {
            self.winnerTitle.isHidden = false
            self.winnerTitle.text = "\(winnerTeam) team won!"
            self.playersImage.isHidden = false
            self.continueButton.isHidden = false
            self.activityIndicator.isHidden = true
            self.loadingLabel.isHidden = true
        })
//        UIView.transition(with: cat, duration: 1.0, options: [.transitionFlipFromRight], animations: {
//            self.cat.setImage(UIImage(named: "dog"), for: .normal)
//        })
    }
    func fetchWinner() {
        DBService.fetchWinningConfirmations(gameId: invitation.gameId) { (error, winnerConfirmation) in
            if let error = error {
                print(error)
            }
            if let winnerConfirmation = winnerConfirmation{
                WinnerConfirmation.calculateWinner(winnerConfirmation: winnerConfirmation, completion: { (winningTeam, noWinner, totalcount) in
                    
                    if let totalcount = totalcount {
                        switch self.game.gameType{
                        case GameType.oneVsOne.rawValue:
                            if totalcount == 2 {
                                if let winningTeam = winningTeam {
                                    switch winningTeam {
                                    case .blue:
                                        self.animateView(winnerTeam: Teams.blue.rawValue)
                                    case .red:
                                        self.animateView(winnerTeam: Teams.red.rawValue)
                                    }
                                }
                                if noWinner != nil {
                                    self.winnerTitle.text = "No winner"
                                }
                            }
                        case GameType.twoVsTwo.rawValue:
                            if totalcount == 4 {
                                if let winningTeam = winningTeam {
                                    switch winningTeam {
                                    case .blue:
                                        self.animateView(winnerTeam: Teams.blue.rawValue)
                                    case .red:
                                        self.animateView(winnerTeam: Teams.red.rawValue)
                                    }
                                    if noWinner != nil {
                                        self.winnerTitle.text = "No winner"
                                    }
                                }
                            }
                        case GameType.fiveVsFive.rawValue:
                            if totalcount == 10 {
                                print("Have all the votes")
                            }
                        default:
                            print("NO GAME TYPE")
                        }
                        
                    }

                })
            }
        }
    }


}
