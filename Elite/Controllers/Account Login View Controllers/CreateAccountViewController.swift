//
//  CreateAccountViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var createAccountTitle: UILabel!
    @IBOutlet weak var createNewUserBttn: RoundedButton!
    
    @IBOutlet weak var existingUserBttn: UIButton!
    private var authservice = AppDelegate.authservice
    
    
    var keyboardHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOutletsDelegates()
        setViewControllerSettings()
        setupGradient()
        setupTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    
    private func setOutletsDelegates(){
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func setViewControllerSettings(){
        setupTap()
        authservice.authserviceCreateNewAccountDelegate = self
        existingUserBttn.layer.cornerRadius = 5
    }
    private func setupGradient(){
        view.setGradientFromRightToLeft(colorOne: UIColor.black, colorTwo: UIColor.lightGrey)
        createNewUserBttn.setGradientFromUpperLeftToBottmRight(colorOne: .eliteGold, colorTwo: .eliteGold2)
        conteinerView.setGradientFromRightToLeft(colorOne: UIColor.black, colorTwo: UIColor.lightGrey)
        createAccountTitle.textColor = .gold
    }
    private func createNewUser(){
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !email.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty
            else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required")
                return
        }
        if password != confirmPassword {
            showAlert(title: "Passwords do not match", message: "Try again")
        } else {
            
            authservice.createNewAccount(email: email, password: password, firstName: firstName, lastName: lastName, deviceName: UIDevice.current.name)
        }
        
    }
    
    private func goBackToPreviousVC(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        createNewUser()
    }
    
    @IBAction func existingUserBttnPressed(_ sender: UIButton){
        goBackToPreviousVC()
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
        let createYourEliteVC = CreateYourEliteViewController()
        navigationController?.pushViewController(createYourEliteVC, animated: true)
    }
    
}
extension CreateAccountViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
