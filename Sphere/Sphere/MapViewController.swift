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
    
    let PLACES_KEY = "AIzaSyBLbvnLoXYu1ypBpqrdp0lLu9K_t1R0mZQ"
    let PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let THRESHOLD = 30
    
    let locationManager = CLLocationManager()

    let availablePlaceTypes = ["restaurant", "bar", "night_club", "cafe"]

    var venuesToColors = [String:UIColor]()
    var gmap = GMSMapView()
    
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
        let mapView = renderGoogleMap(loc: loc)
        let textBox = renderTextBox()
        self.view = mapView
        self.view.addSubview(textBox)
        self.view.bringSubview(toFront: mapView)
        self.locationManager.stopUpdatingLocation()
    }
    
    /*
     *  Requires: Current location and names for current title
     *  Modifies: None
     *  Effects: Creates a Google Map View around the user's current location
     */
    func renderGoogleMap(loc: CLLocationCoordinate2D) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: loc.latitude, longitude: loc.longitude, zoom: 15.0)
        self.gmap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.gmap.isMyLocationEnabled = true
        self.gmap.delegate = self
        self.gmap.indoorDisplay.delegate = self
        self.gmap.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        marker.map = self.gmap
        
        displayBuildings()
        return gmap
    }
    
    /*
     *  Requires: Locational coordinates of all buildings within 5 mile radius
     *  Modifies: venuesToColors dictionary
     #  Effects: Creates colored markers to match each incoming location
     */
    func displayBuildings(pagetoken: String = "") {
        
        let venueTypes = availablePlaceTypes.joined(separator: "|")
        let loc = (locationManager.location?.coordinate)!
        let params = "key=\(PLACES_KEY)&location=\(loc.latitude),\(loc.longitude)&rankby=distance&types=\(venueTypes)\(pagetoken)"
        let requestURL = URL(string: (PLACES_URL + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!))
        
        let request = URLRequest(url: requestURL!)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            if error != nil {
                print("ERROR: \(error)")
                return
            }
            let json = JSON(data: data!)
            let results = json["results"]
            
            for result in results {
                self.assignColorToVenue(loc: result.1["geometry"]["location"])
            }
            
            // CREATE MARKERS!
            self.createMarkers()
            
            if let next_page_token = json["next_page_token"].string {
                print(self.venuesToColors.count)
                self.displayBuildings(pagetoken: "&pagetoken=\(next_page_token)")
            } else {
                print(json)
            }
        }
        task.resume()
    }
    
    func makePlacesRequest() -> String {
        return ""
    }
    
    /*
     *  Requires: A venue id as the key
     *  Modifies: The dictionary of venue ids to colors
     *  Effects: See "modifies"
     */
    func assignColorToVenue(loc: JSON) {
        let coords = "\(loc["lat"]),\(loc["lng"])"
        self.venuesToColors[coords] = UIColor.black
    }
    
    /*
     *  Requires: --
     *  Modifies: Google Map
     *  Effects: Creates colored markers of Places
     */
    func createMarkers() {
        var markers = [GMSMarker]()
        for (venue, color) in self.venuesToColors {
            let lat = Double(String(venue.characters.split(separator: ",")[0]))
            let long = Double(String(venue.characters.split(separator: ",")[1]))
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
            marker.icon = GMSMarker.markerImage(with: color)
            marker.map = self.gmap
            markers.append(marker)
        }
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
