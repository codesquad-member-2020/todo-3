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
}

