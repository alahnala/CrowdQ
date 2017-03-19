//
//  UserData.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/19/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class UserData {
    static let sharedInstance = UserData()
    var userIsExplorer : Bool = true
    var userVenueLocation : String = ""
    var currentLocation = CLLocationCoordinate2D()
}
