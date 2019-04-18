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
    
    var invitation: Invitation!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupImage()
        // Do any additional setup after loading the view.
    }
    func setupLabel() {
        invitationLabel.text = "\(invitation.senderUsername) invited you to play \(invitation.game)"
    }
    func setupImage() {
        
    }
    @IBAction func acceptPressed(_ sender: UIButton) {
        let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
        oneVsoneProgressVc.modalPresentationStyle = .fullScreen
        oneVsoneProgressVc.invitation = invitation
        oneVsoneProgressVc.isHost = false
        DBService.updateInvitationApprovalToTrue(invitation: invitation!, completion: { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
        present(oneVsoneProgressVc, animated: true)
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
