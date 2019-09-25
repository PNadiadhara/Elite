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
    
    weak var gamer: GamerModel!
    weak var invitationDelegate: InvitationAlertDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabel()
    }
    
    func setupLabel() {
        invitationLabel.text = "\(gamer.username) wants to join"
    }

    @IBAction func acceptPressed(_ sender: UIButton) {
            invitationDelegate?.acceptPressed()
        }
//
    @IBAction func declinePressed(_ sender: UIButton) {
        invitationDelegate?.declinePress()
        dismiss(animated: true)
    }
    
}
