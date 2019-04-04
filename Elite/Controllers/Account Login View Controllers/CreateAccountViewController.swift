//
//  CreateAccountViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func facebookButtonPressed(_ sender: RoundedButton) {
    }
    
    @IBAction func gmailButtonPressed(_ sender: RoundedButton) {
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func showLoginView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
