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
    var secondaryDiceResultLabel: UILabel = UILabel()
    
    lazy var resultStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [diceResultLabel,
                                                       secondaryDiceResultLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        diceResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Optional second label for rolls with advantage/disadvantage
        secondaryDiceResultLabel.text = "0"
        secondaryDiceResultLabel.font = UIFont(name: "Helvetica", size: 60)
        secondaryDiceResultLabel.textAlignment = .center
        secondaryDiceResultLabel.textColor = .white
        secondaryDiceResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(resultStackView)
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            resultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            resultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            resultStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            resultStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            resultStackView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
