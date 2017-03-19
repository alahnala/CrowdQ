
//
//  UserClassification.swift
//  Sphere
//
//  Created by Xinrui Yang on 3/16/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

// Decide which kind of user - vendor or explorer - upon sign in

import Foundation
import UIKit

class UserTypeController: UIViewController {

    let vendor = UIButton()
    let explorer = UIButton()
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User"
        
        // Set up the vendor button
        vendor.frame = CGRect(x: 0, y: 200 , width: self.view.bounds.width, height: 100)
        vendor.setTitle("Vendor", for: .normal)
        vendor.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        vendor.addTarget(self, action: #selector(self.vendorButtonPressed), for: .touchUpInside)
        self.view.addSubview(vendor)
        
        // Set up the explorer button
        explorer.frame = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100)
        explorer.setTitle("Explorer", for: .normal)
        explorer.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        explorer.addTarget(self, action: #selector(self.explorerButtonPressed), for: .touchUpInside)
        self.view.addSubview(explorer)
        
    }
    
    func sendUserType(userType: String) {
        let jsonPostString = "userType=" + userType
        
        // create post request to connect
        let serverURL = "https://sgodbold.com:3000/index"
        // let serverURL = "http://0.0.0.0:4443"
        // let serverURL = "http://0.0.0.0:8000"
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
    }
    
    // Called when vendor button pressed
    func vendorButtonPressed() {
        // Send JSON info to server
        userType = "vendor"
        print("vendor pressed")
        sendUserType(userType: userType)
        
        UserData.sharedInstance.userIsExplorer = false
        let whereViewController = WhereViewController()
        self.present(whereViewController, animated: true, completion: nil)
    }

    // Called when explorer button pressed
    func explorerButtonPressed() {
        // Send JSON info to server
        userType = "explorer"
        print("explorer pressed")
        sendUserType(userType: userType)
        
        UserData.sharedInstance.userIsExplorer = true
        let mapViewController = MapViewController()
        self.present(mapViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
