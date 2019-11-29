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
