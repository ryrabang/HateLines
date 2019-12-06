//
//  ProfileScreen.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-07.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        
        let userID = Utilities.getCurrentUserID()
        
        if (userID != nil)  {
            PostModel.getPost(userID: userID, sortBy:"likes") {
                [weak self](posts, error) in
                if (error != nil) {
                    print(error as Any)
                }
                self?.hateTableManager = PostsTableManager(connect: self!.hateFeedTableView, withData: posts)
            }
            
            PostModel.getPost(againstID: userID, sortBy:"likes") {
                [weak self](posts, error) in
                if (error != nil) {
                    print(error as Any)
                }
                self?.yourHateTableManager = PostsTableManager(connect: self!.yourHateTableView, withData: posts)
            }
        } else {
            hateTableManager = PostsTableManager(connect: hateFeedTableView, withData: posts)
            yourHateTableManager = PostsTableManager(connect: yourHateTableView, withData: posts)
        }
        
        
        
        // not working code
        //        yourHateTableView.dataSource = PostsTableManager(withData: posts)
        //
        //        yourHateTableView.delegate = PostsTableManager(withData: posts)
        
        // working code
        // difference is you have to:
        // 1. declare a property above
        // 2. initiate it here
        //        yourHateTableManager = PostsTableManager(withData: posts)
        //        yourHateTableView.dataSource = yourHateTableManager
        //        yourHateTableView.delegate = yourHateTableManager
        ////
        //        yourHateTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
        //        yourHateTableView.rowHeight = 70
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            transitionToHomePage()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func transitionToHomePage() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.landingViewController)
        
//        self.view.window?.rootViewController = viewController
//        self.view.window?.makeKeyAndVisible()
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}
