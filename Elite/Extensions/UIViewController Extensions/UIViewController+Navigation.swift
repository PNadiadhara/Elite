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
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            let rootController = UINavigationController.init(rootViewController: loginViewController)
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = rootController
            // present(loginViewController, animated: true)
        }
    }
}

