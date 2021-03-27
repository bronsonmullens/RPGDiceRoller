//
//  MacrosViewController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/22/21.
//

import UIKit

class MacrosViewController: UIViewController {
    
    // MARK: - Properties
    
    var diceController = DiceController.shared
    let reuseIdentifier = "MacroCell"
    
    lazy var macroCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: macroLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    }()
    
    let macroLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: 240, height: 96)
        return layout
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Macros"
        configureViews()
        configureColors()
        for macro in diceController.macros {
            print(macro.title)
        }
    }
    
    func configureViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMacro))
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Foreground")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - OBJC Methods
    
    @objc func addMacro() {
        var tempDice: [Dice] = []
        let d4 = Dice()
        d4.name = "D4"
        d4.sides = 4
        tempDice.append(d4)
        diceController.createMacro(title: "Test",
                                   amount: 1,
                                   modifier: 0,
                                   isFavorite: false,
                                   dice: tempDice)
        for macro in diceController.macros {
            print(macro.title ?? "Nada")
        }
    }
    
}

extension MacrosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diceController.macros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MacroCell else { return UICollectionViewCell() }
        return cell
    }
    
}
