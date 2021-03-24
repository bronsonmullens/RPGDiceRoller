//
//  DiceCell.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class DiceCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var diceLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        diceLabel.font = UIFont(name: "Helvetica", size: 32)
        diceLabel.adjustsFontSizeToFitWidth = true
        diceLabel.textAlignment = .center
        diceLabel.textColor = .white
        diceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(diceLabel)
        
        self.backgroundColor = .none
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 12.0
        self.layer.borderWidth = 3.0
        self.layer.cornerRadius = 12.0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            diceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            diceLabel.widthAnchor.constraint(equalToConstant: self.frame.width)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
