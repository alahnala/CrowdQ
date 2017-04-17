//
//  RestManager.swift
//  SFVC Spotify Login
//
//  Created by Rishin Doshi on 3/21/17.
//  Copyright © 2017 Jorden Kreps. All rights reserved.
//

import Foundation

class RestManager {
    
    static let sharedInstance = RestManager()
    
    func checkSession() -> String {
        let auth = SPTAuth.defaultInstance()
        var token = ""
        
        if auth!.session.isValid() {
            token = auth!.session.accessToken
        }
        else if auth!.hasTokenRefreshService {
            SPTAuth.defaultInstance().renewSession(SPTAuth.defaultInstance().session) { error, session in
                token = SPTAuth.defaultInstance().session.accessToken
            }
        }
        
        // TODO: token may not be defined by this return statement if it needs to be refreshed
        return token;
    }

    func registerExplorer(userId: String, name: String) {
        let todoEndpoint: String = "https://sgodbold.com:\(UserData.port)/explorer"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let json = NSMutableDictionary()
        json.setValue(name, forKey: "name")
        json.setValue(userId, forKey: "spotifyUserId")
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        urlRequest.httpBody = data
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        _ = URLSessionConfiguration.default
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            let responseData = String(data: data!, encoding: String.Encoding.utf8)
            
            if error != nil {
                print("Error registering explorer: \(error)")
                return
            }
            
            print("Registered Explorer: \(responseData)")
        })
        task.resume()
    }
    
    func registerVendor(userId: String, name: String, lat: Double, lng: Double, address: String, venue: String) {
        let todoEndpoint: String = "https://sgodbold.com:\(UserData.port)/createVendor"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let json = NSMutableDictionary()
        json.setValue(name, forKey: "name")
        json.setValue(userId, forKey: "spotifyUserId")
        json.setValue(lat, forKey: "lat")
        json.setValue(lng, forKey: "lng")
        json.setValue(address, forKey: "address")
        json.setValue(venue, forKey: "venueName")
        json.setValue(venue, forKey: "placeID")
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        urlRequest.httpBody = data
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        _ = URLSessionConfiguration.default
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            let responseData = String(data: data!, encoding: String.Encoding.utf8)
            
            if error != nil {
                print("Error registering vendor: \(error)")
                return
            }
            
            print("Registered Vendor: \(responseData)")
        })
        task.resume()
        
    }
}
