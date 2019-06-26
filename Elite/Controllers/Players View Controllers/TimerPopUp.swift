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
        setupUI()
        MainTimer.shared.delegate = self
        MultiPeerConnectivityHelper.shared.timerDelegate = self
    }
    
    private func setupUI() {
        waitingForPlayersActivityIndicator.stopAnimating()
        redPlayerActivityIndicator.stopAnimating()
        bluePlayerActivityIndicator.stopAnimating()
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 65, weight: .light)
    }

    private func sendJoinConfirmation() {
        MultiPeerConnectivityHelper.shared.numberOfPlayersJoined += 1
        let action = MultiPeerConnectivityHelper.Action.joinedGame.rawValue
        let dataToSend = DataToSend(action: action, data: nil)
        MultiPeerConnectivityHelper.shared.convertDataToSendToDataAndSend(dataToSend: dataToSend)
    }
    

    
    @IBAction func readyButtonPressed(_ sender: Any) {
        readyButton.isHidden = true
        waitingForPlayerLabel.isHidden = false
        sendJoinConfirmation()
        waitingForPlayersActivityIndicator.isHidden = false
        waitingForPlayersActivityIndicator.startAnimating()
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        confirmAlert(title: "Finish Game", message: "Are you sure?") { (done) in
            //TO DO SEGUE TO NEXT VC AND FINISH THE GAME ON THE OPPONENT
        }
    }
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
        switch MultiPeerConnectivityHelper.shared.buttonStatus {
        case .Pause:
            pauseButton.setTitle("Play", for: .normal)
            let pauseSharedTimerAction = MultiPeerConnectivityHelper.Action.pauseSharedTimer.rawValue
            MainTimer.shared.timerManager(action: pauseSharedTimerAction)
            MainTimer.shared.pauseTime()
            MultiPeerConnectivityHelper.shared.buttonStatus = MultiPeerConnectivityHelper.ButtonStatus.Play
        case .Play:
            pauseButton.setTitle("Pause", for: .normal)
            let resumeSharedTimerAction = MultiPeerConnectivityHelper.Action.resumeSharedTimer.rawValue
            MainTimer.shared.timerManager(action: resumeSharedTimerAction)
            MainTimer.shared.resume()
            MultiPeerConnectivityHelper.shared.buttonStatus = MultiPeerConnectivityHelper.ButtonStatus.Pause
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    
    

}
extension TimerPopUp: MultipeerConnectivityDelegate{
    func joinedGame() {
        readyView.isHidden = true
        if MultiPeerConnectivityHelper.shared.role == .Host {
            MainTimer.shared.runTimer()
            let startSharedTimerAction = MultiPeerConnectivityHelper.Action.startedTimer.rawValue
            MainTimer.shared.timerManager(action: startSharedTimerAction)
        }         
    }
    

    func acceptedInvitation() {
        
    }
    
    func receivedUserData(data: Data) {

    }
    
    func foundAdverstiser(availableGames: [String]) {
        
    }
    
    func invitationNotification(handler: @escaping (Bool) -> Void) {
        
    }
    
    func connected(to User: String) {
        
    }
    
    
}

extension TimerPopUp: TimerDelegate {
    
    func sharedTimer(time: String) {
        DispatchQueue.main.async {
            self.timerLabel.text = time
        }
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
