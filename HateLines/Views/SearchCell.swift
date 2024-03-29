//
//  SearchCell.swift
//  HateLines
//
//  Created by Rys Rabang on 2019-12-04.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(user : User) {
        nameLabel.text = user.name
    }
    
}
