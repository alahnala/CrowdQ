//
//  UserClassification.swift
//  Sphere
//
//  Created by Xinrui Yang on 3/16/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

// Decide whether vendor or explorer upon sign in ]

import Foundation
import UIKit

class UserTypeController: UIViewController, SSRadioButtonControllerDelegate {
    
    @IBOutlet weak var vendor: UIButton!
    @IBOutlet weak var explorer: UIButton!
    
    var radioButtonController: SSRadioButtonsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioButtonController = SSRadioButtonsController(buttons: vendor, explorer)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func didSelectButton(aButton: UIButton?) {
        print(aButton as Any)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
