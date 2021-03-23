//
//  SettingsHeaderView.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/22/21.
//

import UIKit

class SettingsHeaderView: UIView {
    
    // MARK: - Properties
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainIcon.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let appVersionLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        appVersionLabel.text = "App Version: \(UIApplication.appVersion!)"
        appVersionLabel.font = UIFont(name: "Helvetica", size: 18)
        appVersionLabel.textAlignment = .center
        appVersionLabel.textColor = .white
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appVersionLabel)
        
        appIconImageView.layer.cornerRadius = 12
        appIconImageView.backgroundColor = .white
        self.addSubview(appIconImageView)
        
        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            appIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            appIconImageView.widthAnchor.constraint(equalToConstant: 96),
            appIconImageView.heightAnchor.constraint(equalToConstant: 96),
            
            appVersionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            appVersionLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 12),
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
