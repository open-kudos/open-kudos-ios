//
//  LoginVC.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 12/08/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var sldRememberMe: UISwitch!
    
    var loadingActivity : CozyLoadingActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtPassword.delegate = self
        print("login view loaded")
        
    }
    
    @IBAction func signingTapped(sender: UIButton) {
        //authentication code
        if(txtEmail.text!.isEmpty || txtPassword.text!.isEmpty) {
            showLoginFailed()
        } else {
            loadingActivity = CozyLoadingActivity(text: "Loading...", sender: self, disableUI: true)
            performLogin()
        }
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    func showLoginFailed() {
        let alertView: UIAlertView = UIAlertView()
        alertView.title = "Login failed"
        alertView.message = "Please enter correct credentials"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func showLoginSuccess() {
        print("dismiss login screen")
        self.performSegueWithIdentifier("goto_main_after_login", sender: self)
    }
    
    func performLogin() {
        DataManager.login(txtEmail.text!, password: txtPassword.text!) { (response) -> Void in
            if response.error {
                print("should show login failed")
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                    self.showLoginFailed()
                }
            } else {
                let json = JSON(data: response.json!)
                self.initializeUserObject(json)
                if let info = json["email"].string {
                    if self.sldRememberMe.on {
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setBool(true, forKey: "REMEMBER_ME")
                        prefs.setObject(self.txtEmail.text, forKey: "EMAIL")
                        prefs.setObject(self.txtPassword.text, forKey: "PASS")
                        prefs.synchronize()
                    }
                    print("data from login \(info)")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadingActivity.hideLoadingActivity(success: true, animated: false)
                        self.showLoginSuccess()
                    }
                } else {
                    print("wrong mapping \(json)")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                        self.showLoginFailed()
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    }
    
}
