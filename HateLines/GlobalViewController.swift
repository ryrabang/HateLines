//
//  GlobalViewController.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-28.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit
import FirebaseAuth

class GlobalViewController : UIViewController {
    
    
    @IBOutlet weak var globalHatedLabel: UILabel!
    @IBOutlet weak var globalHatedImage: UIImageView!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    var commentTableManager:PostsTableManager?
    var posts:[Post] = []
    var userDict = [String : Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostModel.getPost(sortBy:"likes") {
            [weak self](posts, error) in
            if (error != nil) {
                print(error as Any)
            }
            self?.posts = posts
            self?.commentTableManager = PostsTableManager(connect: self!.commentsTableView,withData: posts)
            let hatedUser = self!.getHated(data: posts)
            
            UserModel.getUser(withID: hatedUser) {
                [weak self](user, error) in
                if (error != nil) {
                    print(error as Any)
                }
                self?.globalHatedLabel.text = "Number 1 hated user: " + user[0].name
                print(user[0].name)
                print(user[0].imageUrl)
                Utilities.downloadImage(from: user[0].imageUrl) {
                    (image, err) in
                    DispatchQueue.main.async {
                        self?.globalHatedImage.image = image
                    }
                }
            }
        }
    }
    
    func getHated(data:[Post]) -> String {
        for post in data {
            if(userDict[post.againstID] == nil) {
                userDict[post.againstID] = post.likes
            } else {
                userDict[post.againstID] = userDict[post.againstID]! + post.likes
            }
        }
        let hatedUser = userDict.max { a, b in a.value < b.value }
        print(hatedUser!.key + " " + String(hatedUser!.value))
        return hatedUser!.key
    }
    
}
