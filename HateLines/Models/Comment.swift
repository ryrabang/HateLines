//
//  Comment.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-28.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    var postRef: DocumentReference
    var userID: String
    var phrase: String
    var likes: Int
    var createdAt: Date
    
    var dictionary : [String : Any] {
        return [
            "userID":userID,
            "postRef":postRef,
            "phrase":phrase,
            "likes":likes,
            "createdAt": createdAt
        ]
    }
}

extension Comment: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let userID = dictionary["userID"] as? String,
            let postRef = dictionary["postRef"] as? DocumentReference,
            let phrase = dictionary["phrase"] as? String,
            let likes = dictionary["likes"] as? Int,
            let createdAt = dictionary["createdAt"] as? Timestamp else {return nil}
        
        self.init(postRef:postRef, userID:userID, phrase:phrase, likes:likes, createdAt:createdAt.dateValue())
    }
}



class CommmentModel {
    private static func query(withPostRef postRef: DocumentReference?, userID:String?, likes: Int?, sortBy: String?) -> Query {
        
        let baseQuery = Firestore.firestore().collection("comments").limit(to: Int(INT_MAX))
        
        var filtered = baseQuery
        
        if let postRef = postRef {
            filtered = filtered.whereField("postRef", isEqualTo: postRef)
        }
        
        if let userID = userID {
            filtered = filtered.whereField("userID", isEqualTo: userID)
        }
        
        if let likes = likes {
            filtered = filtered.whereField("likes", isGreaterThan:likes)
        }
        
        if let sortBy = sortBy, !sortBy.isEmpty {
            filtered = filtered.order(by: sortBy)
        }
        
        return filtered
    }
    
    static func getComments(withPostRef postRef: DocumentReference?, userID:String?, likes: Int?, sortBy: String?, completion: @escaping([Comment], Error?) -> Void) {
        let filteredQuery = query(withPostRef:postRef, userID:userID, likes: likes, sortBy:sortBy)
        
        filteredQuery.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching comment results: \(String(describing: error))")
                return
            }
            
            let comments = snapshot.documents.map { (document) -> Comment in
                if let comment = Comment(dictionary: document.data()){
                    return comment
                }else {
                    fatalError("Unable to initialize type \(Comment.self) with dictionary \(document.data())")
                }
            }
            
            completion(comments, error)
        }
    }
    
    /**
        Add a new comment
        - Parameter post: a post needed to be added
        */
       static func addComment(_ comment:Comment){
           let ref = Firestore.firestore().collection("comments")
           ref.document().setData(comment.dictionary)
       }
}
