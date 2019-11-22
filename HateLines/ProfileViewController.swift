//
//  ProfileScreen.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-07.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{
    
    
    @IBOutlet weak var hateFeedTableView: UITableView!
    @IBOutlet weak var yourHateTableView: UITableView!
    
    let posts:[Post] = []
    var hateTableManager:PostsTableManager?
    var yourHateTableManager:PostsTableManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // inject table datasource, and delegate
        // working code
        hateTableManager = PostsTableManager(connect:hateFeedTableView, withData: posts)
        
        //        yourHateTableManager = PostsTableManager(connect: yourHateTableView, withData: posts)
        
        
        
        // not working code
//        yourHateTableView.dataSource = PostsTableManager(withData: posts)
//
//        yourHateTableView.delegate = PostsTableManager(withData: posts)
        
        // working code
        // difference is you have to:
        // 1. declare a property above
        // 2. initiate it here
        yourHateTableManager = PostsTableManager(withData: posts)
        yourHateTableView.dataSource = yourHateTableManager
        yourHateTableView.delegate = yourHateTableManager
//
        yourHateTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
        yourHateTableView.rowHeight = 70
    }
    
}