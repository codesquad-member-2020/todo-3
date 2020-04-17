//
//  MasterViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var toDoListContainerView: UIView!
    @IBOutlet weak var inProgressListContainerView: UIView!
    @IBOutlet weak var doneListContainerView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var popMenuVC = PoPOverMenuViewController()
    private var toDoListVC: ToDoManagerViewController!
    private var inProgressListVC: ToDoManagerViewController!
    private var doneListVC: ToDoManagerViewController!
    var startToMoveCard: Card?
    var sourceColumnId: Int?
    var sourceCardIndexRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ToDoManagerViewController.ToDoCardStartToMoveNotification, object: nil)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(readyToChangeSourceTable), name: ToDoManagerViewController.ToDoCardStartToMoveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeSourceTable), name: ToDoManagerViewController.ToDoCardDoneToMoveNotification, object: nil)
        
    }
    
    func rightItemClick()
    {
        self.popMenuVC.modalPresentationStyle = .popover
        self.popMenuVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.popMenuVC.popoverPresentationController?.permittedArrowDirections = .unknown
        self.popMenuVC.popoverPresentationController?.delegate = self
        self.present(self.popMenuVC, animated: true, completion: nil)
        
    }
    
    @objc func readyToChangeSourceTable(_ notification: Notification){
        guard let startToMoveCard = notification.userInfo?[NotificationUserInfoKey.startToMoveCard] as? Card else { return }
        guard let sourceColumnId = notification.userInfo?[NotificationUserInfoKey.sourceColumnId] as? Int else { return }
        guard let sourceCardIndexRow = notification.userInfo?[NotificationUserInfoKey.sourceCardIndexRow] as? Int else { return }
        self.startToMoveCard = startToMoveCard
        self.sourceColumnId = sourceColumnId
        self.sourceCardIndexRow = sourceCardIndexRow
    }
    
    @objc func changeSourceTable(_ notification: Notification){
        let dataManager =  DataManager()
        let toDoId = dataManager.switchURLColumnId(column: self.toDoListVC.column)
        
        let inProgressId = dataManager.switchURLColumnId(column: self.inProgressListVC.column)
        let doneId = dataManager.switchURLColumnId(column: self.doneListVC.column)
        
        if self.sourceColumnId == toDoId {
            DispatchQueue.main.async {
                self.toDoListVC.ToDoTableView.reloadData()
            }
        } else if self.sourceColumnId == inProgressId {
            DispatchQueue.main.async {
                self.inProgressListVC.ToDoTableView.reloadData()
            }
            
        }else{
            DispatchQueue.main.async {
                self.doneListVC.ToDoTableView.reloadData()
            }
        }
    }
    
    @objc func tableDidSelected(_ notification: Notification)
    {
        var indexpath: IndexPath? = (notification.object as? IndexPath)
        switch indexpath?.row {
        case 0: toDoListVC.dataSource.dataManager.cardsData?.responseData.cards.removeAll()// To Do Clear
        case 1: inProgressListVC.dataSource.dataManager.cardsData?.responseData.cards.removeAll()
        case 2: doneListVC.dataSource.dataManager.cardsData?.responseData.cards.removeAll()
        default:
            print("nothing")
        }
        self.toDoListVC.ToDoTableView.reloadData()
        self.inProgressListVC.ToDoTableView.reloadData()
        self.doneListVC.ToDoTableView.reloadData()
        self.popMenuVC.dismiss(animated: true, completion: nil)
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool
    {
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Column.toDoColumn{
            let toDoVC = segue.destination as! ToDoManagerViewController
            toDoVC.headerTitle = Column.toDoColumn
            toDoListVC = toDoVC
            toDoVC.column = ColumnURLName.toDo
        }
        if segue.identifier == Column.inProgressColumn{
            let inProgressVC = segue.destination as! ToDoManagerViewController
            inProgressVC.headerTitle = Column.inProgressColumn
            inProgressListVC = inProgressVC
            inProgressVC.column = ColumnURLName.inProgress
            
        }
        if segue.identifier == Column.doneColumn{
            let doneVC = segue.destination as! ToDoManagerViewController
            doneVC.headerTitle = Column.doneColumn
            doneListVC = doneVC
            doneVC.column = ColumnURLName.done
        }
    }
    
    @IBAction func MenuButtonTapped(_ sender: UIBarButtonItem) {
        let array = ["Clear To Do Cards","Clear In Progress Cards","Clear Done Cards"]
        popMenuVC.arrayListPopover = array
        NotificationCenter.default.addObserver(self, selector: #selector(self.tableDidSelected), name: NSNotification.Name(rawValue: "click"), object: nil)
        rightItemClick()
        
    }
}

