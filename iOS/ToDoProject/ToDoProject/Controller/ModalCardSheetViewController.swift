//
//  AddCardModalViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/13.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ModalCardSheetViewController: UIViewController {
    
    var column = ""
    var originalCardId: Int?
    private let dataManager = DataManager()
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancleButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadCardButtonTapped(_ sender: Any) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextField.text else { return }
        let card = NewCardForm(colName: column, row: 3, title: title, contents: contents, writer: "Lena")
        
        if originalCardId == nil{
            dataManager.requestUpdateCard(card: card, requestMethod: RequestMethod.post)
        } else {
            dataManager.requestUpdateCard(card: card, requestMethod: RequestMethod.put)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
