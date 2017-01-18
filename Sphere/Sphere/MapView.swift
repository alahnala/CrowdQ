//
//  MapView.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 1/18/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class MapView {
    let gmap : GMSMapView
    let camera : GMSCameraPosition
    let marker : GMSMarker
    let loc : CLLocationCoordinate2D
    let zoom : Float
    
    
    init(location: CLLocationCoordinate2D, zoom: Float?) {
        let z = (zoom == nil) ? 6.0 : zoom!
        self.loc = location
        self.zoom = z
        self.marker = GMSMarker()
        self.camera = GMSCameraPosition.camera(withLatitude: self.loc.latitude, longitude: self.loc.longitude, zoom: z)
        self.gmap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.dropMarker(title: "NEED TITLE", snippet: "need snippet")
    }
    
    func dropMarker(title: String?, snippet: String?) {
        // Creates a marker in the center of the map
        self.marker.position = CLLocationCoordinate2D(latitude: self.loc.latitude, longitude: self.loc.longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = self.gmap
        print("Locations: \(self.loc.latitude), \(self.loc.longitude)")
    }
    
    func getMapView() -> GMSMapView {
        return self.gmap
    }
}
