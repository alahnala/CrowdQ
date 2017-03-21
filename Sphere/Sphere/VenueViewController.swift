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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.venueView.initializeAllViews()
        self.venueView.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.view.addSubview(venueView)
    }
    
    /*
     *  Switch back to MapViewController
     */
    func backButtonPressed() {
        print("Back Button pressed!")
        let mapTypeController = MapViewController()
        self.present(mapTypeController, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

