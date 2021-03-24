//
//  DiceViewController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class DiceViewController: UIViewController, DiceControllerDelegate {
    
    // MARK: - Properties
    
    let diceController = DiceController.shared
    let defaults = UserDefaults.standard
    let diceReuseIdentifier = "DiceCell"
    let rolledReuseIdentifier = "RolledCell"
    
    var recentRoll: String = ""
    var advantage: Bool = false
    var disadvantage: Bool = false
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
        diceCollectionView.dragDelegate = self
        diceCollectionView.dropDelegate = self
        rolledCollectionView.delegate = self
        rolledCollectionView.dataSource = self
        diceController.delegate = self
        diceController.getAllDice()
        configureViews()
        configureColors()
        emptyDiceBagCheck()
    }
    
    // MARK: - Autolayout
    
    func configureViews() {
        view.addSubview(diceCollectionView)
        view.addSubview(rolledCollectionView)
        view.addSubview(resultView)
        view.addSubview(modifierView)
        
        diceCollectionView.register(DiceCell.self,
                                    forCellWithReuseIdentifier: diceReuseIdentifier)
        diceCollectionView.dragInteractionEnabled = true
        rolledCollectionView.register(ResultCell.self,
                                      forCellWithReuseIdentifier: rolledReuseIdentifier)
        
        diceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        rolledCollectionView.translatesAutoresizingMaskIntoConstraints = false
        resultView.translatesAutoresizingMaskIntoConstraints = false
        modifierView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDice))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        modifierView.dicePoolStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        modifierView.dicePoolStepper.minimumValue = 1
        modifierView.advantageSwitch.addTarget(self, action: #selector(advantageToggled), for: .valueChanged)
        modifierView.disadvantageSwitch.addTarget(self, action: #selector(disadvantageToggled), for: .valueChanged)
        
        // Starts hidden
        resultView.secondaryDiceResultLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            modifierView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            modifierView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modifierView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            modifierView.heightAnchor.constraint(equalToConstant: 120),
            
            diceCollectionView.bottomAnchor.constraint(equalTo: modifierView.topAnchor, constant: -16),
            diceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            diceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            diceCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            rolledCollectionView.bottomAnchor.constraint(equalTo: diceCollectionView.topAnchor, constant: -16),
            rolledCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            rolledCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rolledCollectionView.heightAnchor.constraint(equalToConstant: 48),
            
            resultView.bottomAnchor.constraint(equalTo: rolledCollectionView.topAnchor, constant: -16),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultView.topAnchor.constraint(equalTo: view.topAnchor, constant: 132),
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
    
    func configureResultLabel() {
        resultView.diceResultLabel.text = "0"
        resultView.secondaryDiceResultLabel.text = "0"
        
        if !advantage && !disadvantage {
            resultView.secondaryDiceResultLabel.isHidden = true
            resultView.diceResultLabel.font = UIFont(name: "Helvetica", size: 60)
            resultView.diceResultLabel.textColor = .white
        } else {
            resultView.secondaryDiceResultLabel.isHidden = false
        }
        
        if advantage {
            resultView.diceResultLabel.font = UIFont(name: "Helvetica", size: 60)
            resultView.diceResultLabel.textColor = .systemGreen
            resultView.secondaryDiceResultLabel.font = UIFont(name: "Helvetica", size: 32)
            resultView.secondaryDiceResultLabel.textColor = .white
        } else if disadvantage {
            resultView.diceResultLabel.font = UIFont(name: "Helvetica", size: 32)
            resultView.diceResultLabel.textColor = .white
            resultView.secondaryDiceResultLabel.font = UIFont(name: "Helvetica", size: 60)
            resultView.secondaryDiceResultLabel.textColor = .systemRed
        }
    }
    
    // MARK: - Methods
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                diceController.diceBag.remove(at: sourceIndexPath.item)
                diceController.diceBag.insert(item.dragItem.localObject as! Dice, at: destinationIndexPath.item)
                diceCollectionView.deleteItems(at: [sourceIndexPath])
                diceCollectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            diceController.save()
        }
    }
    
    func animateLabel(animate label: UILabel) {
        UIView.animate(withDuration: 0.4) {
            label.transform = CGAffineTransform(scaleX: 6, y: 6)
            label.transform = .identity
        }
    }
    
    func emptyDiceBagCheck() {
        if diceController.diceBag.isEmpty {
            let alert = UIAlertController(title: "Your dice bag is empty!", message: "Would you like to fill your dice bag automatically with a standard array of RPG Dice?", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Yes!", style: .default) { (_) in
                let d4 = self.diceController.createDice(name: "D4", sides: 4)
                let d6 = self.diceController.createDice(name: "D6", sides: 6)
                let d8 = self.diceController.createDice(name: "D8", sides: 8)
                let d10 = self.diceController.createDice(name: "D10", sides: 10)
                let d12 = self.diceController.createDice(name: "D12", sides: 12)
                let d20 = self.diceController.createDice(name: "D20", sides: 20)
                let d100 = self.diceController.createDice(name: "D100", sides: 100)
                
                if d4, d6, d8, d10, d12, d20, d100 {
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(arrayLiteral: 0,self.diceController.diceBag.count-1)
                        self.diceCollectionView.insertItems(at: [indexPath])
                    }
                }
            }
            
            let denyAction = UIAlertAction(title: "Nah, I'll do it the hard way.", style: .cancel) { (_) in
                NSLog("User did not add default dice.")
            }
            alert.addAction(confirmAction)
            alert.addAction(denyAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Dice Controller Delegate Methods
    
    func diceWereDeleted() {
        reset()
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
    
    @objc func reset() {
        diceCollectionView.reloadData()
        rolledHistory = []
        advantage = false
        disadvantage = false
        configureResultLabel()
        amountToRoll = 1
        modifierView.advantageSwitch.isOn = false
        modifierView.disadvantageSwitch.isOn = false
        modifierView.dicePoolStepper.value = 1
        modifierView.dicePoolLabel.text = "Amount Rolled: 1"
    }
    
    @objc func stepperChanged() {
        let stepperValue = Int(modifierView.dicePoolStepper.value)
        amountToRoll = stepperValue
        modifierView.dicePoolLabel.text = "Amount Rolled: \(stepperValue)"
    }
    
    @objc func advantageToggled() {
        advantage.toggle()
        if advantage {
            disadvantage = false
            modifierView.disadvantageSwitch.isOn = false
        }
        configureResultLabel()
    }
    
    @objc func disadvantageToggled() {
        disadvantage.toggle()
        if disadvantage {
            advantage = false
            modifierView.advantageSwitch.isOn = false
        }
        configureResultLabel()
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
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.15) {
                    cell.transform = CGAffineTransform(scaleX: 1.50, y: 1.50)
                    cell.transform = .identity
                }
            }
            
            var results = [0,0]
            var mainRoll = ""
            
            if advantage {
                results = diceController.rollWithAdvantage(sides: Int(diceController.diceBag[indexPath.row].sides), amount: amountToRoll)
                mainRoll = String(results[0])
                resultView.diceResultLabel.text = String(results[0])
                resultView.secondaryDiceResultLabel.text = String(results[1])
                if results[0] == diceController.diceBag[indexPath.row].sides {
                    animateLabel(animate: resultView.diceResultLabel)
                }
            } else if disadvantage {
                results = diceController.rollWithDisadvantage(sides: Int(diceController.diceBag[indexPath.row].sides), amount: amountToRoll)
                mainRoll = String(results[1])
                resultView.diceResultLabel.text = String(results[0])
                resultView.secondaryDiceResultLabel.text = String(results[1])
                if results[1] == diceController.diceBag[indexPath.row].sides {
                    animateLabel(animate: resultView.secondaryDiceResultLabel)
                }
            } else {
                results = diceController.roll(sides: Int(diceController.diceBag[indexPath.row].sides), amount: amountToRoll)
                mainRoll = String(results[0])
                resultView.diceResultLabel.text = String(results[0])
                if results[0] == diceController.diceBag[indexPath.row].sides {
                    animateLabel(animate: resultView.diceResultLabel)
                }
            }
            recentRoll = mainRoll
            rolledHistory.append(mainRoll)
            
            let lastRolled = IndexPath(row: rolledHistory.count-1, section: 0)
            rolledCollectionView.scrollToItem(at: lastRolled, at: .right, animated: true)
        }
    }
    
}

// MARK: - Drag Delegate Methods

extension DiceViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if collectionView == self.diceCollectionView {
            let item = diceController.diceBag[indexPath.row]
            let itemProvider = NSItemProvider(object: item.name! as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        } else {
            return [UIDragItem]()
        }
    }
    
}

extension DiceViewController: UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if self.diceCollectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if collectionView == self.diceCollectionView {
            var destinationIndexPath: IndexPath
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                let row = self.diceCollectionView.numberOfItems(inSection: 0)
                destinationIndexPath = IndexPath(item: row - 1, section: 0)
            }
            
            if coordinator.proposal.operation == .move {
                self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            }
        }
    }
    
}
