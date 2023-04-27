//
//  MainTabBarController.swift
//  Simpsonsviewer
//
//  Created by Venkata K on 4/27/23.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let simpsonsListVC = SimpsonsCharactersListViewController()
        simpsonsListVC.title = "The Simpsons"
        let simpsonsNavController = UINavigationController(rootViewController: simpsonsListVC)
        simpsonsNavController.navigationBar.prefersLargeTitles = true
        simpsonsNavController.tabBarItem = UITabBarItem(title: "The Simpsons", image: UIImage(named: "simpsonsIcon"), tag: 0)

        let wireListVC = WireCharactersListViewController()
        wireListVC.title = "The Wire"
        let wireNavController = UINavigationController(rootViewController: wireListVC)
        wireNavController.navigationBar.prefersLargeTitles = true
        wireNavController.tabBarItem = UITabBarItem(title: "The Wire", image: UIImage(named: "wireIcon"), tag: 1)

        viewControllers = [simpsonsNavController, wireNavController]
    }
}
