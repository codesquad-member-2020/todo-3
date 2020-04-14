//
//  ToDoViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoManagerViewController: UITableViewController {
    
    var column = ""
    var headerTitle = ""
    var numberOfCard = ""
    private var cardList = [Card]()
    private let tableViewHeaderHeight = CGFloat(50)
    private let dataSource = ToDoTableViewDataSource()
    private let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = dataSource
        tableView.register(nib, forCellReuseIdentifier: "todoCell")
        DataManager.requestData(of: self.column)
        setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: DataManager.ToDoCardsDecodedNotification, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = TableViewHeader()
        header.titleLabel.text = headerTitle
        header.numberLabel.text = numberOfCard
        header.addButton.addTarget(self, action: #selector(showCardSheet), for: .touchUpInside)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableViewHeaderHeight
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: DataManager.ToDoCardsDecodedNotification, object: nil)
    }
    
    @objc private func reloadTableView(notification: Notification) {
        guard let cardCount = notification.userInfo?["cardCount"] as? String else { return }
        numberOfCard = cardCount
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func showCardSheet(){
        let vc = AddCardModalViewController()
        vc.modalPresentationStyle = .automatic
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.automatic;
        vc.view.backgroundColor = UIColor.init(white: 1, alpha: 1)
        self.present(vc, animated: true, completion: nil)
    }
}
