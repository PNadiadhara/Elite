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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupImage()
        setupAlertView()
        // Do any additional setup after loading the view.
    }
    func setupLabel() {
        invitationLabel.text = "\(invitation.senderUsername) invited you to play \(invitation.game)"
    }
    func setupImage() {
        
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
            let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
            oneVsoneProgressVc.modalPresentationStyle = .fullScreen
            oneVsoneProgressVc.invitation = invitation
            oneVsoneProgressVc.isHost = false
            present(oneVsoneProgressVc, animated: true)
        }
        
        if invitation.gameType == GameType.twoVsTwo.rawValue {
            let twoVsTwoProgressVc = TwoVsTwoProgressViewController.init(nibName: "TwoVsTwoProgressViewController", bundle: nil)
            twoVsTwoProgressVc.modalPresentationStyle = .fullScreen
            twoVsTwoProgressVc.invitation = invitation
            twoVsTwoProgressVc.isHost = false
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
