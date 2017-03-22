//
//  VenueView.swift
//  Sphere
//
//  Created by Chuckry Vengadam on 3/21/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class VenueView : UIView {
    var marker = GMSMarker()
    let backButton = UIButton(type: .system)
    let checkinButton = UIButton()
    let label = UILabel()
    let checked = UILabel()
    let confirmMood = UIButton()
    let suggestMood = UIButton()
    let theMoodsAreLabel = UILabel()
    let genreLabel = UILabel()
    
    // TODO: Allow user to submit genres
    init(marker: GMSMarker) {
        self.marker = marker
        super.init(frame: UIScreen.main.bounds)
        
        // back button
        backButton.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1), for: .normal)
        backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.5), for: .selected)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        
        // check in button
        checkinButton.setTitle("Check In", for: .normal)
        checkinButton.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1)
        checkinButton.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        checkinButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 100)
        checkinButton.center = CGPoint(x: 187.5, y: 250)
        checkinButton.layer.cornerRadius = 10
        
        displayVenueName()
        initializeAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayVenueName() {
        print("Displaying Venue Name")
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        //label.backgroundColor = UIColor.white
        label.center = CGPoint(x: 187.5, y: 100)
        label.textAlignment = .center
        label.text = marker.title
        label.textColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1.0)
        label.font = label.font.withSize(32)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        print("\(label.text)")
    }
    
    //call backend to get genre
    // TODO: Call backend rather than use default array
    func showGenre() {
        let genres = ["Pop", "Rock", "Family Friendly"]
        
        // "The Moods for <Venue> are ... "
        theMoodsAreLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        theMoodsAreLabel.textColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1)
        theMoodsAreLabel.center = CGPoint(x: 187.5, y: 200)
        theMoodsAreLabel.textAlignment = .center
        theMoodsAreLabel.text = "The moods for \(marker.title!) are listed as"
        theMoodsAreLabel.font = label.font.withSize(20)
        theMoodsAreLabel.lineBreakMode = .byWordWrapping
        theMoodsAreLabel.numberOfLines = 0
        
        genreLabel.text = genres.joined(separator: ", ")
        
        genreLabel.frame = CGRect(x: 0, y: 200, width: 300, height: 100)
        genreLabel.center = CGPoint(x: 187.5, y: 275)
        genreLabel.font = label.font.withSize(32)
        genreLabel.textAlignment = .center
        genreLabel.textColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1)
        genreLabel.lineBreakMode = .byWordWrapping
        genreLabel.numberOfLines = 0
    }
    
    
    /*
     *  Add initialized views as subviews
     */
    func initializeAllViews() {
        self.addSubview(backButton)
        self.addSubview(checkinButton)
        self.addSubview(label)
        self.addSubview(checked)
        self.addSubview(theMoodsAreLabel)
        self.addSubview(genreLabel)
        
        self.addSubview(confirmMood)
        self.addSubview(suggestMood)
        //self.bringSubview(toFront: label)
        print("zzz: initialize called")
    }
    
}
