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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Column.ToDoColumn{
            let toDoVC = segue.destination as! ToDoManagerViewController
            toDoVC.headerTitle = Column.ToDoColumn
            toDoListVC = toDoVC
            toDoVC.column = ColumnURLName.ToDo
        }
        if segue.identifier == Column.InProgressColumn{
            let inProgressVC = segue.destination as! ToDoManagerViewController
            inProgressVC.headerTitle = Column.InProgressColumn
            inProgressListVC = inProgressVC
            inProgressVC.column = ColumnURLName.InProgress

        }
        if segue.identifier == Column.DoneColumn{
            let doneVC = segue.destination as! ToDoManagerViewController
            doneVC.headerTitle = Column.DoneColumn
            doneListVC = doneVC
            doneVC.column = ColumnURLName.Done
        }
    }
}

