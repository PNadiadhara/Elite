//
//  MessageBoardPost.swift
//  Elite
//
//  Created by Leandro Wauters on 11/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class MessageBoardPost: Codable {
    var parkId: String
    var post: String
    var posterId: String
    var postId: String
    var posterName: String
    var postDate: Date
    
    init(parkId: String, post: String, posterId: String, postId: String, posterName: String, postDate: Date) {
        self.parkId = parkId
        self.post = post
        self.posterId = posterId
        self.postId = postId
        self.posterName = posterName
        self.postDate = postDate
    }
    
    init(dict: [String: Any]) {
        self.parkId = dict[MessageBoardPostCollectionKeys.parkIdKey] as? String ?? ""
        self.post = dict[MessageBoardPostCollectionKeys.postKey] as? String ?? ""
        self.posterId = dict[MessageBoardPostCollectionKeys.posterIdKey] as? String ?? ""
        self.postId = dict[MessageBoardPostCollectionKeys.postIdKey] as? String ?? ""
        self.posterName = dict[MessageBoardPostCollectionKeys.posterNameKey] as? String ?? ""
        self.postDate = dict[MessageBoardPostCollectionKeys.postDateKey] as? Date ?? Date()
     }
}
