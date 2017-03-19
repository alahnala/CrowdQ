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
    let PLACES_KEYS = ["AIzaSyDgyXwygcFNpPY2Wi8d1jSFZDyNuIZlPCM", "AIzaSyAjwAgSMtWGWKRIxC-qC--x0TlkAlSCVfw"]
    var key_index = 0
    
    func getCurrentKey() -> String {
        return PLACES_KEYS[key_index]
    }
    
    func incrementKey() {
        key_index = (key_index + 1) % PLACES_KEYS.count
    }
}
