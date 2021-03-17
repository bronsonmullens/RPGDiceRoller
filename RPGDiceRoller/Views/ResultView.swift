//
//  ResultView.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class ResultView: UIView {
    
    // MARK: - Properties
    
    var resultLabel: UILabel = UILabel()
    var diceResultLabel: UILabel = UILabel()
    
    // MARK: - Initializiers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configuring result label
        resultLabel.text = "RESULT"
        resultLabel.font = UIFont(name: "Helvetica", size: 18)
        resultLabel.textAlignment = .center
        resultLabel.textColor = .white
        self.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configuring dice result label
        diceResultLabel.text = "0"
        diceResultLabel.font = UIFont(name: "Helvetica", size: 60)
        diceResultLabel.textAlignment = .center
        diceResultLabel.textColor = .white
        self.addSubview(diceResultLabel)
        diceResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            resultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            resultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            diceResultLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 8),
            diceResultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            diceResultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
