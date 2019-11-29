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
    var ID: Int
    var userID: Int
    var againstID: Int
    var imageUrl: String
    var phrase: String
    var likes: Int
    var createdAt: Date
    
    var dictionary: [String: Any] {
        return [
            "ID": ID,
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
        guard let ID = dictionary["ID"] as? Int,
            let userID = dictionary["userID"] as? Int,
            let againstID = dictionary["againstID"] as? Int,
            let imageUrl = dictionary["imageUrl"] as? String,
            let phrase = dictionary["phrase"] as? String,
            let createdAt = dictionary["createdAt"] as? Timestamp,
            let likes = dictionary["likes"] as? Int else {return nil}
        
        
        self.init(ID:ID, userID:userID, againstID:againstID, imageUrl:imageUrl, phrase:phrase, likes:likes, createdAt:createdAt.dateValue())
        
    }
}

class PostModel {
    private static func query(withID ID:Int?, userID:Int?, againstID:Int?, sortBy:String?) -> Query {
        let baseQuery = Firestore.firestore().collection("posts").limit(to: Int(INT_MAX))
        
        var filtered = baseQuery
        
        if let id = ID {
            filtered = filtered.whereField("ID", isEqualTo: id)
        }
        
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
    
    static func getPost(withID ID:Int? = nil, userID:Int? = nil, againstID:Int? = nil, sortBy:String? = nil, completion: @escaping([Post], Error?) -> Void) {
           let filteredQuery = query(withID:ID, userID:userID, againstID:againstID, sortBy:sortBy)
           
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
}
