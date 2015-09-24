//
//  SignupVC.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 12/08/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPasswordConfirm: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    
    var loadingActivity : CozyLoadingActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
    }
    
    @IBAction func registerTapped(sender: UIButton) {
        if(txtEmail.text!.isEmpty || txtPassword.text!.isEmpty || txtPasswordConfirm.text!.isEmpty || txtFirstName.text!.isEmpty || txtLastName.text!.isEmpty) {
            showRegisterFailed("Do not leave empty fields!")
        } else if (txtPassword.text != txtPasswordConfirm.text){
            showRegisterFailed("Passwords do not match!")
        } else {
            loadingActivity = CozyLoadingActivity(text: "Loading...", sender: self, disableUI: true)
            performRegister()
        }
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtPasswordConfirm.resignFirstResponder()
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
    }
    
    func showRegisterFailed(message : String) {
        let alertView: UIAlertView = UIAlertView()
        alertView.title = "Register failed"
        alertView.message = message
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func showRegisterSuccess() {
        print("dismiss register screen")
        let alertView: UIAlertView = UIAlertView()
        alertView.title = "Register success"
        alertView.message = "Go to email for confirmation. Try login after that."
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
        txtEmail.text = ""
        txtPassword.text = ""
        txtPasswordConfirm.text = ""
        txtLastName.text = ""
        txtFirstName.text = ""
    }
    
    func performRegister() {
        DataManager.register(txtFirstName.text!, lastName : txtLastName.text!, email: txtEmail.text!, password: txtPassword.text!, confirmPassword : txtPasswordConfirm.text!) { (response) -> Void in
            if response.error {
                print("should show register failed")
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                    self.showRegisterFailed("Server error. Try again.")
                }
            } else {
                let json = JSON(data: response.json!)
                if let info = json["email"].string {
                    print("data from register \(info)")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadingActivity.hideLoadingActivity(success: true, animated: false)
                        self.showRegisterSuccess()
                    }
                } else {
                    print("wrong mapping \(json)")
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
