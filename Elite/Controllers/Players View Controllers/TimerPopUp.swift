//
//  TimerPopUp.swift
//  Elite
//
//  Created by Leandro Wauters on 6/23/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class TimerPopUp: UIViewController {

    
    @IBOutlet weak var redPlayerImage: CircularRedImageView!
    @IBOutlet weak var bluePlayerImage: CircularBlueImageView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var doneButton: RoundedButton!
    @IBOutlet weak var pauseButton: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    
    @IBOutlet weak var redPlayerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bluePlayerActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var readyView: UIView!
    
    @IBOutlet weak var readyButton: RoundedButton!
    
    @IBOutlet weak var waitingForPlayerLabel: UILabel!
    @IBOutlet weak var waitingForPlayersActivityIndicator: UIActivityIndicatorView!
    


    


    override func viewDidLoad() {
        super.viewDidLoad()
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        waitingForPlayersActivityIndicator.stopAnimating()
        redPlayerActivityIndicator.stopAnimating()
        bluePlayerActivityIndicator.stopAnimating()
    }

    private func sendJoinConfirmation() {
        let action = MultiPeerConnectivityHelper.Action.joinedGame.rawValue
        guard let actionData = action.data(using: .utf8) else {return}
        MultiPeerConnectivityHelper.shared.sendDataToConnectedUsers(data: actionData)
    }

    
    @IBAction func readyButtonPressed(_ sender: Any) {
        readyButton.isHidden = true
        waitingForPlayerLabel.isHidden = false
        sendJoinConfirmation()
        MultiPeerConnectivityHelper.shared.numberOfPlayersJoined += 1
        waitingForPlayersActivityIndicator.isHidden = false
        waitingForPlayersActivityIndicator.startAnimating()
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
    }
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    
    

}
extension TimerPopUp: MultipeerConnectivityDelegate{
    func joinedGame() {
        readyView.isHidden = true
    }
    

    func acceptedInvitation() {
        
    }
    
    func receivedUserData(data: Data) {
        let value = data.withUnsafeBytes {
            $0.load(as: Int.self)
        }
        MultiPeerConnectivityHelper.shared.numberOfPlayersJoined += value
    }
    
    func foundAdverstiser(availableGames: [String]) {
        
    }
    
    func invitationNotification(handler: @escaping (Bool) -> Void) {
        
    }
    
    func connected(to User: String) {
        
    }
    
    
}
//extension TimerPopUp: CountdownDelegate {
//    func timerFinished() {
//        readyView.isHidden = true
//    }
//
//    func timerIsRunning(time: String) {
//
//    }
//
//
//}
