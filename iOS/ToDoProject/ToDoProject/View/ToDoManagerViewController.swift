//
//  ToDoViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoManagerViewController: UIViewController {
    
    private let toDoTableViewDataSource = ToDoTableViewDataSource()
    
    private let toDoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.toDoTableView.dataSource = toDoTableViewDataSource
        setupToDoTableView()
        self.view.addSubview(toDoTableView)
        setToDoTableViewConstraint()
        
    }
    
    private func setupToDoTableView() {
        self.toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "toDoCell")
    }
    
    private func setToDoTableViewConstraint() {
        toDoTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        toDoTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        toDoTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        toDoTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}
