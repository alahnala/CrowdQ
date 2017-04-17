//
//  WhereView.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/21/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class WhereView : UIView {
    
    let backButton = UIButton(type: .system)
    let submitButton = UIButton(type: .system)
    
    /*
     *  Create all necessary buttons and text fields
     */
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black
        self.backButton.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        self.backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1), for: .normal)
        self.backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.5), for: .selected)
        self.backButton.setTitle("Back", for: .normal)
        self.backButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        
        self.submitButton.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        self.submitButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1), for: .normal)
        self.submitButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.5), for: .selected)
        self.submitButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
        self.submitButton.setTitle("Submit", for: .normal)
        
    }

    /*
     *  Add initialized views as subviews
     */
    func initializeAllViews() {
        self.addSubview(backButton)
        self.addSubview(submitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
