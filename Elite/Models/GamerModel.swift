//
//  GamerModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GamerModel: Codable {
    let profileImage: String? //(Bitmoji image)
    let firstname: String
    let lastname: String
    let username: String?
    let email: String
    let status: String? //(rank i.e. Bronze, Gold< Diamond)
    let achievements: [String]?
    let bio: String?
    let qrCode: String
    let joinedDate: String
    let gamerID: String
    let myParks : [String]? //this array holds the ids for parks that user has played att
    let numberOfHandballGamesPlayed : Double
    let numberOfBasketballGamesPlayed : Double
    let friends: [String]?
    var deviceName: String
    var winsByLocation: [String: Int]? // [Name of park : Wins]
    public var fullname: String {
        return ((firstname ) + " " + (lastname )).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(profileImage: String?,
    fullname: String,
    firstname: String,
    lastname: String,
    username: String?,
    email: String,
    status: String?,
    achievements: [String]?,
    bio: String?,
    qrCode: String,
    joinedDate: String,
    gamerID: String,
    myParks : [String]?,
    numberOfHandballGamesPlayed : Double,
    numberOfBasketballGamesPlayed : Double,
    friends: [String]?,
    deviceName: String, winsByLocation: [String: Int]?) {
        self.profileImage = profileImage
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.email = email
        self.status = status
        self.achievements = achievements
        self.bio = bio
        self.qrCode = qrCode
        self.joinedDate = joinedDate
        self.gamerID = gamerID
        self.myParks = myParks
        self.numberOfHandballGamesPlayed = numberOfHandballGamesPlayed
        self.numberOfBasketballGamesPlayed = numberOfBasketballGamesPlayed
        self.friends = friends
        self.deviceName = deviceName
        self.winsByLocation = winsByLocation
    }
    
    init(dict: [String: Any]) {
        self.profileImage = dict[GamerCollectionKeys.ProfileImageURLKey] as? String ?? ""
        self.firstname = dict[GamerCollectionKeys.FirstNameKey] as? String ?? ""
        self.lastname = dict[GamerCollectionKeys.LastNameKey] as? String ?? ""
        self.username = dict[GamerCollectionKeys.UserNameKey] as? String ?? ""
        self.email = dict[GamerCollectionKeys.EmailKey] as? String ?? ""
        self.status = dict[GamerCollectionKeys.StatusKey] as? String ?? ""
        self.achievements = dict[GamerCollectionKeys.AchievementsKey] as? [String] ?? ["",""]
        self.bio = dict[GamerCollectionKeys.BioKey] as? String ?? "FirstName"
        self.qrCode = dict[GamerCollectionKeys.QRcodeKey] as? String ?? "LastName"
        self.joinedDate = dict[GamerCollectionKeys.JoinedDateKey] as? String ?? ""
        self.gamerID = dict[GamerCollectionKeys.GamerIDKey] as? String ?? ""
        self.myParks = dict[GamerCollectionKeys.MyParks] as? [String] ?? [""]
        self.numberOfHandballGamesPlayed = dict[GamerCollectionKeys.NumberOfHandballGamesPlayed] as? Double ?? 0.0
        self.numberOfBasketballGamesPlayed = dict[GamerCollectionKeys.NumberOfBasketballGamesPlayer] as? Double ?? 0.0
        self.friends = dict[GamerCollectionKeys.FriendsKey] as? [String] ?? [""]
        self.deviceName = dict[GamerCollectionKeys.deviceName] as? String ?? ""
        self.winsByLocation = dict[GamerCollectionKeys.WinsByLocation] as? [String : Int]
    }
    

}

class EloPlayer  {
    var currentEloScore : Double
    var highestScore : Double
    var gameWinStatus : String
    var totalHandballGamesPlayed : Double
    var totalBasketBallGamesPlayed : Double
    
    init(currentEloScore : Double, highestScore: Double, gameWinStatus : String, totalHandballGamesPlayed : Double, totalBasketBallGamesPlayed : Double ) {
        self.currentEloScore = currentEloScore
        self.highestScore = highestScore
        self.gameWinStatus = gameWinStatus
        self.totalHandballGamesPlayed = totalHandballGamesPlayed
        self.totalBasketBallGamesPlayed = totalBasketBallGamesPlayed
        
    }
}
