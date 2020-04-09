//
//  ToDoTableViewDataSource.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoTableViewDataSource: NSObject, UITableViewDataSource {
    
    private let toDoTableViewDataManager = DataManager()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoTableViewDataManager.totalToDoCardsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .black
        return cell
    }
}
