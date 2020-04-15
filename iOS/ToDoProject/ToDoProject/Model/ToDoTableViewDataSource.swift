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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let cardToDelete = dataManager.cardsData?.responseData.cards[indexPath.row]
            guard let cardIdToDelete = cardToDelete?.id else { return }
           dataManager.cardsData?.responseData.cards.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
            let cardId = DeleteCardForm(id: cardIdToDelete)
            dataManager.requestDeleteCard(cardId: cardId)
        }
    }
}
