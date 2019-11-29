//
//  ViewController.swift
//  HateLines
//
//  Created by Rys Rabang on 2019-09-27.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // while using the query, you might receive saying "query requires an index" and follow
        // a link to create the index, just copy that link and create the required index
        
        //        uncomment this to seed new data
        //        let generator = DataGenerator()
        //        generator.seedUser()
        //        generator.seedPost()
        //        generator.seedComment()
        
        //        UserModel.getUser(sortBy:"ID") {
        //            (users, err) in
        //            for user in users {
        //                print("user: \(user)")
        //            }
        //        }
        //        PostModel.getPost(sortBy:"ID") {
        //            (posts, err) in
        //            for post in posts {
        //                print("post: \(post)")
        //            }
        //        }
        //        PostModel.getPost(userID: 1, sortBy: "createdAt") {
        //            (posts, err) in
        //            for post in posts {
        //                print("post: \(post)")
        //            }
        //        }
        //        CommmentModel.getComments(sortBy:"ID") {
        //            (comments, err) in
        //            for comment in comments {
        //                print("comment: \(comment)")
        //            }
        //        }
        CommmentModel.getComments(postID: 3,sortBy:"createdAt") {
            (comments, err) in
            for comment in comments {
                print("comment: \(comment)")
            }
        }
    }
    
    
}

