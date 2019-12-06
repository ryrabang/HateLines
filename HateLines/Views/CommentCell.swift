//
//  CommentCell.swift
//  HateLines
//
//  Created by Mengjun Wang on 2019-12-05.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("initializing cell")
        userImage.makeRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setComment(as comment:Comment){
    
        UserModel.getUser(withID: comment.userID) {
            (users, error) in
            
            if error != nil {
                print("error: \(String(describing: error))")
            }
            
            let user = users[0]
            
            Utilities.downloadImage(from: user.imageUrl) {
                [weak self](image, error) in
                
                DispatchQueue.main.async {
                    self?.userImage.image = image
                    self?.commentLabel.text = comment.phrase
                }
            
            }
        }

    }

}
