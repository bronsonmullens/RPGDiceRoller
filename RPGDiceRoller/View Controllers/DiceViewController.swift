//
//  DiceViewController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class DiceViewController: UIViewController {
    
    // MARK: - Properties
    
    let diceController = DiceController()
    let diceReuseIdentifier = "DiceCell"
    
    lazy var diceCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: diceLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: diceReuseIdentifier)
        return collectionView
    }()
    
    let diceLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: 96, height: 96)
        return layout
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diceCollectionView.delegate = self
        diceCollectionView.dataSource = self
        view.backgroundColor = .systemGray
        diceController.getAllDice()
        configureViews()
        for die in diceController.diceBag {
            print("Your dice bag contains a: D\(die.sides)")
        }
    }
    
    // MARK: - Autolayout
    
    func configureViews() {
        view.addSubview(diceCollectionView)
        
        diceCollectionView.register(DiceCell.self, forCellWithReuseIdentifier: diceReuseIdentifier)
        
        diceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        diceCollectionView.backgroundColor = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDie))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(removeAllDice))
        
        NSLayoutConstraint.activate([
            diceCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            diceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            diceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            diceCollectionView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    // MARK: - OBJC Methods
    
    @objc func addDie() {
        let alert = UIAlertController(title: "Add Dice",
                                      message: "How many sides does your dice have?",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default){ (_) in
            guard let field = alert.textFields?.first, let sides = field.text else { return }
            self.diceController.createDice(name: "D\(sides)", sides: Int(sides) ?? 0)
            DispatchQueue.main.async {
                let indexPath = IndexPath(arrayLiteral: 0,self.diceController.diceBag.count-1)
                self.diceCollectionView.insertItems(at: [indexPath])
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.keyboardType = .numberPad
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func removeAllDice() {
        diceController.deleteAllDice()
        diceCollectionView.reloadData()
    }
    
}

    // MARK: - Collection View Delegate & Data Source Methods

extension DiceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diceController.diceBag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: diceReuseIdentifier, for: indexPath) as? DiceCell else { return UICollectionViewCell() }
        let dice = diceController.diceBag[indexPath.row]
        cell.diceLabel.text = dice.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(diceController.diceBag[indexPath.row])")
    }
    
}
