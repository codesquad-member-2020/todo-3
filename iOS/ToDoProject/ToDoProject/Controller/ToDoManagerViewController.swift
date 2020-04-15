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
    private var cardList = [Card]()
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
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: DataManager.ToDoCardsDecodedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: DataManager.AddCardCompletedNotification, object: nil)
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
        if addedCardColumn == self.switchName(column: self.column) {
            DispatchQueue.main.async {
                print(#function)
                self.dataSource.dataManager = self.dataManager
                self.dataSource.dataManager.cardsData?.responseData.cards.append(addedCardInfo)
                guard let cardsCount = self.dataManager.cardsDataCount() else { return }
                self.cardsNumberLabel.text = "\(cardsCount)"
                self.ToDoTableView.reloadData()
            }
        }
    }
    
    @IBAction func addCardButtonTapped(_ sender: Any) {
        let cardSheet = AddCardModalViewController()
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

extension ToDoManagerViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = tableView.cellForRow(at: indexPath)
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let moveToDone = UIAction(title: "move to done") { _ in }
            let edit = UIAction(title: "edit...") { _ in}
            let delete = UIAction(title: "delete", attributes: .destructive) { _ in
                self.deleteCard(indexPath: indexPath, tableView: tableView)
            }
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
}

