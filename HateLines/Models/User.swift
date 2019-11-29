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
    var ID : Int
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

