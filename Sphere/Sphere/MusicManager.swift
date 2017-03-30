//
//  MusicManager.swift
//  
//
//  Created by Chuckry Vengadam on 3/19/17.
//
//

import Foundation
import UIKit

class MusicManager {
    static let sharedInstance = MusicManager()
    var genresToColors = [String:String]()
    
    // Pull JSON data from file
    func gatherGenresToColors() {
        if let path = Bundle.main.path(forResource: "genres_to_colors", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: path)
                if let data = contents.data(using: String.Encoding.utf8) {
                    self.genresToColors = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
                }
            } catch {
                print("Error getting genre to color mapping!")
            }
        } else {
            print("Unable to find genre to color file!")
        }
    }
    
    /*
     *  Requires: A musical genre in the form of a string
     *  Modifies: --
     *  Effects: Returns the genre's corresponding color as a UIColor
     */
    func getColorFromGenre(genre: String) -> UIColor {
        let hexVal = self.genresToColors[genre.lowercased()]
        if hexVal == nil {
            return UIColor.white
        }
        
        var rgbValue : UInt32 = 0
        Scanner(string: hexVal!).scanHexInt32(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
