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
        let diceVC = createNavController(vc: DiceViewController(), imageName: "house", selectedImageName: "house.fill", title: "Home")
        
        viewControllers = [diceVC]
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
