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
    
    var venueView : VenueView
    var marker : GMSMarker
    
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
        let mapTypeController = MapViewController()
        self.present(mapTypeController, animated: true, completion: nil)
    }
    

    // Called when venue button pressed
    func checkinButtonPressed() {
        // Send JSON info to server
        print("Check-In Pressed")
        
        self.venueView.checkinButton.isHidden = true
        //checked in
        self.venueView.checked.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        self.venueView.checked.textColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        self.venueView.checked.center = CGPoint(x: 187.5, y: 500)
        self.venueView.checked.textAlignment = .center
        self.venueView.checked.text = "Checked in!"
        
        self.venueView.checked.font = self.venueView.label.font.withSize(40)
        
        self.venueView.showGenre()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

