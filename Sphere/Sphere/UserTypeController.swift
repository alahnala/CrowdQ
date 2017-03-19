
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
    
    let vendor = UIButton()
    let explorer = UIButton()
    let label = UILabel()
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User"
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 75)
        label.textColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        label.center = CGPoint(x: 187.5, y: 100)
        label.textAlignment = .center
        label.text = "I am a ..."
        label.font = label.font.withSize(45)
        self.view.addSubview(label)
        
        // Set up the vendor button
        vendor.setTitle("Vendor", for: .normal)
        vendor.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        vendor.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        vendor.bounds = CGRect(x: 0, y: 0, width: 300, height: 100)
        vendor.center = CGPoint(x: 187.5, y: 250)
        vendor.layer.cornerRadius = 10
        vendor.addTarget(self, action: #selector(self.vendorButtonPressed), for: .touchUpInside)
        self.view.addSubview(vendor)
        
        // Set up the explorer button
        explorer.setTitle("Explorer", for: .normal)
        explorer.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        explorer.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        explorer.bounds = CGRect(x: 0, y: 0, width: 300, height: 100)
        explorer.center = CGPoint(x: 187.5, y: 400)
        explorer.layer.cornerRadius = 10
        explorer.addTarget(self, action: #selector(self.explorerButtonPressed), for: .touchUpInside)
        self.view.addSubview(explorer)

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
    
    /* --------- This might have to go in WhereViewController.swift ---------
     
     // Input: (spotifyUserId, name, venueName, lat, lng)
     // Output: Success/Failure
     func sendVendorInfo() {
     let jsonPostString = ""
     let getVenue = WhereViewController() // Get this from WhereViewController.swift
     
     // create post request to connect
     let serverURL = "https://sgodbold.com:3000/registerVendor"
     let url = URL(string: serverURL)!
     var request = URLRequest(url: url)
     request.httpMethod = "POST"
     request.httpBody = jsonPostString.data(using: .utf8)
     
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
     guard let data = data, error == nil else {
     print("error=\(error)")
     return
     }
     
     if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {                 print("statusCode should be 200, but is \(httpStatus.statusCode)")
     print("response = \(response)")
     }
     
     let responseString = String(data: data, encoding: .utf8)
     print("responseString = \(responseString)")
     }
     task.resume()
     }
     
    */
    
}
