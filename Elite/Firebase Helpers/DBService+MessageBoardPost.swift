//
//  DBService+MessageBoardPost.swift
//  Elite
//
//  Created by Leandro Wauters on 11/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import Firebase
struct MessageBoardPostCollectionKeys {
    static let collectionKey = "MessageBoardPost"
    static let parkIdKey = "ParkId"
    static let postKey = "Post"
    static let postIdKey = "PostId"
    static let posterIdKey = "PosterId"
    static let posterNameKey = "PosterName"
    static let postDateKey = "PostDate"
    static let postImageKey = "PostImage"
}

extension DBService {
    static public func postMessage(message: MessageBoardPost, completion: @escaping(Error?) -> Void) {
        let reference = firestoreDB.collection(MessageBoardPostCollectionKeys.collectionKey).document()
        firestoreDB.collection(MessageBoardPostCollectionKeys.collectionKey).document(reference.documentID).setData([MessageBoardPostCollectionKeys.parkIdKey : message.parkId,MessageBoardPostCollectionKeys.postIdKey : reference.documentID, MessageBoardPostCollectionKeys.posterIdKey : message.posterId, MessageBoardPostCollectionKeys.postKey : message.post, MessageBoardPostCollectionKeys.posterNameKey : message.posterName, MessageBoardPostCollectionKeys.postDateKey : message.postDate, MessageBoardPostCollectionKeys.postImageKey : message.postImage ?? "nil" ]) { (error) in
            if let error = error {
                completion(error)
            } else {
                print("Message posted")
                completion(nil)
            }
        }
    }
    
    static public func fetchMessageBoardWithParkId(parkId: String, completion: @escaping(Error?, [MessageBoardPost]?) -> Void) -> ListenerRegistration {
        return firestoreDB.collection(MessageBoardPostCollectionKeys.collectionKey).whereField(MessageBoardPostCollectionKeys.parkIdKey, isEqualTo: parkId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            }
            if let snapshot = snapshot {
                let messages = snapshot.documents.map({MessageBoardPost.init(dict: $0.data())})
                completion(nil, messages)
            }
        }
    }
}
//static public func fetchYourMessages(completion: @escaping(Error?, [Message]?) -> Void) -> ListenerRegistration {
//    return firestoreDB.collection(MessageCollectionKeys.collectionKey).addSnapshotListener { (snapshot, error) in
//        if let error = error {
//            completion(error, nil)
//        }
//        if let snapshot = snapshot {
//            let messages = snapshot.documents.map({Message.init(dict: $0.data())})
//            completion(nil, messages.filter{$0.recipientId == currentManoUser.userId || $0.senderId == currentManoUser.userId})
//        }
//    }
//}
