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
<<<<<<< HEAD
        if (self.whereView.nameTextField.text?.isEmpty)! || (self.searchController?.searchBar.text?.isEmpty)! {
            print("All fields must be filled out!")
=======
        if (self.nameTextField.text?.isEmpty)! || (self.searchController?.searchBar.text?.isEmpty)! {
            let missingFieldsAlert = UIAlertController(title: "Missing field(s)", message: "All fields must be filled out!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            missingFieldsAlert.addAction(okAction)
            self.present(missingFieldsAlert, animated: true)
            // print("All fields must be filled out!")
>>>>>>> master
            return
        }
        information["name"] = self.whereView.nameTextField.text!
        print(information)
        
        let mapViewController = MapViewController()
        self.present(mapViewController, animated: true, completion: nil)
    }
    
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



