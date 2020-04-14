//
//  AddCardModalViewController.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/13.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class AddCardModalViewController: UIViewController {

    
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
        let card = AddCardForm(title: title, contents: contents, row: 4, writer: "Lena")
        DataManager.requestAddCard(card: card)
    }
    
    
}
