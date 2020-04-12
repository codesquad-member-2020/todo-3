//
//  ToDoTableViewCell.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    static let identifier = "todoCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
