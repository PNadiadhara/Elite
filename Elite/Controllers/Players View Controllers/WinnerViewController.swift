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
    var winnerTeam: Teams!
    var loserTeam: Teams!
    var winnerPlayers = [String]()
    var loserPlayers = [String]()
    var gameDuration = String()
    var isHost = Bool()
    var isTie = false

    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var winnerTitle: UILabel!
    @IBOutlet weak var playersImage: CircularImageView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var userResultLabel: UILabel!
    
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
    func fetchWinnerPlayers(game:GameModel) -> [String]{
        if winnerTeam == .blueTeam {
            return game.blueTeam
        }
        if winnerTeam == .redTeam {
            return game.redTeam
        }
        return [String]()
    }
    func fetchLoserPlayers(game:GameModel) -> [String] {
        if loserTeam == .blueTeam {
            return game.blueTeam
        }
        if loserTeam == .redTeam {
            return game.redTeam
        }
        return [String]()
    }
    @IBAction func continuePressed(_ sender: UIButton) {
        let game = GameModel(gameName: self.game.gameName, gameType: self.game.gameType, numberOfPlayers: self.game.numberOfGamers, redTeam: self.game.redTeam, blueTeam: self.game.blueTeam, parkId: self.game.parkId, gameDescription: "Good Game", gameEndTime: Date.getISOTimestamp(), winners: winnerPlayers, losers: loserPlayers, isTie: isTie, formattedAdresss: self.game.formattedAdresss, parkName: self.game.parkName, lat: self.game.lat, lon: self.game.lon, gameID: self.game.gameID, witness: nil, duration: gameDuration , isOver: nil, wasCancelled: nil)
        if isHost{
        DBService.updateGameModel(game: game) { (error) in
            if let error = error {
                print(error)
            } else {
                print("Game updated")
            }
        }
        }
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
//        let rankChangeController = RankChangeController.init(nibName: "RankChangeController", bundle: nil)
//        present(rankChangeController, animated: true)
        
    }
    func animateView(winnerTeam: Teams) {
        UIView.transition(with: winnerView, duration: 1, options: [.transitionFlipFromRight], animations: {
            self.winnerPlayers = self.fetchWinnerPlayers(game: self.game)
            self.loserPlayers = self.fetchLoserPlayers(game: self.game)
            self.winnerTitle.isHidden = false
            self.userResultLabel.isHidden = false
            if winnerTeam == .redTeam{
              self.winnerTitle.text = "Red team won!"
            }
            if winnerTeam == .blueTeam {
                self.winnerTitle.text = "Blue team won!"
            }
            if self.winnerPlayers.contains(TabBarViewController.currentGamer.gamerID) {
                self.userResultLabel.text = "You won!"
                self.playersImage.image = UIImage(named: TabBarViewController.currentGamer.username + "Winner")
            } else {
                self.userResultLabel.text = "You lost"
                self.playersImage.image = UIImage(named: TabBarViewController.currentGamer.username + "Loser")
            }
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
                                    case .blueTeam:
                                        self.animateView(winnerTeam: Teams.blueTeam.rawValue)
                                        self.winnerTeam = .blueTeam
                                        self.loserTeam = .redTeam
                                    case .redTeam:
                                        self.animateView(winnerTeam: Teams.redTeam.rawValue)
                                        self.winnerTeam = .redTeam
                                        self.loserTeam = .blueTeam
                                        self.winnerTeam = .blueTeam
                                        self.loserTeam = .redTeam
                                        self.animateView(winnerTeam: Teams.blueTeam)
                                    case .redTeam:
                                        self.winnerTeam = .redTeam
                                        self.loserTeam = .blueTeam
                                        self.animateView(winnerTeam: Teams.redTeam)
                                        
                                    }

                                }
                                if noWinner != nil {
                                    self.winnerTitle.text = "No winner"
                                    self.isTie = true
                                }
                                self.winnerPlayers = self.fetchWinnerPlayers(game: self.game)
                                self.loserPlayers = self.fetchLoserPlayers(game: self.game)
                            }
                        case GameType.twoVsTwo.rawValue:
                            if totalcount == 4 {
                                if let winningTeam = winningTeam {
                                    switch winningTeam {
                                    case .blueTeam:
                                        self.animateView(winnerTeam: Teams.blueTeam.rawValue)
                                        self.winnerTeam = .blueTeam
                                    case .redTeam:
                                        self.animateView(winnerTeam: Teams.redTeam.rawValue)

                                        self.animateView(winnerTeam: Teams.blueTeam)
                                        self.winnerTeam = .blueTeam
                                    case .redTeam:
                                        self.animateView(winnerTeam: Teams.redTeam)
                                        self.winnerTeam = .redTeam
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
