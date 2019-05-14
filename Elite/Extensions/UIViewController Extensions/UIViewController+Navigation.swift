//
//  UIViewController+Navigation.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showLoginView() {
        let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(loginViewController, animated: true)
    }
}
