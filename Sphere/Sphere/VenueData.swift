//
//  Venue.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/19/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class VenueData {
    let name : String
    let location : CLLocationCoordinate2D
    let address : String
    let id : String
    var color : UIColor
    
    init(name: String, loc: CLLocationCoordinate2D, address: String, id: String) {
        self.name = name
        self.location = loc
        self.address = address
        self.id = id
        self.color = UIColor.black
    }
}
