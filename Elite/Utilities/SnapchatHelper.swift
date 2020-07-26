//
//  SnapchatHelper.swift
//  Elite
//
//  Created by Leandro Wauters on 1/28/20.
//  Copyright © 2020 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import SCSDKLoginKit

protocol SnapchatDelegate: AnyObject {
    func snapchatAvatarFound()
}

class SnapchatHelper {
    
    public var delegate: SnapchatDelegate?
    
    public func getSnapchatAvatar(viewController: UIViewController) {
        SCSDKLoginClient.login(from: viewController) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if success {
                print("Logged In")
            }
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SCSDKLoginClient.application(app, open: url, options: options)
    }

}
