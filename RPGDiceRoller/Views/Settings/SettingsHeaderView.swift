//
//  SettingsHeaderView.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/22/21.
//

import UIKit

class SettingsHeaderView: UIView {
    
    // MARK: - Properties
    
    let appIcon = UIImage(named: "AppIcon")
    let appVersionLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        appVersionLabel.text = "App Version: \(UIApplication.appVersion!)"
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appVersionLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
