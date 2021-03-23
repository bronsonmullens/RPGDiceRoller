//
//  SettingsViewController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/22/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    enum settings: String {
        case whatsNew = "🗞 What's New?"
        case twitter = "🐦 Twitter"
        case tipJar = "💰 Tip Jar"
        case rateTheApp = "⭐️ Rate the App"
        case feedback = "🦻🏻 Feedback"
        case helpfulTips = "🆘 Helpful Tips"
        case privacyPolicy = "⚖️ Privacy Policy"
        case deleteAllDice = "🗑 Delete All Dice"
        case deleteAllMacros = "🗑 Delete All Macros"
    }
    
    let sectionOne: [settings] = [
        settings.whatsNew,
        settings.twitter,]
    let sectionTwo: [settings] = [
        settings.tipJar,
        settings.rateTheApp,
        settings.feedback,
        settings.helpfulTips,]
    let sectionThree: [settings] = [
        settings.deleteAllDice,
        settings.deleteAllMacros,]
    
    let staticSettings: [[String]] = [
        [settings.whatsNew.rawValue,
         settings.twitter.rawValue],
        
        [settings.tipJar.rawValue,
         settings.rateTheApp.rawValue,
         settings.feedback.rawValue,
         settings.helpfulTips.rawValue],
        
        [settings.deleteAllDice.rawValue,
         settings.deleteAllMacros.rawValue],
    ]
    
    lazy var numberOfRows = [sectionOne.count,
                             sectionTwo.count,
                             sectionThree.count,]
    
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    let settingsHeaderView = SettingsHeaderView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
        configureViews()
        configureColors()
    }
    
    func configureViews() {
        view.addSubview(tableView)
        view.addSubview(settingsHeaderView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        settingsHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            settingsHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsHeaderView.heightAnchor.constraint(equalToConstant: view.bounds.height/6),
            
            tableView.topAnchor.constraint(equalTo: settingsHeaderView.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Foreground")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        tableView.backgroundColor = .none
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        staticSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        if let textLabel = cell.textLabel {
            textLabel.text = staticSettings[indexPath.section][indexPath.row]
            textLabel.textColor = .white
            textLabel.font = .boldSystemFont(ofSize: 16)
            cell.backgroundColor = UIColor(named: "Foreground")
        }
        return cell
    }
    
}
