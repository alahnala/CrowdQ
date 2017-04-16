//
//  UserTypeView.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/21/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import UIKit

class UserTypeView : UIView {
    
    let label = UILabel()
    let vendorButton = UIButton()
    let explorerButton = UIButton()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        // Set up the label button
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 75)
        label.textColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.width / 3)
        label.textAlignment = .center
        label.text = "I am a ..."
        label.font = label.font.withSize(45)
        
        // Set up the vendor button
        self.vendorButton.setTitle("Vendor", for: .normal)
        self.vendorButton.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        self.vendorButton.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        self.vendorButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 100)
        self.vendorButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 30)
        self.vendorButton.layer.cornerRadius = 10
        
        // Set up the explorer button
        self.explorerButton.setTitle("Explorer", for: .normal)
        self.explorerButton.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        self.explorerButton.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        self.explorerButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 100)
        self.explorerButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.5)
        self.explorerButton.layer.cornerRadius = 10
    }
    
    func initializeAllViews() {
        self.addSubview(self.label)
        self.addSubview(self.vendorButton)
        self.addSubview(self.explorerButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
