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
    let posts:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
        commentTableManager = PostsTableManager(connect: commentsTableView,withData: posts)
    }
    
}
