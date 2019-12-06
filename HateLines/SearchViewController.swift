//
//  SearchViewController.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-28.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit

class SearchViewController:UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchTableManager:SearchTableManager?
    var users:[User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UserModel.getUser {
            [weak self](users, error) in
            if (error != nil) {
                print(error as Any)
            }
            self?.users = users
        }
        searchTableManager = SearchTableManager(connect: searchTableView)
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchString = searchBar.text!
        
        var searchedUsers: [User] = []
        
        for user in users {
            if user.name.contains(searchString) {
                print(user.name)
                searchedUsers.append(user)
            }
        }
        searchTableManager?.updateUsers(data: searchedUsers)
        searchTableView.reloadData()
    }
    
    @IBAction func lookup(_ sender: Any) {
        self.performSegue(withIdentifier: "searchToProfile", sender: self)
              
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "searchToProfile"){
            let userInfo = searchTableManager?.getSelectedUser()
            let profileVC = segue.destination as! OtherProfileViewController
            profileVC.user = userInfo
        }
    }
    
    
}
