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

func ==(lhs: VenueData, rhs: VenueData) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class VenueData : Hashable {
    let name : String
    let id : String
    let location : CLLocationCoordinate2D?
    let score : Int
    var color : UIColor
    var hashValue: Int {
        get {
            return "\(id)".hashValue
        }
    }
    
    init(name: String?, id: String?, location: CLLocationCoordinate2D?, score: Int = 0) {
        self.name = name!
        self.id = id!
        self.location = location
        self.score = score
        self.color = UIColor.red
    }
    
    func printInfo() {
        print(self.name)
        print(self.id)
        print(self.location!)
        print(self.color)
    }
}
