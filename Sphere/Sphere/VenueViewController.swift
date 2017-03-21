//
//  VenueViewController.swift
//  Sphere
//
//  Created by Allie Lahnala on 3/21/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class VenueViewController : UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, GMSMapViewDelegate, GMSIndoorDisplayDelegate {
    let backButton = UIButton(type: .system)
    var marker : GMSMarker
    
    init(marker: GMSMarker)
    {
        self.marker = marker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Venue"
        self.view.backgroundColor = UIColor.white
        
        
        //add backbutton
        backButton.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 1), for: .normal)
        backButton.setTitleColor(UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.5), for: .selected)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        displayText()
    }
    
    func displayText() {
        let textBox = UITextField(frame: CGRect(x: 250, y: 250, width: 200, height: 40.00))
        self.view.addSubview(textBox)
        textBox.backgroundColor = UIColor.white
        
        textBox.text = marker.title
        
        textBox.borderStyle = UITextBorderStyle.line
    }
    
    func backButtonPressed() {
        print("Back Button pressed!")
        //change for better naming?
        let mapTypeController = MapViewController()
        self.present(mapTypeController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

