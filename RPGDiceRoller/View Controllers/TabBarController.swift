//
//  TabBarController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBlue
        configureTabBar()
    }
    
    func configureTabBar() {
        let diceVC = createNavController(vc: DiceViewController(), imageName: "cube", selectedImageName: "cube.fill", title: "Home")
        let macrosVC = createNavController(vc: MacrosViewController(), imageName: "rectangle.stack", selectedImageName: "rectangle.stack.fill", title: "Macros")
        let settingsVC = createNavController(vc: SettingsViewController(), imageName: "gearshape", selectedImageName: "gearshape.fill", title: "Settings")
        
        viewControllers = [diceVC, macrosVC, settingsVC]
        tabBar.barTintColor = UIColor(named: "Foreground")
        tabBar.tintColor = .white
    }

}

extension UITabBarController {
    
    func createNavController(vc: UIViewController, imageName: String, selectedImageName: String, title: String) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.tabBarItem.image = UIImage(systemName: selectedImageName)
        return navController
    }
    
}
