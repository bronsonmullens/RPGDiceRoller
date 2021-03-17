//
//  ModifierView.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/17/21.
//

import UIKit

class ModifierView: UIView {
    
    // MARK: - Properties
    
    var advantageSwitch: UISwitch = UISwitch()
    var dicePoolStepper: UIStepper = UIStepper()
    var advantageLabel: UILabel = UILabel()
    var dicePoolLabel: UILabel = UILabel()
    
    lazy var advantageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [advantageLabel,
                                                       advantageSwitch])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var dicePoolStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dicePoolLabel,
                                                       dicePoolStepper])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        advantageLabel.text = "Advantage"
        advantageLabel.font = UIFont(name: "Helvetica", size: 18)
        advantageLabel.textAlignment = .center
        advantageLabel.textColor = .white
        self.addSubview(advantageStackView)
        
        dicePoolLabel.text = "Amount Rolled: 1"
        dicePoolLabel.font = UIFont(name: "Helvetica", size: 18)
        dicePoolLabel.textAlignment = .center
        dicePoolLabel.textColor = .white
        self.addSubview(dicePoolStackView)
        
        NSLayoutConstraint.activate([
            advantageStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            advantageStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            
            dicePoolStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dicePoolStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
