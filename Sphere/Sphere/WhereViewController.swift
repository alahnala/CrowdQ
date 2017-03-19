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
        
        //set up tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        // Set up the button
        button.frame = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100)
        button.setTitle("Next", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        self.view.addSubview(button)
        // displayText()
    }
    
    
    // Called when the button's pressed
    func buttonPressed() {
        print("Button pressed! You typed: \(textBox.text!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // return name and coordinates
    
    
}



