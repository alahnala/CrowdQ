//
//  GoogleAPI.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 1/17/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import CoreLocation

class GoogleAPI : NSObject {
    static let sharedInstance = GoogleAPI()
    let API_KEY: String
    
    override init() {
        self.API_KEY = "AIzaSyAXsROURYZImcAisdF58Bud-NWcJbvoJjQ"
    }
    
    func createMap(loc: CLLocation) {
        
    }
}
