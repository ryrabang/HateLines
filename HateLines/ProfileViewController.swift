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
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var hateFeedTableView: UITableView!
    @IBOutlet weak var yourHateTableView: UITableView!
    
    var window: UIWindow?
    
    let posts:[Post] = []
    var hateTableManager:PostsTableManager?
    var yourHateTableManager:PostsTableManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // inject table datasource, and delegate
        // working code
        
        let userID = Utilities.getCurrentUserID()
        
        UserModel.getUser(withID: userID) { (user, error) in
            Utilities.downloadImage(from: user[0].imageUrl) {
                (image, err) in
                DispatchQueue.main.async {
                    self.profilePic.image = image
                }
            }
        }
        
        
        
        if (userID != nil)  {
            PostModel.getPost(userID: userID, sortBy:"likes") {
                [weak self](posts, error) in
                if (error != nil) {
                    print(error as Any)
                }
                self?.yourHateTableManager = PostsTableManager(connect: self!.yourHateTableView, withData: posts)
                self?.yourHateTableView.reloadData()
            }
            
            PostModel.getPost(againstID: userID, sortBy:"likes") {
                [weak self](posts, error) in
                if (error != nil) {
                    print(error as Any)
                }
                self?.hateTableManager = PostsTableManager(connect: self!.hateFeedTableView, withData: posts)
                self?.hateFeedTableView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("profile page is going to show")
        
        if let userID = Utilities.getCurrentUserID() {
            PostModel.getPost(userID: userID, sortBy:"likes") {
                [weak self](posts, error) in
                if (error != nil) {
                    print(error as Any)
                }
                self?.yourHateTableManager?.updateUsers(data: posts)
                self?.yourHateTableView.reloadData()
            }
            
            PostModel.getPost(againstID: userID, sortBy:"likes") {
                [weak self](posts, error) in
                if (error != nil) {
                    print(error as Any)
                }
                self?.hateTableManager?.updateUsers(data: posts)
                self?.hateFeedTableView.reloadData()
            }
        }
        
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

        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LandingVC")


        guard
                let window = UIApplication.shared.keyWindow,
                let rootViewController = window.rootViewController
                else {
            return
        }


        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        })

    }
}
