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

func formatAddress(address: String) -> String {
    var splitAddress = address.components(separatedBy: " ")
    for (index, term) in splitAddress.enumerated() {
        if VenueData.addressAbbreviations[term] != nil {
            splitAddress[index] = VenueData.addressAbbreviations[term]!
        }
    }
    return splitAddress.joined(separator: " ")
}

class VenueData : Hashable {
    
    static let addressAbbreviations = ["St" : "Street", "Ave": "Avenue", "Dr" : "Drive", "Blvd" : "Boulevard", "Rd" : "Road", "Ln" : "Lane", "Mt" : "Mount" , "N" : "North", "S" : "South", "E" : "East", "W" : "West", "Rte" : "Route", "Ct" : "Court"]
    
    let name : String
    let location : CLLocationCoordinate2D
    let address : String
    let id : String
    var color : UIColor
    var hashValue: Int {
        get {
            return "\(id)".hashValue
        }
    }
    
    init(name: String?, loc: CLLocationCoordinate2D?, address: String?, id: String?) {
        self.name = name!
        self.location = loc!
        self.address = formatAddress(address: address!)
        self.id = id!
        self.color = UIColor.white
    }
    
    func printInfo() {
        print(self.id)
        print(self.name)
        print(self.address)
        print(self.color)
    }
}
