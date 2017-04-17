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
     *  Requires: A similarity score in the form of an Int
     *  Modifies: --
     *  Effects: Returns the genre's corresponding color as a UIColor
     */
    func getColorFromGenre(score: Int) -> UIColor {
        if score == 0 {
            return UIColor.red
        }
        
        if score > 0 && score < 3 {
            return UIColor.yellow
        }

        return UIColor.green
    }
}
