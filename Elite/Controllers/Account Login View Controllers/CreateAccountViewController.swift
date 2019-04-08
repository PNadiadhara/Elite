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
    private var authservice = AppDelegate.authservice
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authservice.authserviceCreateNewAccountDelegate = self
    }
 
    @IBAction func createButtonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                return
        }
        authservice.createNewAccount(username: username, email: email, password: password)
    }
    
    @IBAction func showLoginView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateAccountViewController : AuthServiceCreateNewAccountDelegate {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    func didCreateNewAccount(_ authservice: AuthService, user gamer: GamerModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        mainTabBarController.modalTransitionStyle = .crossDissolve
        mainTabBarController.modalPresentationStyle = .overFullScreen
        present(mainTabBarController, animated: true)
    }
    
}
