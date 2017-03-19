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
    let submitButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    
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
        

        
        // Set up the submit button
        submitButton.frame = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100)
        submitButton.setTitle("Next", for: .normal)
        submitButton.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        submitButton.addTarget(self, action: #selector(self.submitButtonPressed), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        backButton.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    
    // Called when the submitButton's pressed
    func submitButtonPressed() {
        print("Submit Button pressed! You typed: \(textBox.text!)")
        UserData.sharedInstance.userVenueLocation = textBox.text!
        let mapViewController = MapViewController()
        self.present(mapViewController, animated: true, completion: nil)
    }
    
    func backButtonPressed() {
        print("Back Button pressed!")
        let userTypeController = UserTypeController()
        self.present(userTypeController, animated: true, completion: nil)
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



