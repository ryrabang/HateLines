//
//  PostCell.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-07.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var upVote: UIButton!
    @IBOutlet weak var downVote: UIButton!
    @IBOutlet weak var score: UILabel!
    
    var userClicked = false
    var upOrDown = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Changes the post's score depending on whether the user clicks the up or down arrow.
    // Need to link this to score on database.
    @IBAction func scoreChange(_ sender: UIButton) {
        var currentScore = Int(score.text!)!
        print("clicked")
        if (upOrDown == "") {
            if (sender == upVote) {
                currentScore += 1
                upOrDown = "up"
            } else {
                currentScore -= 1
                upOrDown = "down"
            }
            sender.tintColor = .red
        } else {
            if (upOrDown == "up") {
                if (sender == upVote) {
                    currentScore -= 1
                    upOrDown = ""
                    sender.tintColor = .black
                } else {
                    currentScore -= 2
                    upOrDown = "down"
                    upVote.tintColor = .black
                    sender.tintColor = .red
                }
            } else {
                if (sender == downVote) {
                    currentScore += 1
                    upOrDown = ""
                    sender.tintColor = .black
                } else {
                    currentScore += 2
                    upOrDown = "up"
                    downVote.tintColor = .black
                    sender.tintColor = .red
                }
            }
        }
        
        score.text = String(currentScore)
    }
    
}
