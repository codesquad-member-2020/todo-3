//
//  ToDoTableViewDataSource.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit
import MobileCoreServices

class ToDoTableViewDataSource: NSObject, UITableViewDataSource {
    
    static let DragAndDropNotification = NSNotification.Name("DragAndDropNotification")
    var dataManager = DataManager()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.cardsDataCount() ?? 0
    }
    
    // Provide Data in Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell
        let cardData = dataManager.cardsData?.responseData.cards[indexPath.row]
        //context menu - Edit
        cell.titleLabel.text = cardData?.title
        cell.contentLabel.text = cardData?.contents
        cell.authorLabel.text = cardData?.writer
        return cell
    }
    
    // Delete Card
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cardToDelete = self.dataManager.cardsData?.responseData.cards[indexPath.row]
             guard let cardId = cardToDelete?.id else { return }
            guard let columnId = self.dataManager.cardsData?.responseData.id else {return}
             self.dataManager.cardsData?.responseData.cards.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
             self.dataManager.requestDeleteCard(columnId: columnId, cardId: cardId)
        }
    }
    
    // Drag & Drop
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard let card = self.dataManager.cardsData?.responseData.cards[sourceIndex] else { return }
        self.dataManager.cardsData?.responseData.cards.remove(at: sourceIndex)
        self.dataManager.cardsData?.responseData.cards.insert(card, at: destinationIndex)
        sendDragAndDropNotification(card: card, cardIndex: sourceIndex)
    }

    func addItem(_ card: Card, at index: Int) {
        self.dataManager.cardsData?.responseData.cards.insert(card, at: index)
    }
    
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    // Using when Drag & Drop card
    private func sendDragAndDropNotification(card: Card, cardIndex: Int) {
        NotificationCenter.default.post(name: DataManager.AddCardCompletedNotification, object: nil, userInfo: [NotificationUserInfoKey.dragAndDropCard: card, NotificationUserInfoKey.dragedCardIndex: cardIndex])
    }
}

