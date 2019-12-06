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
    
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    var commentTableManager:PostsTableManager?
    var posts:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostModel.getPost(sortBy:"likes") {
            [weak self](posts, error) in
            if (error != nil) {
                print(error as Any)
            }
            self?.posts = posts
            self?.commentTableManager = PostsTableManager(connect: self!.commentsTableView,withData: posts)
        }

        // Do any additional setup after loading the view.
        
    }
    
}
