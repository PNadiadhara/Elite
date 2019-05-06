//
//  SnapchatLoginViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import SCSDKBitmojiKit
class SnapchatLoginViewController: UIViewController {
    let snapchatView = SnapchatView()
    let iconView = SCSDKBitmojiIconView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view = snapchatView.contentView
       callButtons()
        
        
    }
    
    private func addTargets(){
        snapchatView.loginBttn.addTarget(self, action: #selector(login), for: .touchUpInside)
        snapchatView.cancelBttn.addTarget(self, action: #selector(cancelView), for: .touchUpInside)
    }
    private func callButtons(){
        login()
        cancelView()
    }
    @objc private func login(){
        SCSDKLoginClient.login(from: self) { success, error in
            if let error = error {
                
            }
            if success {
                self.fetchSnapUserInfo()
            }
        }
    }
    private func fetchSnapUserInfo() {
        let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
        
        SCSDKLoginClient
            .fetchUserData(
                withQuery: graphQLQuery,
                variables: nil,
                success: { userInfo in
                    
                    if let userInfo = userInfo,
                        let data = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
                        let userEntity = try? JSONDecoder().decode(UserEntity.self, from: data) {
                        
                        DispatchQueue.main.async {
                            self.goToLoginConfirm(userEntity)
                        }
                    }
            }) { (error, isUserLoggedOut) in
                print(error?.localizedDescription ?? "")
        }
    }
    @objc private func cancelView(){
        self.dismiss(animated: true, completion: nil)
    }
}
