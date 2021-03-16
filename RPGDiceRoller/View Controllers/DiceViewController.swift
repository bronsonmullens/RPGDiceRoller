//
//  DiceViewController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class DiceViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    // MOCK DATA
    var diceBag = [3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 20, 24, 30, 100]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diceCollectionView.delegate = self
        diceCollectionView.dataSource = self
        view.backgroundColor = .systemGray
        configureViews()
    }
    
    // MARK: - Autolayout
    
    func configureViews() {
        view.addSubview(diceCollectionView)
        
        diceCollectionView.register(DiceCell.self, forCellWithReuseIdentifier: diceReuseIdentifier)
        
        diceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        diceCollectionView.backgroundColor = .none
        
        NSLayoutConstraint.activate([
            diceCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            diceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            diceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            diceCollectionView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
}

    // MARK: - Collection View Delegate & Data Source Methods

extension DiceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diceBag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: diceReuseIdentifier, for: indexPath) as? DiceCell else { return UICollectionViewCell() }
        cell.diceLabel.text = "\(diceBag[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(diceBag[indexPath.row])")
    }
    
}
