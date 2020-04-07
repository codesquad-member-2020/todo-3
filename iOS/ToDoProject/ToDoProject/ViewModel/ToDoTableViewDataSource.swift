//
//  ToDoTableViewDataSource.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoTableViewDataSource: NSObject, UITableViewDataSource {
    
    private let toDoTableViewDataManager = ToDoTableViewDataManager()
    private let codableManager = CodableManager()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .black
        return cell
    }
}
