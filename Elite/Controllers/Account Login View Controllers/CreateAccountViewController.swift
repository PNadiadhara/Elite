//
//  CreateAccountViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var authservice = AppDelegate.authservice
    
    
    var keyboardHeight = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    authservice.authserviceCreateNewAccountDelegate = self
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let userName = usernameTextField.text,
            !email.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !userName.isEmpty
                else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required")
                return
        }
        if password != confirmPassword {
            showAlert(title: "Passwords do not match", message: "Try again")
        } else {
            authservice.createNewAccount(email: email, password: password, firstName: firstName, lastName: lastName, username: userName)
        }

    }
    @IBAction func existingUserBttnPressed(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func willShowKeyboard(notification: Notification){
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                print("UserInfo is nil")
                return
        }
        keyboardHeight = keyboardFrame.height
        print(keyboardHeight)
            conteinerView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 250)
    }
    @objc private func willHideKeyboard(){
        conteinerView.transform = CGAffineTransform.identity
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    private func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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
        let tab = TabBarViewController.setTabBarVC()
        present(tab, animated: true)
    }
    
}
extension CreateAccountViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField.text == "\n" {
//            textField.resignFirstResponder()
//            return true
//        }
        textField.resignFirstResponder()
        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        switch textField.tag {
//        case 0,1,2,3:
//        conteinerView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
//        default:
//            return
//        }
//
//    }

}
