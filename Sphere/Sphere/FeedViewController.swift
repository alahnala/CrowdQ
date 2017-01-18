//
//  FeedViewController.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 1/17/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import UIKit
import Foundation

class FeedViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayText()
        self.title = "Feed"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayText() {
        let textBox = UITextField(frame: CGRect(x: 100, y: 250, width: 200, height: 40.00))
        self.view.addSubview(textBox)
        textBox.backgroundColor = UIColor.red
        textBox.text = "Welcome 2 tha f33d."
        textBox.borderStyle = UITextBorderStyle.line
    }
}
