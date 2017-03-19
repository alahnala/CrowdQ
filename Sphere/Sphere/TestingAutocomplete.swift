//
//  TestingAutocomplete.swift
//  Sphere
//
//  Created by Allie Lahnala on 3/19/17.
//  Copyright © 2017 EECS441. All rights reserved.
//


import UIKit
import Foundation

class TestViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"
        displayText()
    }
    
    func displayText() {
        let textBox = UITextField(frame: CGRect(x: 100, y: 250, width: 200, height: 40.00))
        self.view.addSubview(textBox)
        textBox.backgroundColor = UIColor.red
        textBox.text = "Welcome 2 tha f33d."
        textBox.borderStyle = UITextBorderStyle.line
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
