//
//  Post.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-07.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import Foundation
import Firebase


struct Post {
    var postRef: DocumentReference
    var userID: String
    var againstID: String
    var imageUrl: String
    var phrase: String
    var likes: Int
    var createdAt: Date
    
    var dictionary: [String: Any] {
        return [
            "postRef": postRef,
            "userID": userID,
            "againstID": againstID,
            "imageUrl": imageUrl,
            "phrase": phrase,
            "createdAt": createdAt,
            "likes":likes
        ]
    }
}


extension Post : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let postRef = dictionary["postRef"] as? DocumentReference,
            let userID = dictionary["userID"] as? String,
            let againstID = dictionary["againstID"] as? String,
            let imageUrl = dictionary["imageUrl"] as? String,
            let phrase = dictionary["phrase"] as? String,
            let createdAt = dictionary["createdAt"] as? Timestamp,
            let likes = dictionary["likes"] as? Int else {return nil}
        
        
        self.init(postRef:postRef, userID:userID, againstID:againstID, imageUrl:imageUrl, phrase:phrase, likes:likes, createdAt:createdAt.dateValue())
        
    }
}

class PostModel {
    private static func query(userID:String?, againstID:String?, sortBy:String?) -> Query {
        let baseQuery = Firestore.firestore().collection("posts").limit(to: Int(INT_MAX))
        
        var filtered = baseQuery
        
        if let userId = userID {
            filtered = filtered.whereField("userID", isEqualTo: userId)
        }
        
        if let againstId = againstID {
            filtered = filtered.whereField("againstID", isEqualTo: againstId)
        }
        
        if let sortBy = sortBy, !sortBy.isEmpty {
            filtered = filtered.order(by: sortBy)
        }
        
        return filtered
    }
    
    static func getPost(userID:String? = nil, againstID:String? = nil, sortBy:String? = nil, completion: @escaping([Post], Error?) -> Void) {
           let filteredQuery = query(userID:userID, againstID:againstID, sortBy:sortBy)
           
           filteredQuery.getDocuments { (snapshot, error) in
               guard let snapshot = snapshot else {
                   print("Error fetching post results: \(String(describing: error))")
                   return
               }
               
               let posts = snapshot.documents.map { (document) -> Post in
                   if let post = Post(dictionary: document.data()){
                       return post
                   }else {
                       fatalError("Unable to initialize type \(Post.self) with dictionary \(document.data())")
                   }
               }
               
               completion(posts, error)
           }
       }
    
    /**
     Add a new post
     - Parameter post: a post needed to be added
     */
    static func addPost(to postRef:DocumentReference, post:Post){
        postRef.setData(post.dictionary)
    }
    
    /**
    Update the likes of a post by 1
     - Parameter post: the post with updated likes 
     */
    static func upvote(of post: Post) {
//        let ref = Firestore.firestore().collection("posts")
        post.postRef.updateData(["likes": post.likes]) {
            err in
            if let err = err {
                print("Error updating likes: \(err)")
            }
        }
    }
}
