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
    var ID: Int
    var userID: Int
    var postID: Int
    var phrase: String
    var likes: Int
    var createdAt: Date
    
    var dictionary : [String : Any] {
        return [
            "ID":ID,
            "userID":userID,
            "postID":postID,
            "phrase":phrase,
            "likes":likes,
            "createdAt": createdAt
        ]
    }
}

extension Comment: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let ID = dictionary["ID"] as? Int,
            let userID = dictionary["userID"] as? Int,
            let postID = dictionary["postID"] as? Int,
            let phrase = dictionary["phrase"] as? String,
            let likes = dictionary["likes"] as? Int,
            let createdAt = dictionary["createdAt"] as? Timestamp else {return nil}
        
        self.init(ID:ID, userID:userID, postID:postID, phrase:phrase, likes:likes, createdAt:createdAt.dateValue())
    }
}



class CommmentModel {
    private static func query(withID ID: Int?, userID:Int?, postID: Int?, sortBy: String?) -> Query {
        
        let baseQuery = Firestore.firestore().collection("comments").limit(to: Int(INT_MAX))
        
        var filtered = baseQuery
        
        if let id = ID {
            filtered = filtered.whereField("ID", isEqualTo: id)
        }
        
        if let userID = userID {
            filtered = filtered.whereField("userID", isEqualTo: userID)
        }
        
        if let postID = postID {
            filtered = filtered.whereField("postID", isEqualTo: postID)
        }
        
        if let sortBy = sortBy, !sortBy.isEmpty {
            filtered = filtered.order(by: sortBy)
        }
        
        return filtered
    }
    
    static func getComments(withID ID: Int? = nil, userID:Int? = nil, postID: Int? = nil, sortBy: String? = nil, completion: @escaping([Comment], Error?) -> Void) {
        let filteredQuery = query(withID:ID, userID:userID, postID: postID, sortBy:sortBy)
        
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
}
