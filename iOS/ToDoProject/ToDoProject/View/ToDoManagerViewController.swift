//
//  ToDoViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoManagerViewController: UITableViewController {
    
    private let dataManager = ToDoTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource =  dataManager
    }
}
