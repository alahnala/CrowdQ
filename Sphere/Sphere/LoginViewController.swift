//
//  LoginViewController.swift
//  SFVC Spotify Login
//
//  Created by Jorden Kreps on 11/15/15.
//  Copyright © 2015 Jorden Kreps. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    let ClientID = "a21eb5ea7b434b80acd97c263cdd6726"
    let RedirectURL = URL(string: "sphere-login://callback")
    let NotificationName = "SafariViewControllerDidCompleteLogin"
    // let loginButton = UIButton()
    
    var spotifyLoginButton : UIButton?
    var descriptionLabel: UILabel?
    var safariVC: SFSafariViewController?
    var spotifySession: SPTSession?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.loginWasHandled(_:)), name: NSNotification.Name(rawValue: self.NotificationName), object: nil)
        
        let centerX = (self.view.frame.size.width / 2)
        let centerY = (self.view.frame.size.height / 2)
        
        self.spotifyLoginButton = UIButton.init(frame: CGRect(x: centerX - 125, y: centerY - 22.5, width: 250, height: 45))
        self.spotifyLoginButton?.layer.cornerRadius = 15
        self.spotifyLoginButton?.backgroundColor = UIColor(red: 169/255, green: 66/255, blue:103/255, alpha: 0.75)
        self.spotifyLoginButton?.setTitle("Log in with Spotify", for: .normal)
//        self.spotifyLoginButton!.setImage(UIImage(named: "SpotifyLogin"), for: UIControlState())
        
        self.spotifyLoginButton!.addTarget(self, action: #selector(LoginViewController.loginButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(self.spotifyLoginButton!)
    }
    
    func loginButtonPressed() {
        SPTAuth.defaultInstance().clientID = self.ClientID
        SPTAuth.defaultInstance().redirectURL = self.RedirectURL
        
        let url = SPTAuth.defaultInstance().loginURL
        
        self.safariVC = SFSafariViewController(url: url!)
        
        self.present(safariVC!, animated: true, completion: nil)
    }
    
    func loginWasHandled(_ notification: Notification) {
        print("zzz: loginWasHandled\n")
        if let session = notification.object as? SPTSession {
            self.spotifySession? = session
            userVerify(uname: session.canonicalUsername)
            UserData.sharedInstance.userId = session.canonicalUsername
        }
        
        self.spotifyLoginButton?.isEnabled = false
        self.descriptionLabel?.text = "Successfully Authenticated!"
        self.descriptionLabel?.textAlignment = NSTextAlignment.center
        
        self.safariVC!.dismiss(animated: true, completion: nil)
    }
    
    func userVerify(uname: String) {
        let todoEndpoint: String = "https://sgodbold.com:5000/userVerify?userId=" + uname
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        _ = URLSessionConfiguration.default
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            let responseData = String(data: data!, encoding: String.Encoding.utf8)
            if responseData == "usernoexist" {
                print("zzz: USER DOES NOT EXIST. CREATE NEW ONE")
                let userTypeController = UserTypeController()
                self.present(userTypeController, animated: true, completion: nil)
            } else {
                print("zzz: USER EXISTS. WE NEED TO KNOW WHAT TYPE OF USER THEY ARE")
                if responseData == "vendor" {
                    UserData.sharedInstance.userIsExplorer = false
                } else {
                    UserData.sharedInstance.userIsExplorer = true
                }
                let mapViewController = MapViewController()
                self.present(mapViewController, animated: true, completion: nil)
            }
            print("zzz: \(responseData!)")
            print("zzz: \(response!)")
            print("zzz: \(error)")
        })
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

