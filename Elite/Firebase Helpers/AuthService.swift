//
//  AuthService.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthServiceCreateNewAccountDelegate: AnyObject {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error)
    func didCreateNewAccount(_ authservice: AuthService, user: GamerModel)
}

protocol AuthServiceExistingAccountDelegate: AnyObject {
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error)
    func didSignInToExistingAccount(_ authservice: AuthService, user: User)
}

protocol AuthServiceSignOutDelegate: AnyObject {
    func didSignOutWithError(_ authservice: AuthService, error: Error)
    func didSignOut(_ authservice: AuthService)
}

final class AuthService {
    weak var authserviceCreateNewAccountDelegate: AuthServiceCreateNewAccountDelegate?
    weak var authserviceExistingAccountDelegate: AuthServiceExistingAccountDelegate?
    weak var authserviceSignOutDelegate: AuthServiceSignOutDelegate?
    
    
    public func createNewAccount(email: String, password: String, username: String, userImage: UIImage) {

        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                return
            } else if let authDataResult = authDataResult {
                let userId = authDataResult.user.uid
                self.createUserDatabase(userId: userId, email: authDataResult.user.email!, username: username, userImage: userImage)
            }
        }
    }
    private func createUserDatabase(userId: String, email: String, username: String, userImage: UIImage) {
         guard let userProfileImageData = userImage.jpegData(compressionQuality: 0.5) else {return}
        StorageService.postImage(imageData: userProfileImageData, imageName: userId) { (error, url) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            }
            if let url = url {
                let user = GamerModel(profileImage: url.absoluteString, username: username, email: email, status: nil, achievements: nil, bio: nil, qrCode: "fd", joinedDate: Date().toString(dateFormat: "MMM d, yyyy hh:mm a") , gamerID: userId, myParks: nil, numberOfHandballGamesPlayed: 0.0, numberOfBasketballGamesPlayed: 0.0,friends: nil, handBallGamesWinsByLocation: nil, basketBallGamesWinsByLocation: nil)
                DBService.createUser(gamer: user, completion: { (error) in
                    if let error = error {
                       self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                    } else {
                        self.authserviceCreateNewAccountDelegate?.didCreateNewAccount(self, user: user)
                    }
                })

            }
        }
    }
    
    public func createGoogleAccount(userId: String, email: String, username: String, userImage: UIImage) {
        createUserDatabase(userId: userId, email: email, username: username, userImage: userImage)
    }
    public func updateUserProfile(user: User, username: String) {
        let request = user.createProfileChangeRequest()
        request.displayName = username
        request.commitChanges(completion: { (error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                return
            }
        })
        DBService.firestoreDB.collection(GamerCollectionKeys.CollectionKey).document(user.uid).updateData([GamerCollectionKeys.UserNameKey : username]) { (error) in
            if let error = error {
                print("Error updatind name: \(error.localizedDescription)")
            }
        }
//        DBService.firestoreDB
//            .collection(GamerCollectionKeys.CollectionKey).document(userId).updateData([GamerCollectionKeys.ProfileImageURLKey : imageUrl]) { (error) in
//                if let error = error{
//                    print("Error updating profile: \(error.localizedDescription)")
//                }
//        }
    }
    
    public func signInExistingAccount(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceExistingAccountDelegate?.didRecieveErrorSigningToExistingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.authserviceExistingAccountDelegate?.didSignInToExistingAccount(self, user: authDataResult.user)
            }
        }
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func signOutAccount() {
        do {
            try Auth.auth().signOut()
            authserviceSignOutDelegate?.didSignOut(self)
        } catch {
            authserviceSignOutDelegate?.didSignOutWithError(self, error: error)
        }
    }
}
