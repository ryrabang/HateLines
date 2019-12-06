//
//  OtherProfileViewController.swift
//  HateLines
//
//  Created by Younhee Lee on 2019-12-05.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController {

    @IBOutlet weak var hateFeedTableView: UITableView!
    @IBOutlet weak var yourHateTableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    var user:User?
    
    let posts:[Post] = []
    var hateTableManager:PostsTableManager?
    var yourHateTableManager:PostsTableManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.downloadImage(from: user!.imageUrl) {
            (image, err) in
            DispatchQueue.main.async {
                self.profilePic.image = image
            }
        }
        
        let userID = user?.ID

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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
