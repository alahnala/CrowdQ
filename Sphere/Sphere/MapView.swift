//
//  MapView.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/21/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapView : UIView {
    let returnToUserTypeButton = UIButton()
    var gmapView = GMSMapView()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.returnToUserTypeButton.frame = CGRect(x: 15, y: 20, width: 100, height: 50)
        self.returnToUserTypeButton.setTitle("Back", for: .normal)
        self.returnToUserTypeButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        self.returnToUserTypeButton.setTitleColor(UIColor.black, for: .normal)
        self.returnToUserTypeButton.backgroundColor = UIColor.white
        self.returnToUserTypeButton.layer.cornerRadius = 5
        self.returnToUserTypeButton.layer.borderWidth = 1
        self.returnToUserTypeButton.layer.borderColor = UIColor.black.cgColor
    }
    
    /*
     *  Requires: Current location and names for current title
     *  Modifies: None
     *  Effects: Creates a Google Map View around the user's current location
     */
    func renderGoogleMap(loc: CLLocationCoordinate2D) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: loc.latitude, longitude: loc.longitude, zoom: 16.0)
        self.gmapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.gmapView.isMyLocationEnabled = true
        self.gmapView.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        marker.map = self.gmapView
        
        return self.gmapView
    }
    
    /*
     *  Requires: Venue with venue data
     *  Modifies: None
     *  Effects: Returns a GMSMarker and GMSCircle set to appropriate location
     */
    func createMarker(venue: VenueData) -> (GMSMarker, GMSCircle) {
        let lat = venue.location.latitude
        let long = venue.location.longitude
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
        marker.icon = GMSMarker.markerImage(with: venue.color)
        marker.title = venue.name
        marker.snippet = venue.genres.isEmpty ? "Pop" : venue.genres[0]
        marker.map = self.gmapView
        
        let circle = GMSCircle(position: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: 10)
        circle.fillColor = venue.color
        circle.fillColor?.withAlphaComponent(0.5)
        circle.map = self.gmapView
        
        return (marker, circle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
