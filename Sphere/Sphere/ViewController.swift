//
//  ViewController.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 1/17/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make Tab One
        let mapTab = MapViewController()
        mapTab.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "globe.png"), selectedImage: UIImage(named: "globe.png"))
        
        // Make Tab Two
        let feedTab = FeedViewController()
        feedTab.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "paper.png"), selectedImage: UIImage(named: "paper.png"))
        
<<<<<<< HEAD
        // TODO move to xinrui's folder when she pushes
        let whereTab = WhereViewController()
        whereTab.tabBarItem = UITabBarItem(title: "Where", image: UIImage(named: "paper.png"), selectedImage: UIImage(named: "paper.png"))
        
        self.viewControllers = [mapTab, feedTab, whereTab]
=======
        // Make Tab Three
        let userTab = UserTypeController()
        userTab.tabBarItem = UITabBarItem(title: "User", image: UIImage(named: "paper.png"), selectedImage: UIImage(named: "paper.png"))
        
        self.viewControllers = [mapTab, feedTab, userTab]
>>>>>>> e86d320952acde437e5e139219a53ef89a476b44
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
