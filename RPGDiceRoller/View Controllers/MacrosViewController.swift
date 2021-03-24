//
//  MacrosViewController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/22/21.
//

import UIKit

class MacrosViewController: UIViewController {
    
    // MARK: - Properties
    
    let diceController = DiceController.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Macros"
        configureViews()
        configureColors()
    }
    
    func configureViews() {
        // TODO
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Foreground")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
}
