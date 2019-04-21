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
    @IBOutlet weak var winnerTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWinner()
        // Do any additional setup after loading the view.
    }

    @IBAction func continuePressed(_ sender: UIButton) {
        DBService.deleteWinningConfirmation(winningConfirmationId: winnerConfirmationId) { (error) in
            if let error = error{
                print(error)
            }
        }
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
                                print("Have all the votes")
                            }
                        case GameType.twoVsTwo.rawValue:
                            if totalcount == 4 {
                                print("Have all the votes")
                            }
                        case GameType.fiveVsFive.rawValue:
                            if totalcount == 10 {
                                print("Have all the votes")
                            }
                        default:
                            print("NO GAME TYPE")
                        }
                        
                    }
                    if let winningTeam = winningTeam {
                        switch winningTeam {
                        case .blue:
                            self.winnerTitle.text = "Blue team won!"
                        case .red:
                            self.winnerTitle.text = "Red team won!"
                        }
                    }
                    if noWinner != nil {
                        self.winnerTitle.text = "No winner"
                    }
                })
            }
        }
    }


}
