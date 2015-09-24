//
//  ViewController.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 12/08/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var startedToWorkField: UITextField!
    @IBOutlet var positionField: UITextField!
    @IBOutlet var departmentField: UITextField!
    @IBOutlet var teamField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var birthdayField: UITextField!
    
    var loadingActivity : CozyLoadingActivity!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profile screen load")
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneField.delegate = self
        startedToWorkField.delegate = self
        positionField.delegate = self
        departmentField.delegate = self
        teamField.delegate = self
        emailField.delegate = self
        birthdayField.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memmory warning")
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("profile screen apear")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.firstNameField.text = DataContainerSingleton.sharedDataContainer.firstName
            self.lastNameField.text = DataContainerSingleton.sharedDataContainer.lastName
            self.emailField.text = DataContainerSingleton.sharedDataContainer.email
            self.phoneField.text = DataContainerSingleton.sharedDataContainer.phone
            self.startedToWorkField.text = DataContainerSingleton.sharedDataContainer.startedToWork
            self.positionField.text = DataContainerSingleton.sharedDataContainer.position
            self.departmentField.text = DataContainerSingleton.sharedDataContainer.department
            self.teamField.text = DataContainerSingleton.sharedDataContainer.team
            self.birthdayField.text = DataContainerSingleton.sharedDataContainer.birthday
        }
        //checkSessionActive()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveProfile(sender: UIButton) {
        if(isInputValid(birthdayField.text!) && isInputValid(startedToWorkField.text!)) {
            loadingActivity = CozyLoadingActivity(text: "Loading...", sender: self, disableUI: true)
            DataContainerSingleton.sharedDataContainer.firstName = firstNameField.text
            DataContainerSingleton.sharedDataContainer.lastName = lastNameField.text
            DataContainerSingleton.sharedDataContainer.email = emailField.text
            DataContainerSingleton.sharedDataContainer.phone = phoneField.text
            DataContainerSingleton.sharedDataContainer.startedToWork = startedToWorkField.text
            DataContainerSingleton.sharedDataContainer.position = positionField.text
            DataContainerSingleton.sharedDataContainer.department = departmentField.text
            DataContainerSingleton.sharedDataContainer.team = teamField.text
            DataContainerSingleton.sharedDataContainer.birthday = birthdayField.text
            saveUserProfile()
        } else {
            self.showDialog("Invalid date format. Should be yyyy-MM-dd", title: "Save profile info failed")
        }
    }
    
    func isInputValid(date : String) -> Bool {
        if(!date.isEmpty) {
            return isValidDate(date)
        } else {
            return true;
        }
    }
    
    func saveUserProfile() {
        //spinner.startAnimating()
        DataManager.updateUserProfile() { (response) -> Void in
            if response.error {
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                    self.showDialog("Server error", title: "Save profile info failed")
                }
            } else {
                let json = JSON(data: response.json!)
                //let amount : Int = json["amount"].int!
                print("data from update profile \(json)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingActivity.hideLoadingActivity(success: true, animated: false)
                    self.showDialog("Success!", title: "Your profile has been updated")
                }
            }
        }
    }
    
    
    func showDialog(message : String, title : String) {
        let alertView: UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func isValidDate(date : String) -> Bool {
        return date.rangeOfString("\\d{4}-[01]\\d-[0-3]\\d", options: .RegularExpressionSearch) != nil
    }
}

