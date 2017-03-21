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
    let availablePlaceTypes = ["restaurant", "bar", "night_club", "cafe"]
    let PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let gmapView = MapView()

    var databaseVenues : JSON = []
    var nearbyLocsToGenres = [String:[String]]()
    var venues = [VenueData]()
    var markers = [(GMSMarker, GMSCircle)]()
    var markersOnMap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        MusicManager.sharedInstance.gatherGenresToColors()
        self.getVenueData()
    }
    
    /*
     *  Requires: --
     *  Modifies: nearbyLocsToGenres Dictionary
     *  Effects: --
     */
    func getVenueData() {
        let todoEndpoint: String = "https://sgodbold.com:3000/venues?lat=42.29117&lng=-83.71572&radius=10000"
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
            let json = JSON(data: data!)
            for j in json.array! {
                let loc = "\(j["lat"]),\(j["lng"])"
                
                if self.nearbyLocsToGenres[loc] == nil {
                    self.nearbyLocsToGenres[loc] = [String]()
                }
                
                for g in j["musicTaste"].array! {
                    if !(self.nearbyLocsToGenres[loc]?.contains(g.string!))! {
                        self.nearbyLocsToGenres[loc]!.append(g.string!)
                    }
                }
            }
            self.setupLocation()
            if !self.nearbyLocsToGenres.isEmpty {
                return
            }
        })
        task.resume()
    }
    
    /*
     *  Requires: --
     *  Modifies: Current view controller
     *  Effects: Moves user back to initial page
     */
    func returnToUserTypeButtonPressed() {
        print("Change button pressed!")
        let userTypeController = UserTypeController()
        self.present(userTypeController, animated: true, completion: nil)
    }
    
    /*
     *  Requires: --
     *  Modifies: Location Manager
     *  Effects: Updates location using iOS hardware
     */
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
    
    // When device finds GPS coordinates, render the Map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = manager.location!.coordinate
        UserData.sharedInstance.currentLocation = loc
        
        print("Got location!")
        self.gmapView.gmapView.delegate = self
        self.gmapView.gmapView.indoorDisplay.delegate = self
        self.gmapView.returnToUserTypeButton.addTarget(self, action: #selector(self.returnToUserTypeButtonPressed), for: .touchUpInside)
        self.view = self.gmapView.renderGoogleMap(loc: loc)
        self.makePlacesRequest()
        
        self.locationManager.stopUpdatingLocation()
    }
    
    /*
     *  Requires: --
     *  Modifies: Array of Map Markers
     *  Effects: Creates colored markers of Places
     */
    func createVenueMarkers() {
        for venue in self.venues {
            self.markers.append(self.gmapView.createMarker(venue: venue))
        }
    }
    
    /*
     *  Requires: Locational coordinates of all buildings within 5 mile radius
     *  Modifies: venuesToColors dictionary
     #  Effects: Creates colored markers to match each incoming location
     */
    func makePlacesRequest() {
        let venueTypes = self.availablePlaceTypes.joined(separator: "|")
        let loc = (self.locationManager.location?.coordinate)!
        let places_key = GoogleAPI.sharedInstance.getCurrentKey()
        
        let params = "key=\(places_key)&location=\(loc.latitude),\(loc.longitude)&rankby=distance&types=\(venueTypes)"
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
            let loc = CLLocationCoordinate2D(latitude: CLLocationDegrees(result.1["geometry"]["location"]["lat"].float!), longitude: CLLocationDegrees(result.1["geometry"]["location"]["lng"].float!))
            let address = result.1["vicinity"].string
            let place_id = result.1["id"].string
            let name = result.1["name"].string
            let venue = VenueData(name: name!, loc: loc, address: address!, id: place_id!)
            self.venues.append(venue)
            
            self.assignColorToVenue(venue: venue)
        }
        self.createVenueMarkers()
        let next_page_json : String? = json["next_page_token"].string
        return next_page_json
    }
    
    /*
     *  Requires: A venue id as the key
     *  Modifies: The dictionary of venue ids to colors
     *  Effects: --
     *
     *  TO COMPLETE UPON DATABASE IMPLEMENTATION
     */
    func assignColorToVenue(venue: VenueData) {
        venue.color = UIColor.blue
        let loc = "\(venue.location.latitude),\(venue.location.longitude)"
        for (dataLoc, genres) in self.nearbyLocsToGenres {
            let nearbyLat = Double(loc.components(separatedBy: ",")[0])!
            let nearbyLong = Double(loc.components(separatedBy: ",")[1])!
            let dataLat = Double(dataLoc.components(separatedBy: ",")[0])!
            let dataLong = Double(dataLoc.components(separatedBy: ",")[1])!
            
            if abs(nearbyLat - dataLat) < 0.0001 && abs(nearbyLong - dataLong) < 0.0001 {
                venue.genres = genres
                venue.color = MusicManager.sharedInstance.getColorFromGenre(genre: genres[0])
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
