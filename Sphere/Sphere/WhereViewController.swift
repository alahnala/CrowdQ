//
//  File.swift
//  Sphere
//
//  Created by Allie Lahnala on 3/16/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import UIKit
import Foundation
import GooglePlaces

class WhereViewController : UIViewController, UITextFieldDelegate {
    
    let whereView = WhereView()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var information: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Where"
        self.whereView.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.whereView.submitButton.addTarget(self, action: #selector(self.postVendorInformation), for: .touchUpInside)
        self.whereView.initializeAllViews()
        self.view = self.whereView
        
        // Set up tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WhereViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 100))
        subView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4)
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        
        definesPresentationContext = true
    }
    
    func backButtonPressed() {
        let userTypeController = UserTypeController()
        self.present(userTypeController, animated: true, completion: nil)
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func postVendorInformation() {
        if (self.whereView.nameTextField.text?.isEmpty)! || (self.searchController?.searchBar.text?.isEmpty)! {
            print("Error: All fields must be filled out!")
            return
        }
        information["name"] = self.whereView.nameTextField.text!
        
        RestManager.sharedInstance.registerVendor(userId: UserData.sharedInstance.userId, name: information["name"]!, lat: Double(information["lat"]!)!, lng: Double(information["lng"]!)!, address: information["address"]!, venue: information["venueName"]!)
        
        let mapViewController = MapViewController()
        self.present(mapViewController, animated: true, completion: nil)
    }
    
    /* --------- Making POST request to the server ---------
     
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
     
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
     
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
            task.resume()
     }
     
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Handle the user's selection.
extension WhereViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        searchController?.searchBar.text = place.name
        
        information["venueName"] = place.name
        information["lat"] = String(place.coordinate.latitude)
        information["lng"] = String(place.coordinate.longitude)
        information["address"] = place.formattedAddress!
        information["placeID"] = place.placeID
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}



