//
//  ToDoViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoManagerViewController: UIViewController {
    
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var cardsNumberLabel: UILabel!
    @IBOutlet weak var columnTitleLabel: UILabel!
    @IBOutlet weak var numberBackgroundView: UILabel!
    @IBOutlet weak var ToDoTableView: UITableView!
    var column = ""
    var headerTitle = ""
    var numberOfCard = ""
    private let tableViewHeaderHeight = CGFloat(50)
    let dataSource = ToDoTableViewDataSource()
    let dataManager = DataManager()
    private let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        headerBackgroundView.layer.cornerRadius = 10
        dataSource.dataManager = self.dataManager
        self.ToDoTableView.dataSource = dataSource
        ToDoTableView.register(nib, forCellReuseIdentifier: "todoCell")
        dataManager.requestData(of: self.column)
        setupNotification()
        columnTitleLabel.text = headerTitle
        self.ToDoTableView.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: DataManager.ToDoCardsDecodedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: DataManager.AddCardCompletedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: DataManager.FinishToMoveNotification, object: nil)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: DataManager.ToDoCardsDecodedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: DataManager.AddCardCompletedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewAfterMoving), name: DataManager.FinishToMoveNotification, object: nil)
    }
    
    @objc private func reloadTableView(notification: Notification) {
        guard let cardCount = notification.userInfo?[NotificationUserInfoKey.cardCount] as? String else { return }
        self.numberOfCard = cardCount
        DispatchQueue.main.async {
            guard let cardsCount = self.dataManager.cardsDataCount() else { return }
            self.cardsNumberLabel.text = "\(cardsCount)"
            self.ToDoTableView.reloadData()
        }
    }
    
    @objc private func updateTableView(notification: Notification){
        guard let addedCardInfo = notification.userInfo?[NotificationUserInfoKey.addedCardInfo] as? Card else { return }
        guard let addedCardColumn = notification.userInfo?[NotificationUserInfoKey.addedCardColumn] as? String else { return }
        guard let requestMethod = notification.userInfo?[NotificationUserInfoKey.requestMethod] as? String else { return }
        let currentColumn = self.switchName(column: self.column)
        if addedCardColumn == currentColumn && requestMethod == RequestMethod.post {
            DispatchQueue.main.async {
                self.dataSource.dataManager = self.dataManager
                self.dataSource.dataManager.cardsData?.responseData.cards.append(addedCardInfo)
                guard let cardsCount = self.dataManager.cardsDataCount() else { return }
                self.cardsNumberLabel.text = "\(cardsCount)"
                self.ToDoTableView.reloadData()
            }
        } else if addedCardColumn == currentColumn && requestMethod == RequestMethod.put {
            DispatchQueue.main.async {
                self.dataSource.dataManager = self.dataManager
                // API 에서 row 변경하면 바꾸기
                let editedCard = Card(id: addedCardInfo.id, row: addedCardInfo.row-1, title: addedCardInfo.title, contents: addedCardInfo.contents, writer: addedCardInfo.writer, deleted: addedCardInfo.deleted, writtenTime: addedCardInfo.writtenTime)
                self.dataSource.dataManager.cardsData?.responseData.cards[addedCardInfo.row-1] = editedCard
                
                self.ToDoTableView.reloadData()
            }
        }
    }
    
    @objc private func updateTableViewAfterMoving(notification: Notification) {
        guard let movingInfo = notification.userInfo?[NotificationUserInfoKey.movingInfo] as? MoveCardForm else { return }
        guard let movedCard = notification.userInfo?[NotificationUserInfoKey.movedCard] as? Card else { return }
        let currentColum = switchName(column: self.column)
        guard let cardsCount = self.dataSource.dataManager.cardsData?.responseData.cards.count else { return }
        DispatchQueue.main.async {
            if currentColum == movingInfo.originColName{
                self.cardsNumberLabel.text = " \(cardsCount-1) "
                self.dataSource.dataManager.cardsData?.responseData.cards.remove(at: movingInfo.originRow-1)
            }
            if currentColum ==  movingInfo.destinationColName {
                self.cardsNumberLabel.text = " \(cardsCount+1) "
                self.dataSource.dataManager.cardsData?.responseData.cards.insert(movedCard, at: movingInfo.destinationRow-1)
            }
            self.ToDoTableView.reloadData()
        }
    }
    
    @IBAction func addCardButtonTapped(_ sender: Any) {
        let cardSheet = ModalCardSheetViewController()
        cardSheet.column = switchName(column: self.column)
        cardSheet.modalPresentationStyle = .automatic
        cardSheet.providesPresentationContextTransitionStyle = true
        cardSheet.definesPresentationContext = true
        cardSheet.modalPresentationStyle = UIModalPresentationStyle.automatic;
        cardSheet.view.backgroundColor = UIColor.init(white: 1, alpha: 1)
        self.present(cardSheet, animated: true, completion: nil)
    }
    
    func switchName(column: String) -> String {
        switch column {
        case ColumnURLName.toDo: return Column.toDoColumn
        case ColumnURLName.inProgress: return Column.inProgressColumn
        case ColumnURLName.done: return Column.doneColumn
        default:
            return ""
        }
    }
}
