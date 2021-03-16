//
//  ResultCell.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class ResultCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var resultLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        resultLabel.font = UIFont(name: "Helvetica", size: 14)
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.textAlignment = .center
        resultLabel.textColor = .white
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(resultLabel)
        
        self.backgroundColor = .none
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: -3, height: 3)
        self.layer.cornerRadius = 12.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 6.0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
