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
    
    @IBOutlet weak var logoView: CircularImageView!
    private var authservice = AppDelegate.authservice
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginBttn: RoundedButton!
    @IBOutlet weak var loginWithFBBttn: RoundedButton!
    @IBOutlet weak var newUserBttn: UIButton!
    @IBOutlet weak var loginViewTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupVCSettings()
        setupTap()
    }
    
    private func setupVCSettings(){
        navigationController?.isNavigationBarHidden = true
        authservice.authserviceExistingAccountDelegate = self
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        loginWithFBBttn.isHidden = true 
    }
    
    private func setupOutlets(){
        setupBttnUI()
        setupTxtField()
        setupViewGradient()
    }
    
    private func setupBttnUI(){
        newUserBttn.layer.cornerRadius = 5
        loginBttn.setTitleColor(.white, for: .normal)
        loginViewTitle.textColor = .gold
    }
    
    private func setupViewGradient(){
        view.setGradientFromRightToLeft(colorOne: UIColor.black, colorTwo: UIColor.lightGrey)
        loginBttn.setGradientFromUpperLeftToBottmRight(colorOne: .eliteGold, colorTwo: .eliteGold2)
        loginWithFBBttn.setGradientFromBottomLeftToUpperRight(colorOne: .fbMessenger, colorTwo: .fbMessenger2)
        
        
    }
    
    private func setupTxtField(){
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    private func switchVCView(){
        let loginScreenSB = UIStoryboard(name: "LoginView", bundle: nil)
        let createAnAccountVC = loginScreenSB.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        navigationController?.pushViewController(createAnAccountVC, animated: true)
    }
    
    private func signInCurrentUser(){
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                showAlert(title: "Please enter information", message: "ex: yourmail@email.com")
                return
        }
        authservice.signInExistingAccount(email: email, password: password)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
    }
    

    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    

    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        signInCurrentUser()
    }
    
    @IBAction func facebookButtonPressed(_ sender: RoundedButton) {
    }
    
    @IBAction func switchToCreateAccountVC(_ sender: UIButton){
        switchVCView()
    }
}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension LoginViewController : AuthServiceExistingAccountDelegate {
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        let tab = TabBarViewController.setTabBarVC()
        navigationController?.pushViewController(tab, animated: true)
        
    }
    
        func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
            showAlert(title: "Signin Error", message: error.localizedDescription)
        }
    
}
