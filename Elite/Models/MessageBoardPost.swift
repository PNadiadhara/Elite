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
    
    init(parkId: String, post: String, posterId: String, postId: String) {
        self.parkId = parkId
        self.post = post
        self.posterId = posterId
        self.postId = postId
    }
    
    init(dict: [String: Any]) {
        self.parkId = dict[MessageBoardPostCollectionKeys.parkIdKey] as? String ?? ""
        self.post = dict[MessageBoardPostCollectionKeys.postKey] as? String ?? ""
        self.posterId = dict[MessageBoardPostCollectionKeys.posterIdKey] as? String ?? ""
        self.postId = dict[MessageBoardPostCollectionKeys.postIdKey] as? String ?? ""
     }
}
