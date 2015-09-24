//
//  ViewController.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 12/08/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start screen load")
        checkSessionActive()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("start screen apear")
        
    }
    
    func checkSessionActive() {
        DataManager.isLoggedIn { (response) -> Void in
            if response.error {
                print("some error")
            } else {
                let json = JSON(data: response.json!)
                if let info = json["logged"].bool {
                    print("data from check \(info)")
                    if info {
                        print("sesions is active")
                        self.setupScreen()
                    } else {
                        print("sesions not active relog")
                        self.performRelogin()
                    }
                } else {
                    print("wrong mapping \(json)")
                }
            }
        }
    }
    
    func setupScreen() {
        print("start screen setup")
        self.performSegueWithIdentifier("goto_main_tab", sender: self)
        
    }
    
    func performRelogin() {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let rememberMe:Bool? = prefs.boolForKey("REMEMBER_ME") as Bool?
        
        if((rememberMe != nil && rememberMe == true)) {
            let email:String? = prefs.objectForKey("EMAIL") as! String?
            let pass:String? = prefs.objectForKey("PASS") as! String?
            DataManager.login(email!, password: pass!) { (response) -> Void in
                if response.error {
                    print("reloging failed")
                    //self.showLoginFailed()
                    dispatch_async(dispatch_get_main_queue()) {
                        print("goto login screen")
                        self.performSegueWithIdentifier("goto_login_register_tab", sender: self)
                    }
                } else {
                    let json = JSON(data: response.json!)
                    print("data from reloging: \(json)")
                    self.initializeUserObject(json)
                }
            }
        } else {
            print("goto login screen")
            self.performSegueWithIdentifier("goto_login_register_tab", sender: self)
        }
    }
    
    func initializeUserObject(json : JSON) {
        if let firstName = json["firstName"].string {
            DataContainerSingleton.sharedDataContainer.firstName = firstName;
        }
        if let lastName = json["lastName"].string {
            DataContainerSingleton.sharedDataContainer.lastName = lastName;
        }
        if let phone = json["phone"].string {
            DataContainerSingleton.sharedDataContainer.phone = phone;
        }
        if let startedToWork = json["startedToWorkDate"].string {
            DataContainerSingleton.sharedDataContainer.startedToWork = startedToWork ;
        }
        if let position = json["position"].string {
            DataContainerSingleton.sharedDataContainer.position = position;
        }
        if let department  = json["department "].string {
            DataContainerSingleton.sharedDataContainer.department  = department;
        }
        if let team = json["team"].string {
            DataContainerSingleton.sharedDataContainer.team = team;
        }
        if let email = json["email"].string {
            DataContainerSingleton.sharedDataContainer.email = email;
        }
        if let birthday = json["birthday"].string {
            DataContainerSingleton.sharedDataContainer.birthday = birthday;
        }
        self.setupScreen()
    }
    
}

