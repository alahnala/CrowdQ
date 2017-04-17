//
//  WhoViewController.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/29/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import Dispatch

class WhoViewController : UIViewController, UITextFieldDelegate {
    
    let whoView = WhoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Who"
        self.whoView.nameTextField.delegate = self
        self.view = whoView
        self.whoView.initializeAllViews()
        
        self.whoView.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.whoView.submitButton.addTarget(self, action: #selector(self.submitButtonPressed), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed() {
        let userTypeController = UserTypeController()
        self.present(userTypeController, animated: true, completion: nil)
    }
    
    func submitButtonPressed() {
        
        // If there's no text in the textfield...
        if (self.whoView.nameTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Whoa there!", message: "You gotta fill out them text fields!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let jsonPostString = ""
        
        if !UserData.sharedInstance.sentInfo {
            RestManager.sharedInstance.registerExplorer(userId: UserData.sharedInstance.userId, name: self.whoView.nameTextField.text!)
            UserData.sharedInstance.sentInfo = true
        }
        
        DispatchQueue.main.async {
            let mapViewController = MapViewController()
            self.present(mapViewController, animated: true, completion: nil)
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text!)
        return true
    }
}
