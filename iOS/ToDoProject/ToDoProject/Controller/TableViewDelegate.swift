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
                let moveToToDo = UIAction(title: "move to To Do", image: UIImage(systemName: SystemImageName.arrowToLeftTwice)) { _ in
                    let toDoColumnId = 1
                    self.moveCard(indexPath: indexPath, tableView: tableView, columnId: toDoColumnId) }
                let moveToInProgress = UIAction(title: "move to In Progress", image: UIImage(systemName: SystemImageName.arrowToLeft)) { _ in
                    let doneColumnId = 2
                    self.moveCard(indexPath: indexPath, tableView: tableView, columnId: doneColumnId) }

                let edit = UIAction(title: "edit", image: UIImage(systemName: SystemImageName.pencil)) { _ in
                    self.editCard(indexPath: indexPath, tableView: tableView) }
                let delete = UIAction(title: "delete", image: UIImage(systemName: SystemImageName.trashBin), attributes: .destructive) { _ in
                    self.deleteCard(indexPath: indexPath, tableView: tableView) }
                let menu = UIMenu(title: "", children: [moveToToDo, moveToInProgress, edit, delete])
                return menu
            }            
        } else if self.column == ColumnURLName.inProgress{
            configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let moveToToDo = UIAction(title: "move to To Do", image: UIImage(systemName: SystemImageName.arrowToLeft)) { _ in
                    let toDoColumnId = 1
                    self.moveCard(indexPath: indexPath, tableView: tableView, columnId: toDoColumnId) }
                let moveToDone = UIAction(title: "move to Done", image: UIImage(systemName: SystemImageName.arrowToRight)) { _ in
                    let doneColumnId = 3
                    self.moveCard(indexPath: indexPath, tableView: tableView, columnId: doneColumnId) }
                let edit = UIAction(title: "edit", image: UIImage(systemName: SystemImageName.pencil)) { _ in
                    self.editCard(indexPath: indexPath, tableView: tableView) }
                let delete = UIAction(title: "delete", image: UIImage(systemName: SystemImageName.trashBin), attributes: .destructive) { _ in
                    self.deleteCard(indexPath: indexPath, tableView: tableView) }
                let menu = UIMenu(title: "", children: [moveToToDo, moveToDone, edit, delete])
                return menu
            }

        } else {
            configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let moveToInProgress = UIAction(title: "move to In Progress", image: UIImage(systemName: SystemImageName.arrowToRight)) { _ in
                    let doneColumnId = 2
                    self.moveCard(indexPath: indexPath, tableView: tableView, columnId: doneColumnId) }
                let moveToDone = UIAction(title: "move to Done", image: UIImage(systemName: SystemImageName.arrowToRight)) { _ in
                    let doneColumnId = 3
                    self.moveCard(indexPath: indexPath, tableView: tableView, columnId: doneColumnId) }
                let edit = UIAction(title: "edit", image: UIImage(systemName: SystemImageName.pencil)) { _ in
                    self.editCard(indexPath: indexPath, tableView: tableView) }
                let delete = UIAction(title: "delete", image: UIImage(systemName: SystemImageName.trashBin), attributes: .destructive) { _ in
                    self.deleteCard(indexPath: indexPath, tableView: tableView) }
                let menu = UIMenu(title: "", children: [moveToInProgress, moveToDone, edit, delete])
                return menu
            }

        }
        return configuration
    }
    
    private func deleteCard(indexPath: IndexPath, tableView: UITableView){
        let cardToDelete = self.dataSource.dataManager.cardsData?.responseData.cards[indexPath.row]
        guard let cardId = cardToDelete?.id else { return }
        let columnId = self.dataManager.switchURLColumnId(column: self.column)
        self.dataSource.dataManager.cardsData?.responseData.cards.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.dataSource.dataManager.requestDeleteCard(columnId: columnId, cardId: cardId)
    }
    
    private func moveCard(indexPath: IndexPath, tableView: UITableView, columnId: Int){
        let currentColumn = self.switchName(column: self.column)
        let toLast = 99 // 백엔드와 상의해서 99로 보내면 Destination Column에 마지막에 붙음
        let moveCard = MoveCardForm(destinationId: columnId, destinationRow: toLast)
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
    
    // Drag & Drop
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.dataSource.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }

}
