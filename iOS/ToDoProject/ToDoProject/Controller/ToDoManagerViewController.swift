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
        DispatchQueue.main.async {
            print(#function)
        self.dataSource.dataManager = self.dataManager
            self.dataSource.dataManager.cardsData?.responseData.cards.append(addedCardInfo)
        guard let cardsCount = self.dataManager.cardsDataCount() else { return }
        self.cardsNumberLabel.text = "\(cardsCount)"
        self.ToDoTableView.reloadData()
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
        case ColumnURLName.ToDo: return Column.ToDoColumn
        case ColumnURLName.InProgress: return Column.InProgressColumn
        case ColumnURLName.Done: return Column.DoneColumn
        default:
            return ""
        }
    }
}
