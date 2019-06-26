//
//  InvitationAlertViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/17/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

protocol InvitationAlertDelegate: AnyObject {
    func acceptPressed()
    func declinePress()
}
class InvitationAlertViewController: UIViewController {
    @IBOutlet weak var invitationLabel: UILabel!
    @IBOutlet weak var userImage: CircularBlueImageView!
    @IBOutlet weak var alertView: UIView!
    
    var invitation: Invitation!
    var gamer: GamerModel?
    var bluePlayerOne: GamerModel!
    var redPlayerOne: GamerModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupLabel()
//        setupImage()
        setupAlertView()
        // Do any additional setup after loading the view.
    }
    func setupLabel() {
        invitationLabel.text = "\(invitation.senderUsername) invited you to play \(invitation.game)"
    }
//    func setupImage() {
//        guard let gamer = gamer else {
//            print("No gamer")
//            return
//        }
//
//    }
    func fetchUser() {
        DBService.fetchGamer(gamerID: invitation.sender) { (error, gamer) in
            if let error = error {
                self.showAlert(title: "Error fetching gamer", message: error.localizedDescription)
            }
            if let gamer = gamer {
                self.userImage.image = UIImage(named: gamer.username + "Hi")
                self.redPlayerOne = gamer
            }
        }
        DBService.fetchGamer(gamerID: invitation.reciever) { (error, gamer) in
            if let error = error {
                self.showAlert(title: "Error fetching gamer", message: error.localizedDescription)
            }
            if let gamer = gamer {
                self.bluePlayerOne = gamer
            }
        }
    }
    func setupAlertView() {
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 1
        alertView.layer.shadowOffset = CGSize.zero
        alertView.layer.shadowRadius = 10
        alertView.layer.shadowPath = UIBezierPath(rect: alertView.bounds).cgPath
    }
    @IBAction func acceptPressed(_ sender: UIButton) {
        DBService.updateInvitationApprovalToTrue(invitation: invitation!, completion: { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
        if invitation.gameType == GameType.oneVsOne.rawValue {
//            let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
//            oneVsoneProgressVc.modalPresentationStyle = .fullScreen
//            oneVsoneProgressVc.invitation = invitation
//            oneVsoneProgressVc.isHost = false
//            oneVsoneProgressVc.gameType = .oneVsOne
//            oneVsoneProgressVc.blueOnePlayer = bluePlayerOne
//            oneVsoneProgressVc.redOnePlayer = redPlayerOne
//            present(oneVsoneProgressVc, animated: true)
        }
        
        if invitation.gameType == GameType.twoVsTwo.rawValue {
            let twoVsTwoProgressVc = TwoVsTwoProgressViewController.init(nibName: "TwoVsTwoProgressViewController", bundle: nil)
            twoVsTwoProgressVc.modalPresentationStyle = .fullScreen
            twoVsTwoProgressVc.invitation = invitation
            twoVsTwoProgressVc.isHost = false
            twoVsTwoProgressVc.gameType = .twoVsTwo
            present(twoVsTwoProgressVc, animated: true)
        }


        
    }
    
    @IBAction func declinePressed(_ sender: UIButton) {
        DBService.deleteInvitation(invitation: invitation, completion: { (error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("Invitation deleted")
            }
        })
        dismiss(animated: true)
    }
    
}
