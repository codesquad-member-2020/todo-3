//
//  MasterViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/06.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    @IBOutlet weak var toDoListContainerView: UIView!
    @IBOutlet weak var inProgressListContainerView: UIView!
    @IBOutlet weak var doneListContainerView: UIView!
    private var toDoListVC: ToDoManagerViewController!
    private var inProgressListVC: ToDoManagerViewController!
    private var doneListVC: ToDoManagerViewController!
    private var totalCardsInfo: ToDoCardInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.requestData()
        self.totalCardsInfo = DataManager.totalToDoCards
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Column.ToDoColumn{
            let toDoVC = segue.destination as! ToDoManagerViewController
            toDoVC.headerTitle = Column.ToDoColumn
            toDoListVC = toDoVC
        }
        if segue.identifier == Column.InProgressColumn{
            let inProgressVC = segue.destination as! ToDoManagerViewController
            inProgressVC.headerTitle = Column.InProgressColumn
            inProgressListVC = inProgressVC
        }
        if segue.identifier == Column.DoneColumn{
            let doneVC = segue.destination as! ToDoManagerViewController
            doneVC.headerTitle = Column.DoneColumn
            doneListVC = doneVC
        }
    }
}

