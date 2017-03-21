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
    
    let backButton = UIButton(type: .system)
    let submitButton = UIButton(type: .system)
    let nameTextField = UITextField()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var information: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Where"
        self.view.backgroundColor = UIColor.black
        
        // Set up tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WhereViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        backButton.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1), for: .normal)
        backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.5), for: .selected)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        submitButton.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        submitButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1), for: .normal)
        submitButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.5), for: .selected)
        submitButton.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 100)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(self.postVendorInformation), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        nameTextField.placeholder = "Enter your name"
        nameTextField.frame = CGRect(x: 0, y: 150, width: 300, height: 60)
        nameTextField.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 3)
        nameTextField.textAlignment = NSTextAlignment.center
        nameTextField.backgroundColor = .white
        nameTextField.layer.cornerRadius = 5
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.delegate = self
        self.view.addSubview(nameTextField)
        
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
        print("Back Button pressed!")
        let userTypeController = UserTypeController()
        self.present(userTypeController, animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func postVendorInformation() {
        if (self.nameTextField.text?.isEmpty)! || (self.searchController?.searchBar.text?.isEmpty)! {
            let missingFieldsAlert = UIAlertController(title: "Missing field(s)", message: "All fields must be filled out!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            missingFieldsAlert.addAction(okAction)
            self.present(missingFieldsAlert, animated: true)
            // print("All fields must be filled out!")
            return
        } else {
            print("Got information properly!")
            information["name"] = nameTextField.text!
            print(information)
        }
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

    
    func getVendorGenre() {
        
    }
    
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
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        searchController?.searchBar.text = place.name
        
        information["venueName"] = place.name
        information["lat"] = String(place.coordinate.latitude)
        information["lng"] = String(place.coordinate.longitude)
//        information["address"] = place.formattedAddress!
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



