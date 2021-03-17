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
    let defaults = UserDefaults.standard
    let diceReuseIdentifier = "DiceCell"
    let rolledReuseIdentifier = "RolledCell"
    
    var recentRoll: String = ""
    var advantage: Bool = false
    var amountToRoll: Int = 1
    var rolledHistory: [String] = [] {
        didSet {
            rolledCollectionView.reloadData()
        }
    }
    
    lazy var diceCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: diceLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: diceReuseIdentifier)
        return collectionView
    }()
    
    lazy var rolledCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: rolledLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: rolledReuseIdentifier)
        return collectionView
    }()
    
    let diceLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: 96, height: 96)
        return layout
    }()
    
    let rolledLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: 32, height: 32)
        return layout
    }()
    
    let resultView = ResultView()
    let modifierView = ModifierView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dice Roller"
        diceCollectionView.delegate = self
        diceCollectionView.dataSource = self
        rolledCollectionView.delegate = self
        rolledCollectionView.dataSource = self
        diceController.getAllDice()
        configureViews()
        configureColors()
        // diceController.deleteAllDice() // WARNING: DELETES ALL STORED DICE
    }
    
    // MARK: - Autolayout
    
    func configureViews() {
        view.addSubview(diceCollectionView)
        view.addSubview(rolledCollectionView)
        view.addSubview(resultView)
        view.addSubview(modifierView)
        
        diceCollectionView.register(DiceCell.self,
                                    forCellWithReuseIdentifier: diceReuseIdentifier)
        rolledCollectionView.register(ResultCell.self,
                                      forCellWithReuseIdentifier: rolledReuseIdentifier)
        
        diceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        rolledCollectionView.translatesAutoresizingMaskIntoConstraints = false
        resultView.translatesAutoresizingMaskIntoConstraints = false
        modifierView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDice))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(clearHistory))
        modifierView.dicePoolStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        modifierView.dicePoolStepper.minimumValue = 1
        modifierView.advantageSwitch.addTarget(self, action: #selector(advantageToggled), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            modifierView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            modifierView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modifierView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            modifierView.heightAnchor.constraint(equalToConstant: 120),
            
            diceCollectionView.bottomAnchor.constraint(equalTo: modifierView.topAnchor, constant: -16),
            diceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            diceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            diceCollectionView.heightAnchor.constraint(equalToConstant: 340),
            
            rolledCollectionView.bottomAnchor.constraint(equalTo: diceCollectionView.topAnchor, constant: -16),
            rolledCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            rolledCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rolledCollectionView.heightAnchor.constraint(equalToConstant: 48),
            
            resultView.bottomAnchor.constraint(equalTo: rolledCollectionView.topAnchor, constant: -16),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
        ])
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Foreground")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        diceCollectionView.backgroundColor = .none
        rolledCollectionView.backgroundColor = .none
        resultView.backgroundColor = .none
        modifierView.backgroundColor = .none
    }
    
    // MARK: - OBJC Methods
    
    @objc func addDice() {
        var diceCreated: Bool = false
        let alert = UIAlertController(title: "Add Dice",
                                      message: "How many sides does your dice have?",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default){ (_) in
            guard let field = alert.textFields?.first, let sides = field.text else { return }
            diceCreated = self.diceController.createDice(name: "D\(sides)", sides: Int(sides) ?? 0)
            if !diceCreated {
                let alert = UIAlertController(title: "Error",
                                              message: "That dice already exists.",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok",
                                           style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
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
    
    @objc func clearHistory() {
        rolledHistory = []
    }
    
    @objc func stepperChanged() {
        let stepperValue = Int(modifierView.dicePoolStepper.value)
        amountToRoll = stepperValue
        modifierView.dicePoolLabel.text = "Amount Rolled: \(stepperValue)"
        print(stepperValue)
    }
    
    @objc func advantageToggled() {
        advantage.toggle()
        print(advantage)
    }
    
}

    // MARK: - Collection View Delegate & Data Source Methods

extension DiceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.diceCollectionView {
            return diceController.diceBag.count
        } else {
            return rolledHistory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.diceCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: diceReuseIdentifier, for: indexPath) as? DiceCell else { return UICollectionViewCell() }
            let dice = diceController.diceBag[indexPath.row]
            cell.diceLabel.text = dice.name
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rolledReuseIdentifier, for: indexPath) as? ResultCell else { return UICollectionViewCell() }
            cell.resultLabel.text = rolledHistory[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if collectionView == self.diceCollectionView {
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform(scaleX: 1.50, y: 1.50)
                cell.transform = .identity
            }
            let result: Int = diceController.roll(sides: Int(diceController.diceBag[indexPath.row].sides))
            print(result)
            
            recentRoll = String(diceController.roll(sides: Int(diceController.diceBag[indexPath.item].sides)))
            rolledHistory.append(recentRoll)
            
            let lastRolled = IndexPath(row: rolledHistory.count-1, section: 0)
            resultView.diceResultLabel.text = recentRoll
            rolledCollectionView.scrollToItem(at: lastRolled, at: .right, animated: true)
            
            if recentRoll == String(diceController.diceBag[indexPath.row].sides) {
                resultView.diceResultLabel.textColor = .systemRed
                UIView.animate(withDuration: 0.25) {
                    self.resultView.diceResultLabel.transform = CGAffineTransform(scaleX: 2.50, y: 2.50)
                    self.resultView.diceResultLabel.transform = .identity
                }
            } else {
                resultView.diceResultLabel.textColor = .white
            }
        }
    }
    
}
