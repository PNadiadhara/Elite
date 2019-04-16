//
//  LoginViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var authservice = AppDelegate.authservice
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        authservice.authserviceExistingAccountDelegate = self
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
        
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                return
        }
        authservice.signInExistingAccount(email: email, password: password)
    }
    
    @IBAction func facebookButtonPressed(_ sender: RoundedButton) {
    }
}




extension LoginViewController : AuthServiceExistingAccountDelegate {
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        mainTabBarController.modalTransitionStyle = .crossDissolve
        mainTabBarController.modalPresentationStyle = .overFullScreen
        present(mainTabBarController, animated: true)
        
    }
    
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
        func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
            showAlert(title: "Signin Error", message: error.localizedDescription)
        }
    }
}
