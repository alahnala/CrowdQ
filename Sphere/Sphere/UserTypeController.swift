
//
//  UserTypeController.swift
//  Sphere
//
//  Created by Xinrui Yang on 3/16/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

// After Spotify sign in, makes post request to server 
// in order to provide info about user account type (vendor vs. explorer)

import Foundation
import UIKit

class UserTypeController: UIViewController {
    let explorer = UIButton()
    var userTypeView = UserTypeView()
    var userType = ""
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            super.viewDidLoad()
            self.title = "User"
            self.userTypeView = UserTypeView()
            self.userTypeView.initializeAllViews()
            self.userTypeView.vendorButton.addTarget(self, action: #selector(self.vendorButtonPressed), for: .touchUpInside)
            self.userTypeView.explorerButton.addTarget(self, action: #selector(self.explorerButtonPressed), for: .touchUpInside)
            self.view.addSubview(self.userTypeView)
        }
    }
    
    func vendorButtonPressed() {
        getVenueLocation()
        
    }
    
    func explorerButtonPressed() {
        sendExplorerInfo()
    }
    
    // Take vendor to WhereViewController.swift 
    // Which is the next step in rendering vendor view
    func getVenueLocation() {
        let venueSelectController = WhereViewController()
        self.present(venueSelectController, animated: true, completion: nil)
    }
    
    // Input: (spotifyUserId, name)
    // Output: Success/Failure
    func sendExplorerInfo() {
        let whoViewController = WhoViewController()
        self.present(whoViewController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
