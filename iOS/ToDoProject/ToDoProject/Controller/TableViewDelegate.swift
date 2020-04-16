//
//  TableViewDelegate.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/16.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

extension ToDoManagerViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        var configuration = UIContextMenuConfiguration()
        if self.column == ColumnURLName.done{
            configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let edit = UIAction(title: "edit...") { _ in
                    self.editCard(indexPath: indexPath, tableView: tableView) }
                let delete = UIAction(title: "delete", attributes: .destructive) { _ in
                    self.deleteCard(indexPath: indexPath, tableView: tableView) }
                let menu = UIMenu(title: "", children: [edit, delete])
                return menu
            }
        } else {
            configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let moveToDone = UIAction(title: "move to done") { _ in
                    self.moveCardToDone(indexPath: indexPath, tableView: tableView) }
                let edit = UIAction(title: "edit...") { _ in
                    self.editCard(indexPath: indexPath, tableView: tableView) }
                let delete = UIAction(title: "delete", attributes: .destructive) { _ in
                    self.deleteCard(indexPath: indexPath, tableView: tableView) }
                let menu = UIMenu(title: "", children: [moveToDone, edit, delete])
                return menu
            }

        }
        return configuration
    }
    
    private func deleteCard(indexPath: IndexPath, tableView: UITableView){
        let cardToDelete = self.dataManager.cardsData?.responseData.cards[indexPath.row]
        guard let cardIdToDelete = cardToDelete?.id else { return }
        self.dataManager.cardsData?.responseData.cards.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        guard let columnId = self.dataManager.cardsData?.responseData.id else { return }
        guard let cardId = self.dataManager.cardsData?.responseData.cards[indexPath.row].id else { return }
        self.dataManager.requestDeleteCard(columnId: columnId, cardId: cardId)
    }
    
    private func moveCardToDone(indexPath: IndexPath, tableView: UITableView){
        let currentColumn = self.switchName(column: self.column)
        let doneColumnId = 3
        let toLast = 0
        let moveCard = MoveCardForm(destinationId: doneColumnId, destinationRow: 9)
        guard let columnId = self.dataManager.cardsData?.responseData.id else { return }
        guard let cardId = self.dataManager.cardsData?.responseData.cards[indexPath.row].id else { return }
        self.dataManager.requestMoveCard(movingInfo: moveCard, originalColumnId: columnId, originalCardId: cardId, originalCardRow: indexPath.row)
    }
    
    
    private func editCard(indexPath: IndexPath, tableView: UITableView){
        let cardSheet = ModalCardSheetViewController()
        cardSheet.column = switchName(column: self.column)
        cardSheet.modalPresentationStyle = .automatic
        cardSheet.providesPresentationContextTransitionStyle = true
        cardSheet.definesPresentationContext = true
        cardSheet.modalPresentationStyle = UIModalPresentationStyle.automatic;
        cardSheet.view.backgroundColor = UIColor.init(white: 1, alpha: 1)
        let originalCard = self.dataSource.dataManager.cardsData?.responseData.cards[indexPath.row]
        let originalCardId = originalCard?.id
        cardSheet.originalCardId = originalCardId
        cardSheet.titleTextField.text = originalCard?.title
        cardSheet.contentsTextField.textColor = .black
        cardSheet.contentsTextField.text = originalCard?.contents
        self.present(cardSheet, animated: true, completion: nil)
    }
}
