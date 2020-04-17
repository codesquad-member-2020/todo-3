//
//  PoPOverMenuViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/17.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class PoPOverMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var arrayListPopover : [String] = []
    private let tableView = UITableView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = UIColor.clear
        tableView.bounces = false
        configureSizeForChildView(forTableView: 300)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func configureSizeForChildView(forTableView width : CGFloat)
    {
        var tempSize = self.presentingViewController?.view.bounds.size
        tempSize?.width = width
        let size = tableView.sizeThatFits(tempSize!)
        self.preferredContentSize = size
        self.view.systemLayoutSizeFitting(tableView.frame.size)
        self.tableView.frame = self.view.frame
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayListPopover.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifer: String = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifer)
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifer)
        }
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.text = "\(arrayListPopover[indexPath.row])"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "click"), object: indexPath)
    }
    
}
