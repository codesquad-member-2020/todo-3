//
//  ToDoTableViewDataSource.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoTableViewDataSource: NSObject, UITableViewDataSource {
    
    var dataManager = DataManager()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.cardsDataCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell
        let cardData = dataManager.cardsData?.responseData.cards[indexPath.row]
        
        cell.titleLabel.text = cardData?.title
        cell.contentLabel.text = cardData?.contents
        cell.authorLabel.text = cardData?.writer
        return cell
    }
}
