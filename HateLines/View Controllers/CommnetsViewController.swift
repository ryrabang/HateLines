//
//  CommnetsViewController.swift
//  HateLines
//
//  Created by 王梦君 on 2019-12-05.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class CommnetsViewController: UIViewController {
    
    var post:Post!
    var comments:[Comment] = []
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postPhraseLabel: UILabel!
    
    @IBOutlet weak var commentPhraseTextField: UITextField!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("post: \(String(describing: post))")
        
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        refresh()
        
    }
    
    func refresh() {
        Utilities.downloadImage(from: post.imageUrl) {
            (image, error) in
            DispatchQueue.main.async {
                self.postImageView.image = image
                self.postPhraseLabel.text = self.post.phrase
            }
        }
        
        CommmentModel.getComments(withPostRef: post.postRef) {
            [weak self](comments, error) in
            if error != nil {
                print("get comments error: \(String(describing: error))")
            }
            
            self?.comments = comments
            self?.commentsTableView.reloadData()
        }
        
        
    }
    
    
    @IBAction func commentTapped(_ sender: UIButton) {
        let commentPhrase = commentPhraseTextField.text ?? ""
        
        if let userId = Utilities.getCurrentUserID() {
            let comment = Comment(postRef: post.postRef, userID: userId, phrase: commentPhrase, likes: 0, createdAt: Date())
            CommmentModel.addComment(comment)
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


extension CommnetsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
        let comment = comments[indexPath.row]
        
        cell.setComment(as: comment)
        
        
        return cell
    }
    
    
}
