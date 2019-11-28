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
                sender.setImage(UIImage(named: "arrow-up-red"), for: .normal)
            } else {
                currentScore -= 1
                upOrDown = "down"
                sender.setImage(UIImage(named: "arrow-down-red"), for: .normal)
            }
        } else {
            if (upOrDown == "up") {
                if (sender == upVote) {
                    currentScore -= 1
                    upOrDown = ""
                    sender.setImage(UIImage(named: "arrow-up"), for: .normal)
                } else {
                    currentScore -= 2
                    upOrDown = "down"
                    upVote.setImage(UIImage(named: "arrow-up"), for: .normal)
                    sender.setImage(UIImage(named: "arrow-down-red"), for: .normal)
                }
            } else {
                if (sender == downVote) {
                    currentScore += 1
                    upOrDown = ""
                    sender.setImage(UIImage(named: "arrow-down"), for: .normal)
                } else {
                    currentScore += 2
                    upOrDown = "up"
                    downVote.setImage(UIImage(named: "arrow-down"), for: .normal)
                    sender.setImage(UIImage(named: "arrow-up-red"), for: .normal)
                }
            }
        }
        
        score.text = String(currentScore)
    }
    
}
