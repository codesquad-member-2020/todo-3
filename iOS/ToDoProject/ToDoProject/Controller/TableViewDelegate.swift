//
//  TableViewDelegate.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/16.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

extension ToDoManagerViewController: UITableViewDelegate{
    
    static let EditCardNotification = NSNotification.Name("EditCardNotification")

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let moveToDone = UIAction(title: "move to done") { _ in
                self.moveCardToDone(indexPath: indexPath, tableView: tableView) }
            let edit = UIAction(title: "edit...") { _ in
                self.editCard(indexPath: indexPath, tableView: tableView) }
            let delete = UIAction(title: "delete", attributes: .destructive) { _ in
                self.deleteCard(indexPath: indexPath, tableView: tableView) }
            let menu = UIMenu(title: "", children: [moveToDone, edit, delete])
            return menu
        }
        return configuration
    }
    
    private func deleteCard(indexPath: IndexPath, tableView: UITableView){
        let cardToDelete = self.dataManager.cardsData?.responseData.cards[indexPath.row]
        guard let cardIdToDelete = cardToDelete?.id else { return }
        self.dataManager.cardsData?.responseData.cards.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        let cardId = DeleteCardForm(id: cardIdToDelete)
        self.dataManager.requestDeleteCard(cardId: cardId)
    }
    
    private func moveCardToDone(indexPath: IndexPath, tableView: UITableView){
        let currentColumn = self.switchName(column: self.column)
        guard let lastCardIndex = self.dataSource.dataManager.cardsData?.responseData.cards.count else { return }
        let moveCard = MoveCardForm(originColName: currentColumn, originRow: indexPath.row, destinationColName: "Done", destinationRow: "\(lastCardIndex + 1)")
        self.dataManager.requestMoveCard(movingInfo: moveCard)
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
