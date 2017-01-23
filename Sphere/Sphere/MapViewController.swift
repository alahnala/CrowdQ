//
//  MapViewController.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 1/17/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class MapViewController : UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, GMSMapViewDelegate, GMSIndoorDisplayDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        self.setupLocation()
    }
    
    func setupLocation() {
        // Pop-up asking user to authorize location services
        self.locationManager.requestAlwaysAuthorization()
        
        // Give us permission to use location in-app
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // Set up map to show current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = manager.location!.coordinate
        let mapView = renderGoogleMap(loc: loc, title: "NEEDS TITLE", snippet: "NEED SNIPPET")
        let textBox = renderTextBox()
        self.view = mapView
        self.view.addSubview(textBox)
        self.view.bringSubview(toFront: mapView)
        self.locationManager.stopUpdatingLocation()
    }
    
    func renderGoogleMap(loc: CLLocationCoordinate2D, title: String?, snippet: String?) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: loc.latitude, longitude: loc.longitude, zoom: 12.0)
        let gmap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        gmap.isMyLocationEnabled = true
        gmap.delegate = self
        gmap.indoorDisplay.delegate = self
        gmap.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        marker.title = title!
        marker.snippet = snippet!
        marker.map = gmap
        return gmap
    }
    
    func renderTextBox() -> UITextField {
        let textBox = UITextField(frame: CGRect(x: 10, y: 20, width: 180, height: 40))
        textBox.attributedPlaceholder = NSAttributedString(string: "Enter a location")
        textBox.backgroundColor = UIColor.white
        textBox.delegate = self
        return textBox
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
