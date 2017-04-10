//
//  WhoView.swift
//  
//
//  Created by Chuckry Vengadam on 3/29/17.
//
//

import Foundation

class WhoView : UIView {
    
    let nameTextField = UITextField()
    let backButton = UIButton(type: .system)
    let submitButton = UIButton(type: .system)
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black
        self.nameTextField.backgroundColor = UIColor.white
        self.nameTextField.placeholder = "What's your name"
        self.nameTextField.frame = CGRect(x: 0, y: 150, width: 300, height: 60)
        self.nameTextField.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
        self.nameTextField.textAlignment = .center
        self.nameTextField.returnKeyType = .done
        self.nameTextField.layer.cornerRadius = 5
        
        
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
    
    func initializeAllViews() {
        self.addSubview(self.nameTextField)
        self.addSubview(self.backButton)
        self.addSubview(self.submitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
