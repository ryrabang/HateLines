//
//  PostsTableManager.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-07.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import Foundation
import UIKit

class PostsTableManager: NSObject,  UITableViewDelegate, UITableViewDataSource {
    
    var posts: [Post] = []
    
    init(connect tableView:UITableView,withData data: [Post]) {
        super.init()
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
        tableView.dataSource = self
        tableView.delegate = self
        posts = data
        tableView.rowHeight = 70
    }
    
    init(withData data: [Post]){
       
        posts = data
       
    }
    
    //MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("get rows")
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("getting cells")
        let postCell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        
        return postCell
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("print table view: \(tableView)")
        
        let reportAction = UITableViewRowAction(style: .normal, title: "Report") {
            (action, indexPath) in
            print("report")
        }
        return [reportAction]
    }
       
}
