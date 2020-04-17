//
//  TableVIewDragAndDropDelegate.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/16.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit
import MobileCoreServices

extension ToDoManagerViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let card = self.dataManager.cardsData?.responseData.cards[indexPath.row]
        
        guard let dragedCard = self.dataManager.cardsData?.responseData.cards[indexPath.row] else {
            return []
        }
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(card as? Data? ?? nil, nil)
            return nil
        }
        let cardToDrag = DraggedCard(draggedCardInfo: dragedCard, draggedCardIndex: indexPath.row, draggedCardColumnId: self.dataManager.switchURLColumnId(column: self.column))
        dragItem.localObject = cardToDrag
        self.sendToDoCardStartToMoveNotification(card: dragedCard, sourceColumnId: self.dataManager.switchURLColumnId(column: self.column), sourceCardIndexRow: indexPath.row)
        return [dragItem]
    }
}

extension ToDoManagerViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return self.dataSource.canHandle(session)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: row, section: 0)
        }
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // Between Same Table
                var indexPaths = [IndexPath]()
                indexPaths.append(destinationIndexPath)
                var originIndexPaths = [IndexPath]()
                originIndexPaths.append(sourceIndexPath)
                tableView.beginUpdates()
                self.dataSource.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
                DispatchQueue.main.async {
                    self.ToDoTableView.reloadData()
                }
                tableView.endUpdates()
                let columnId = self.dataManager.switchURLColumnId(column: self.column)
                let moveCard = MoveCardForm(destinationId: columnId, destinationRow: destinationIndexPath.row)
                self.dataManager.requestMoveCard(movingInfo: moveCard, originalColumnId: columnId, originalCardId: columnId, originalCardRow: sourceIndexPath.row)
                
            } else if let dragObject = item.dragItem.localObject as? DraggedCard {
                // Between Different Table
                let card = item.dragItem.localObject as? DraggedCard
                guard let movingCard = card?.draggedCardInfo else {return}
                self.dataSource.addItem(movingCard, at: destinationIndexPath.row)
                
                let currentColumnId = self.dataManager.switchURLColumnId(column: self.column)
                
                let columnId = self.dataManager.switchURLColumnId(column: self.column)
                let moveCard = MoveCardForm(destinationId: currentColumnId, destinationRow: destinationIndexPath.row)
                guard let sourceColumnId = card?.draggedCardColumnId else {return}
                guard let sourceCardId = card?.draggedCardInfo.id else {
                    return
                }
                guard let sourceCardIndex = card?.draggedCardIndex else {
                    return
                }
                self.dataManager.requestMoveCard(movingInfo: moveCard, originalColumnId: sourceColumnId, originalCardId: sourceCardId, originalCardRow: sourceCardIndex+1)
                tableView.endUpdates()

                if currentColumnId == moveCard.destinationId {
                    self.dataSource.dataManager.cardsData?.responseData.cards.removeLast()
                }
                DispatchQueue.main.async {
                    self.ToDoTableView.reloadData()
                }
                self.sendFinishToMoveNotification()
                
            }
        }
    }
    
    @objc func sendDragedCard(notification: Notification) {
        guard let card = notification.userInfo?[NotificationUserInfoKey.dragAndDropCard] as? Card else { return }
        guard let cardIndex = notification.userInfo?[NotificationUserInfoKey.dragedCardIndex] as? Int else { return }
        self.dragedCard = card
        self.dragedCardIndex = cardIndex
    }
}
