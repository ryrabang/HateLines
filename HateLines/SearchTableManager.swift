//
//  SearchTableManager.swift
//  HateLines
//
//  Created by Rys Rabang on 2019-12-04.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import Foundation
import UIKit

class SearchTableManager: NSObject,  UITableViewDelegate, UITableViewDataSource {
    
    var users: [User] = []
    var selectedUser: User!
    
    init(connect tableView:UITableView) {
        super.init()
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
    }
    
    init(withData data: [User]){
        users = data
    }
    
    func updateUsers(data: [User]) {
        self.users = data
    }
    //MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Search: get rows")
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Search: getting cells")
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchCell
        searchCell.loadData(user: users[indexPath.row])
        return searchCell
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("Search: print table view: \(tableView)")
        
        let reportAction = UITableViewRowAction(style: .normal, title: "Report") {
            (action, indexPath) in
            print("report")
        }
        return [reportAction]
    }
    
    
    
    
}

//MARK: - functions used for camera view
extension SearchTableManager {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users[indexPath.row]
    }
    
    func getSelectedUser()->User? {
        return selectedUser
    }
}
