//
//  ViewController.swift
//  HateLines
//
//  Created by Rys Rabang on 2019-09-27.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        setUpElements()
        
        // while using the query, you might receive saying "query requires an index" and follow
        // a link to create the index, just copy that link and create the required index
        

//        let generator = DataGenerator()
//        generator.seedUser()
//        generator.seedPost()
//        PostModel.getPost { (posts, error) in
//            if (error != nil) {
//                print("error: \(String(describing: error))")
//            }else{
//                generator.seedComment(posts: posts)
//            }
//            
//        }
        
        
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
        //        CommmentModel.getComments(postID: 3,sortBy:"createdAt") {
        //            (comments, err) in
        //            for comment in comments {
        //                print("comment: \(comment)")
        //            }
        //        }
        //        PostModel.upvote(of: <#T##Post#>)
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
        
        logoLabel?.layer.cornerRadius = 20.0
        logoLabel?.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up video in the background
        setUpVideo()
    }
    
    func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "hearts", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust size and frame
        videoPlayerLayer?.frame = CGRect(x:
            -self.view.frame.size.width*1.5, y: 0, width:
            self.view.frame.size.width*4, height:
            self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add to view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
    }
}

