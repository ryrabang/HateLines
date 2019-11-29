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
