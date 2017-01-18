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

class MapViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
        view = mapView
        
        // Creates a marker in the center of the map
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        self.title = "Map"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
