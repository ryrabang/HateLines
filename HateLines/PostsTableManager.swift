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
    
    var storyboard : UIStoryboard!
    var commentsVC : CommnetsViewController!
    var navigator : UIViewController!
    
    init(connect tableView:UITableView,withData data: [Post]) {
        super.init()
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
        tableView.dataSource = self
        tableView.delegate = self
        posts = data
        tableView.rowHeight = 70
        
        // get navigator
        storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        commentsVC = (storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.commentViewController) as! CommnetsViewController)
        commentsVC.modalPresentationStyle = UIModalPresentationStyle.popover
//        let tabBar = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as? UITabBarController
       
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
             print("topView: \(String(describing: topController))")
            // topController should now be your topmost view controller
            navigator = topController
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row: \(indexPath.row)")
        print("navigator: \(String(describing: navigator))")
        print("commentVC: \(String(describing: commentsVC))")
        navigator.present(commentsVC, animated: true, completion: nil)
    }
}
