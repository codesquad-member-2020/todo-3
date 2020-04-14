//
//  TableViewHeader.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class TableViewHeader: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel(frame: .zero)
    let numberLabel = UILabel(frame: .zero)
    private let alphaValue = CGFloat(0.8)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupTableViewHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableViewHeaderView()
    }
    
    private func setupTableViewHeaderView() {
        // Header BackgroundView
        let customBackgroundView = UIView(frame: .zero)
        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        customBackgroundView.layer.cornerRadius = 10.0
        customBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        customBackgroundView.backgroundColor = UIColor(named: KeyColorName.violetsAreBlue)?.withAlphaComponent(alphaValue)
        self.contentView.addSubview(customBackgroundView)
        
        customBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        customBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // CardsNumberLabel
        var cardsNumberLabel = UILabel(frame: .zero)
        cardsNumberLabel = numberLabel
        cardsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        cardsNumberLabel.clipsToBounds = true
        cardsNumberLabel.text = "hi"
        cardsNumberLabel.backgroundColor = .white
        cardsNumberLabel.layer.cornerRadius = 10
        cardsNumberLabel.textColor = UIColor(named: KeyColorName.violetsAreBlue)
        customBackgroundView.addSubview(cardsNumberLabel)
        
        cardsNumberLabel.topAnchor.constraint(equalTo: customBackgroundView.topAnchor,constant: 5).isActive = true
        cardsNumberLabel.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor,constant: -5).isActive = true
        cardsNumberLabel.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor,constant: 5).isActive = true
        cardsNumberLabel.trailingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor,constant: 20).isActive = true
        customBackgroundView.bringSubviewToFront(cardsNumberLabel)
                
        // ColumnTitleLabel
        var columnTitleLabel = UILabel(frame: .zero)
        columnTitleLabel = titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        columnTitleLabel.textColor = .white
        customBackgroundView.addSubview(titleLabel)
        columnTitleLabel.topAnchor.constraint(equalTo: cardsNumberLabel.topAnchor).isActive = true
        columnTitleLabel.bottomAnchor.constraint(equalTo: cardsNumberLabel.bottomAnchor).isActive = true
        columnTitleLabel.leadingAnchor.constraint(equalTo: cardsNumberLabel.trailingAnchor,constant: 10).isActive = true
        columnTitleLabel.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor,constant: -25).isActive = true
        
        // addCardButoon
        let addCardButton = UIButton(frame: .zero)
        addCardButton.translatesAutoresizingMaskIntoConstraints = false
        addCardButton.tintColor = .white
        addCardButton.setImage(UIImage(systemName: SystemImageName.plus), for: .normal)
        customBackgroundView.addSubview(addCardButton)
        addCardButton.topAnchor.constraint(equalTo: customBackgroundView.topAnchor).isActive = true
        addCardButton.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor).isActive = true
        addCardButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        addCardButton.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor).isActive = true
    }
}
