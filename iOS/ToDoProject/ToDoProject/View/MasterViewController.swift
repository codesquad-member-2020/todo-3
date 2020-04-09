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
        setupChildViewControllers()
    }
    
    private func setupChildViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let toDoListVC = storyboard.instantiateViewController(withIdentifier: "toDoListVC") as! ToDoManagerViewController
        addChild(toDoListVC)
        view.addSubview(toDoListContainerView)
        self.toDoListVC = toDoListVC
        
        let inProgressListVC = storyboard.instantiateViewController(withIdentifier: "inProgressListVC") as! ToDoManagerViewController
        addChild(inProgressListVC)
        view.addSubview(inProgressListContainerView)
        self.inProgressListVC = inProgressListVC

        let doneListVC = storyboard.instantiateViewController(withIdentifier: "doneListVC") as! ToDoManagerViewController
        addChild(doneListVC)
        view.addSubview(doneListContainerView)
        self.doneListVC = doneListVC
    }
    
    private func setupHeader() {
    }
}

