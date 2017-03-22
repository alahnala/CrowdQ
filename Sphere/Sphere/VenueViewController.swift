//
//  VenueViewController.swift
//  Sphere
//
//  Created by Allie Lahnala on 3/21/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class VenueViewController : UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, GMSMapViewDelegate, GMSIndoorDisplayDelegate {
    
    var marker : GMSMarker
    var venueView : VenueView
    
    /*
     *  Create VenueView Page and addTarget to its subViews
     */
    init(marker: GMSMarker) {
        self.marker = marker
        self.venueView = VenueView(marker: self.marker)
        super.init(nibName: nil, bundle: nil)
        self.title = "Venue"
        self.view.addSubview(self.venueView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("zzz: made it here")
        super.viewDidLoad()
        print("zzz: view did load")
        self.venueView.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.venueView.checkinButton.addTarget(self, action: #selector(self.checkinButtonPressed), for: .touchUpInside)
    }
    
    func backButtonPressed() {
        print("Back Button pressed!")
        //change for better naming?
        let mapTypeController = MapViewController()
        self.present(mapTypeController, animated: true, completion: nil)
    }
    
    // Called when venue button pressed
    func checkinButtonPressed() {
        // Send JSON info to server
        print("Check-In Pressed")
        
        self.venueView.checkinButton.isHidden = true
        //checked in
        
        // validate mood button
        self.venueView.confirmMood.setTitle("Accurate!", for: .normal)
        self.venueView.confirmMood.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1)
        self.venueView.confirmMood.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        self.venueView.confirmMood.bounds = CGRect(x: 0, y: 0, width: 300, height: 100)
        self.venueView.confirmMood.center = CGPoint(x: 187.5, y: 400)
        self.venueView.confirmMood.layer.cornerRadius = 10
        self.venueView.confirmMood.addTarget(self, action: #selector(self.confirmMoodPressed), for: .touchUpInside)
        
        
        //suggest mood button
        self.venueView.suggestMood.setTitle("Suggest another mood!", for: .normal)
        self.venueView.suggestMood.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1)
        self.venueView.suggestMood.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        self.venueView.suggestMood.bounds = CGRect(x: 0, y: 0, width: 300, height: 100)
        self.venueView.suggestMood.center = CGPoint(x: 187.5, y: 550)
        self.venueView.suggestMood.layer.cornerRadius = 10
        self.venueView.suggestMood.addTarget(self, action: #selector(self.suggestMoodPressed), for: .touchUpInside)
        
        self.venueView.showGenre()
    }
    
    func confirmMoodPressed() {
        self.venueView.confirmMood.isHidden = true
        self.venueView.suggestMood.isHidden = true
        
        // Render Checked-in Label
        self.venueView.checked.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        self.venueView.checked.textColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        self.venueView.checked.center = CGPoint(x: 187.5, y: 500)
        self.venueView.checked.textAlignment = .center
        self.venueView.checked.text = "Checked in!"
        
        self.venueView.checked.font = self.venueView.label.font.withSize(40)
    }
    
    func suggestMoodPressed() {
        //Hide all unnecessary text & buttons
        self.venueView.confirmMood.isHidden = true
        self.venueView.suggestMood.isHidden = true
        self.venueView.genreLabel.isHidden = true
        self.venueView.theMoodsAreLabel.isHidden = true
        
        //Renders text box
        
        self.venueView.checked.font = self.venueView.label.font.withSize(40)
        
        self.venueView.showGenre()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
