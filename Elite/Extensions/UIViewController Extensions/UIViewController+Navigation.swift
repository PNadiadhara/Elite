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
        if let _ = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            let loginViewStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
            if let loginViewController = loginViewStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
