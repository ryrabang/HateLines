//
//  SearchViewController.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-28.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class SearchViewController:UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchTableManager:SearchTableManager?
    let users:[User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        searchTableManager = SearchTableManager(connect: searchTableView,withData: users)
    }
    
}
