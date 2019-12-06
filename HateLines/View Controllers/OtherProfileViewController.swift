//
//  OtherProfileViewController.swift
//  HateLines
//
//  Created by Younhee Lee on 2019-12-05.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    var user:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageURL = URL(string: user!.imageUrl) else { return }

        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)

            DispatchQueue.main.async {
                self.profilePic.image = image
            }
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
