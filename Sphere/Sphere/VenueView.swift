//
//  VenueView.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/21/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class VenueView : UIView {
    
    let backButton = UIButton(type: .system)
    let textField = UITextField()
    
    /*
     *  Create all necessary buttons and text fields
     */
    init(marker: GMSMarker) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.white
        
        // Add backbutton
        self.backButton.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        self.backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1), for: .normal)
        self.backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.5), for: .selected)
        self.backButton.setTitle("Back", for: .normal)
        self.backButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        
        self.textField.frame = CGRect(x: 250, y: 250, width: 200, height: 40.00)
        self.textField.backgroundColor = UIColor.black
        self.textField.textColor = UIColor.white
        self.textField.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        self.textField.text = marker.title
        self.textField.textAlignment = .center
        self.textField.borderStyle = UITextBorderStyle.line
    }
    
    /*
     *  Add initialized views as subviews
     */
    func initializeAllViews() {
        self.addSubview(self.backButton)
        self.addSubview(self.textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
