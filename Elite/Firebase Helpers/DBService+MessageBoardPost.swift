//
//  DBService+MessageBoardPost.swift
//  Elite
//
//  Created by Leandro Wauters on 11/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct MessageBoardPostCollectionKeys {
    static let collectionKey = "MessageBoardPost"
    static let parkIdKey = "ParkId"
    static let postKey = "Post"
    static let postIdKey = "PostId"
    static let posterIdKey = "PosterId"
    static let posterNameKey = "PosterName"
    static let postDateKey = "PostDate"
    static let hasImageKey = "hasImage"
}

extension DBService {
    static public func postMessage(message: MessageBoardPost, completion: @escaping(Error?) -> Void) {
        let reference = firestoreDB.collection(MessageBoardPostCollectionKeys.collectionKey).document()
        firestoreDB.collection(MessageBoardPostCollectionKeys.collectionKey).document(reference.documentID).setData([MessageBoardPostCollectionKeys.parkIdKey : message.parkId,MessageBoardPostCollectionKeys.postIdKey : reference.documentID, MessageBoardPostCollectionKeys.posterIdKey : message.posterId, MessageBoardPostCollectionKeys.postKey : message.post, MessageBoardPostCollectionKeys.posterNameKey : message.posterName, MessageBoardPostCollectionKeys.postDateKey : message.postDate]) { (error) in
            if let error = error {
                completion(error)
            } else {
                print("Message posted")
                completion(nil)
            }
        }
    }
    
    static public func fetchMessageBoardWithParkId(parkId: String, completion: @escaping(Error?, [MessageBoardPost]?) -> Void) {
        DBService.firestoreDB.collection(MessageBoardPostCollectionKeys.collectionKey).whereField(MessageBoardPostCollectionKeys.parkIdKey, isEqualTo: parkId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            }
            if let snapshot = snapshot?.documents {
                var boardMessages = [MessageBoardPost]()
                for boardMessage in snapshot {
                    boardMessages.append(MessageBoardPost(dict: boardMessage.data()))
                }
                completion(nil, boardMessages)
            }
        }
    }
}
