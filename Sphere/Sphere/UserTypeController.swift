
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
    let userTypeView = UserTypeView()
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User"
        self.userTypeView.initializeAllViews()
        self.userTypeView.vendorButton.addTarget(self, action: #selector(self.vendorButtonPressed), for: .touchUpInside)
        self.userTypeView.explorerButton.addTarget(self, action: #selector(self.explorerButtonPressed), for: .touchUpInside)
        self.view.addSubview(userTypeView)

    }
    
    // Called when vendor button pressed
    func vendorButtonPressed() {
        // Send JSON info to server
        print("vendor pressed")
        getVenueLocation()
        
    }
    
    // Called when explorer button pressed
    func explorerButtonPressed() {
        // Send JSON info to server
        print("explorer pressed")
        sendExplorerInfo()
    }
    
    // Take vendor to WhereViewController.swift 
    // Which is the next step in rendering vendor view
    func getVenueLocation() {
        let venueSelectController = WhereViewController()
        self.present(venueSelectController, animated: true, completion: nil)
        print("Here")
    }
    
    // Input: (spotifyUserId, name)
    // Output: Success/Failure
    func sendExplorerInfo() {
        let jsonPostString = ""

        // create post request to connect
        let serverURL = "https://sgodbold.com:3000/registerExplorer"
        let url = URL(string: serverURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonPostString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        // if response returned from server 
        let mapViewController = MapViewController()
        self.present(mapViewController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
