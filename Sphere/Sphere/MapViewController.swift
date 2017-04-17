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
    
    let availablePlaceTypes = ["restaurant", "bar", "night_club", "cafe"]
    var locationManager = CLLocationManager()
    var PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    var gmapView = MapView()

    var databaseVenuesToGenres = [VenueData:[String]]()
    var venues = [VenueData]()
    var markers = [(GMSMarker, GMSCircle)]()
    var filteredGenres = Set<String>()
    var markersOnMap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        MusicManager.sharedInstance.gatherGenresToColors()
        self.getVenueData()
    }
    
    /*
     *  Requires: --
     *  Modifies: databaseVenuesToGenres Dictionary
     *  Effects: --
     */
    func getVenueData() {
        let todoEndpoint: String = "https://sgodbold.com:\(UserData.port)/venues?spotifyUserId=\(UserData.sharedInstance.userId)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // POST stuff: save for later
        //    let json: [String: Any] = ["userId": "rdoshi023"]
        //    let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //    urlRequest.httpBody = jsonData
        
        // set up the session
        _ = URLSessionConfiguration.default
        let session = URLSession.shared
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                print("ERROR: \(error)")
                return
            }
            let json = JSON(data: data!)
            for j in json.array! {
                let score = j["expSim"].int
                let venue = j["venue"]
                let placeID = venue["venueId"] == JSON.null ? "" : venue["venueId"].string
                let registeredVenue = VenueData(name: venue["name"].string, id: placeID, location: nil, score: score!)
                
                if self.databaseVenuesToGenres[registeredVenue] == nil {
                    self.databaseVenuesToGenres[registeredVenue] = [String]()
                }
                
                for g in venue["musicTaste"].array! {
                    if !(self.databaseVenuesToGenres[registeredVenue]?.contains(g.string!))! {
                        self.databaseVenuesToGenres[registeredVenue]!.append(g.string!)
                    }
                }
            }
            
            self.setupLocation()
            if !self.databaseVenuesToGenres.isEmpty {
                return
            }
        })
        task.resume()
    }
    
    /*
     *  Requires: --
     *  Modifies: Location Manager
     *  Effects: Updates location using iOS hardware
     */
    func setupLocation() {
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            
            // Pop-up asking user to authorize location services
            self.locationManager.requestAlwaysAuthorization()
        
            // Give us permission to use location in-app
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    // When device finds GPS coordinates, render the Map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = manager.location!.coordinate
        UserData.sharedInstance.currentLocation = loc
        
        self.gmapView = MapView()
        self.gmapView.returnToUserTypeButton.addTarget(self, action: #selector(self.returnToUserTypeButtonPressed), for: .touchUpInside)
        self.gmapView.filterButton.addTarget(self, action: #selector(self.filterButtonPressed), for: .touchUpInside)
        
        self.gmapView.gmapView = self.gmapView.renderGoogleMap(loc: loc)
        self.gmapView.gmapView.delegate = self
        self.gmapView.gmapView.indoorDisplay.delegate = self
        self.view = self.gmapView.gmapView
        self.view.addSubview(self.gmapView.returnToUserTypeButton)
        self.view.addSubview(self.gmapView.filterButton)
        self.view.bringSubview(toFront: self.gmapView.returnToUserTypeButton)
        self.view.bringSubview(toFront: self.gmapView.filterButton)
        self.makePlacesRequest()
        self.locationManager.stopUpdatingLocation()
    }
    
    /*
     *  Requires: Locational coordinates of all buildings within 5 mile radius
     *  Modifies: venuesToColors dictionary
     #  Effects: Creates colored markers to match each incoming location
     */
    func makePlacesRequest(pt: String = "") {
        let venueTypes = self.availablePlaceTypes.joined(separator: "|")
        let loc = (self.locationManager.location?.coordinate)!
        let placesKey = GoogleAPI.sharedInstance.getCurrentKey()
        
        let params = "key=\(placesKey)&location=\(loc.latitude),\(loc.longitude)&rankby=distance&types=\(venueTypes)\(pt)"
        let requestURL = URL(string: (PLACES_URL + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!))
        let request = URLRequest(url: requestURL!)

        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error != nil {
                print("ERROR: \(error)")
                return
            }

            _ = self.storePlacesResults(json: JSON(data: data!))
        }
        task.resume()
    }
    
    
    /*
     *  Requires: JSON data from Google Places Request
     *  Modifies: Constructs Dictionary of venue locations to colors
     *  Effects: Returns next page token for re-querying
     */
    func storePlacesResults(json: JSON) -> String? {
        if json["status"].string == "OVER_QUERY_LIMIT" {
            GoogleAPI.sharedInstance.incrementKey()
            self.makePlacesRequest()
            return ""
        }
        
        let results = json["results"]
        for result in results {
            let loc = CLLocationCoordinate2D(latitude: CLLocationDegrees(result.1["geometry"]["location"]["lat"].double!), longitude: CLLocationDegrees(result.1["geometry"]["location"]["lng"].double!))
            let placeID = result.1["placeID"] == JSON.null ? "" : result.1["placeID"].string
            let name = result.1["name"].string
            let venue = VenueData(name: name!, id: placeID!, location: loc)
            self.venues.append(venue)
            self.createVenueMarkers(venue: venue)
        }
        let next_page_json : String? = json["next_page_token"].string
        return next_page_json
    }
    
    /*
     *  Requires: --
     *  Modifies: Map Marker
     *  Effects: Creates colored markers of Places
     */
    func createVenueMarkers(venue: VenueData) {
        let v = self.assignColorToVenue(venue: venue)
        self.markers.append(self.gmapView.createMarker(venue: v, genres: self.databaseVenuesToGenres[v]))
    }
    
    /*
     *  Requires: A VenueData as a key
     *  Modifies: The dictionary of venue ids to colors
     *  Effects: --
     */
    func assignColorToVenue(venue: VenueData) -> VenueData {
        if self.databaseVenuesToGenres[venue] != nil {
            venue.color = MusicManager.sharedInstance.getColorFromGenre(score: venue.score)
        }
        return venue
    }
    
    /*
     *  Requires: --
     *  Modifies: Current view controller
     *  Effects: Moves user back to initial page
     */
    func returnToUserTypeButtonPressed() {
        let userTypeController = UserTypeController()
        self.present(userTypeController, animated: true, completion: nil)
    }
    
    func filterButtonPressed() {
        let alert = UIAlertController(title: "Filter by Genre!", message: "Please enter the appropriate genres that you would like to keep or filter out of the map.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Genre(s) to Keep"
        })
        alert.addTextField(configurationHandler: {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Genre(s) to Filter"
        })
        alert.addAction(UIAlertAction(title: "Filter", style: UIAlertActionStyle.default) {
            UIAlertAction in

            let keepTextField = alert.textFields![0] as UITextField
            let removeTextField = alert.textFields![1] as UITextField
            
            if (keepTextField.text?.isEmpty)! && (removeTextField.text?.isEmpty)! {
                return
            }
            
            let inputKeepGenres = keepTextField.text != nil ? Set<String>(keepTextField.text!.lowercased().components(separatedBy: ", ")) : Set<String>()
            let inputRemoveGenres = removeTextField.text != nil ? Set<String>(removeTextField.text!.lowercased().components(separatedBy: ", ")) : Set<String>()
            
            for m in self.markers {
                let markerGenres = Set<String>(m.0.snippet!.lowercased().components(separatedBy: ", "))
                let keepIntersection = markerGenres.intersection(inputKeepGenres)
                let removeIntersection = markerGenres.intersection(inputRemoveGenres)
                
                if keepIntersection.count >= removeIntersection.count {
                    m.0.map = self.gmapView.gmapView
                    m.1.map = self.gmapView.gmapView
                }
                
                if keepIntersection.count < removeIntersection.count {
                    m.0.map = nil
                    m.1.map = nil
                }
            }
            
        })
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default) {
            UIAlertAction in
            for m in self.markers {
                m.0.map = self.gmapView.gmapView
                m.1.map = self.gmapView.gmapView
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // when user tap the info window of store marker, show the product list
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let venueViewController = VenueViewController(marker: marker, loc: (self.locationManager.location?.coordinate)!)
        self.present(venueViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
