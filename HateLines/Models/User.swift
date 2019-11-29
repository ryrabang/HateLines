//
//  User.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-28.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var ID: Int
    var name: String
    var email: String
    var password: String
    var imageUrl: String
    var verified: Bool
    
    var dictionary: [String: Any] {
        return [
            "ID": ID,
            "name": name,
            "email": email,
            "password": password,
            "imageUrl": imageUrl,
            "verified": verified,
        ]
    }
    
}

extension User : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let ID = dictionary["ID"] as? Int,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let password = dictionary["password"] as? String,
            let imageUrl = dictionary["imageUrl"] as? String,
            let verified = dictionary["verified"] as? Bool
            else { return nil }
        
        self.init(ID: ID, name:name, email:email, password:password, imageUrl:imageUrl, verified:verified)
    }
}
