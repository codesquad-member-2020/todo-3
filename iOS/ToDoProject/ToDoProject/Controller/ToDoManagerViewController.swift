//
//  ToDoViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoManagerViewController: UITableViewController {
    
    var headerTitle = ""
    var numberOfCard = ""
    var cardList: [Card]?
    var header = TableViewHeader()
    private let tableViewHeaderHeight = CGFloat(50)
    private let dataSource = ToDoTableViewDataSource()
    private let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = dataSource
        tableView.register(nib, forCellReuseIdentifier: "todoCell")
        setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: DataManager.ToDoCardsDecodedNotification, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableViewHeader()
        header.titleLabel.text = headerTitle
        header.numberLabel.text = numberOfCard
        self.header = header
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableViewHeaderHeight
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: DataManager.ToDoCardsDecodedNotification, object: nil)
    }
    
    @objc private func reloadTableView(notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
