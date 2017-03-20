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
    
    let PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let THRESHOLD = 30
    
    let locationManager = CLLocationManager()
    let availablePlaceTypes = ["restaurant", "bar", "night_club", "cafe"]
    let changeButton = UIButton(frame: CGRect(x: 15, y: 20, width: 100, height: 50))

    var databaseVenues : JSON = []
    var locToGenres = [String:[String]]()
    var venues = [VenueData]()
    var markers = [(GMSMarker, GMSCircle)]()
    var gmap = GMSMapView()
    var markersOnMap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        MusicManager.sharedInstance.gatherGenresToColors()
        self.getVenueData()
    }
    
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
                
                if self.locToGenres[loc] == nil {
                    self.locToGenres[loc] = [String]()
                }
                
                for g in j["genres"].array! {
                    if !(self.locToGenres[loc]?.contains(g.string!))! {
                        self.locToGenres[loc]!.append(g.string!)
                    }
                }
            }
            self.setupLocation()
            if !self.locToGenres.isEmpty {
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
    func changeButtonPressed() {
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
        
        let mapView = renderGoogleMap(loc: loc)
        self.makePlacesRequest()
        
        self.view = mapView
        self.view.bringSubview(toFront: mapView)
        
        changeButton.setTitle("Back", for: .normal)
        changeButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        changeButton.setTitleColor(UIColor.black, for: .normal)
        changeButton.backgroundColor = UIColor.white
        changeButton.layer.cornerRadius = 5
        changeButton.layer.borderWidth = 1
        changeButton.layer.borderColor = UIColor.black.cgColor
        changeButton.addTarget(self, action: #selector(self.changeButtonPressed), for: .touchUpInside)
        self.view.addSubview(changeButton)
        self.view.bringSubview(toFront: changeButton)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    /*
     *  Requires: Current location and names for current title
     *  Modifies: None
     *  Effects: Creates a Google Map View around the user's current location
     */
    func renderGoogleMap(loc: CLLocationCoordinate2D) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: loc.latitude, longitude: loc.longitude, zoom: 16.0)
        self.gmap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.gmap.isMyLocationEnabled = true
        self.gmap.delegate = self
        self.gmap.indoorDisplay.delegate = self
        self.gmap.settings.myLocationButton = true
    
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        marker.map = self.gmap
        return gmap
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
        self.createMarkers()
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
        for (dataLoc, genres) in self.locToGenres {
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
    
    /*
     *  Requires: --
     *  Modifies: Array of Map Markers
     *  Effects: Creates colored markers of Places
     */
    func createMarkers() {
        for venue in self.venues {
            let lat = venue.location.latitude
            let long = venue.location.longitude
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
            marker.icon = GMSMarker.markerImage(with: venue.color)
            marker.title = venue.name
            marker.snippet = venue.genres.isEmpty ? venue.address : venue.genres[0]
            marker.map = self.gmap
            
            let circle = GMSCircle(position: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: 10)
            circle.fillColor = venue.color
            circle.fillColor?.withAlphaComponent(0.5)
            circle.map = self.gmap
            
            self.markers.append((marker, circle))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
