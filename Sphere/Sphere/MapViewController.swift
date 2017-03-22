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
            if error != nil {
                print("ERROR: \(error)")
                return
            }
            let json = JSON(data: data!)
            
            for j in json.array! {
                let locAddress = j["address"].string!
                
                if self.nearbyLocsToGenres[locAddress] == nil {
                    self.nearbyLocsToGenres[locAddress] = [String]()
                }
                
                for g in j["musicTaste"].array! {
                    if !(self.nearbyLocsToGenres[locAddress]?.contains(g.string!))! {
                        self.nearbyLocsToGenres[locAddress]!.append(g.string!)
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
        let userTypeController = UserTypeController()
        self.present(userTypeController, animated: true, completion: nil)
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
        self.locationManager.stopUpdatingLocation()
        let loc = manager.location!.coordinate
        UserData.sharedInstance.currentLocation = loc
        
        self.gmapView = MapView()
        self.gmapView.returnToUserTypeButton.addTarget(self, action: #selector(self.returnToUserTypeButtonPressed), for: .touchUpInside)
        self.gmapView.gmapView = self.gmapView.renderGoogleMap(loc: loc)
        self.gmapView.gmapView.delegate = self
        self.gmapView.gmapView.indoorDisplay.delegate = self
        self.view = self.gmapView.gmapView
        self.view.addSubview(self.gmapView.returnToUserTypeButton)
        self.view.bringSubview(toFront: self.gmapView.returnToUserTypeButton)
    
        self.makePlacesRequest()
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
     */
    func assignColorToVenue(venue: VenueData) {
        venue.color = UIColor.white
        let currVenueAddr = venue.address
        for (addr, genres) in self.nearbyLocsToGenres {
            if currVenueAddr == addr {
                print(addr)
                venue.genres = genres
                venue.color = MusicManager.sharedInstance.getColorFromGenre(genre: genres[0])
                break
            }
        }
    }
    
    // when user tap the info window of store marker, show the product list
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let venueViewController = VenueViewController(marker: marker)
        self.present(venueViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
