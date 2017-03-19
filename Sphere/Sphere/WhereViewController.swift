//
//  File.swift
//  Sphere
//
//  Created by Allie Lahnala on 3/16/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import UIKit
import Foundation

class WhereViewController : UIViewController {
    
    let textBox = UITextField()
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Where"
        self.view.backgroundColor = UIColor.gray
        
        // Set up the text box
        textBox.frame = CGRect(x: 20, y: 200, width: self.view.bounds.width - 20, height: 40)
        textBox.center.x = self.view.center.x
        textBox.textAlignment = .justified
        textBox.backgroundColor = UIColor.white
        textBox.borderStyle = .roundedRect
        textBox.placeholder = "Enter text here"
        self.view.addSubview(textBox)
        
        
        // Set up the button
        button.frame = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100)
        button.setTitle("Next", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        self.view.addSubview(button)
        // displayText()
    }
    
//    func displayText() {
//        let textBox = UITextField(frame: CGRect(x: 100, y: 250, width: 200, height: 40.00))
//        self.view.addSubview(textBox)
//        textBox.backgroundColor = UIColor.red
//        textBox.text = "Welcome 2 tha f33d."
//        textBox.borderStyle = UITextBorderStyle.line
//    }
    
    // Called when the button's pressed
    func buttonPressed() {
        print("Button pressed! You typed: \(textBox.text!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



