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
        
        self.viewControllers = [mapTab, feedTab]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

