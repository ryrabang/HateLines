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


class UserModel {
    private static func query(withID ID: Int?, name:String?, email: String?, verified: Bool?, sortBy: String?) -> Query {
        
        let baseQuery = Firestore.firestore().collection("users").limit(to: Int(INT_MAX))
        
        var filtered = baseQuery
        
        if let id = ID {
            filtered = filtered.whereField("ID", isEqualTo: id)
        }
        
        if let name = name, !name.isEmpty {
            filtered = filtered.whereField("name", isEqualTo: name)
        }
        
        if let email = email, !email.isEmpty {
            filtered = filtered.whereField("email", isEqualTo: email)
        }
        
        if let verified = verified {
            filtered = filtered.whereField("verified", isEqualTo: verified)
        }
        
        if let sortBy = sortBy, !sortBy.isEmpty {
            filtered = filtered.order(by: sortBy)
        }
        
        return filtered
    }
    
    static func getUser(withID ID: Int? = nil, name:String? = nil, email: String? = nil, verified: Bool? = nil, sortBy: String? = nil, completion: @escaping([User], Error?) -> Void) {
        let filteredQuery = query(withID: ID, name: name, email: email, verified: verified, sortBy: sortBy)
        
        filteredQuery.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching user results: \(String(describing: error))")
                return
            }
            
            let users = snapshot.documents.map { (document) -> User in
                if let user = User(dictionary: document.data()){
                    return user
                }else {
                    fatalError("Unable to initialize type \(User.self) with dictionary \(document.data())")
                }
            }
            
            completion(users, error)
        }
    }
    
    /**
     Add a new user
     - Parameter user: a user object needed to be added
     */
    static func addUser(_ user:User){
        let ref = Firestore.firestore().collection("users")
        ref.document("\(user.ID)").setData(user.dictionary)
    }
    
    
}
