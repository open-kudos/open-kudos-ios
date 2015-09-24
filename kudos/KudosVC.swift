//
//  ViewController.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 12/08/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

import UIKit

class KudosVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var btnGive: UIButton!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtMessage: UITextField!
    @IBOutlet var txtKudosAmount: UITextField!
    @IBOutlet var followingTable: UITableView!
    
    var defaultUser : UserModel!
    var searchResults : [UserModel]!
    
    let textCellIdentifier = "TextCell"
    
    var loadingActivity : CozyLoadingActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultUser = UserModel(firstName : "Search", lastName : "results:", email : "")
        searchResults = [defaultUser]
        followingTable.delegate = self
        followingTable.dataSource = self
        
        txtEmail.delegate = self
        txtKudosAmount.delegate = self
        txtMessage.delegate = self
        print("kudos screen load")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memmory warning")
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addFolower(sender: AnyObject) {
        closeAllInputs()
        loadingActivity = CozyLoadingActivity(text: "Loading...", sender: self, disableUI: true)
        performSearchUser()
    }
    
    @IBAction func giveKudos(sender: AnyObject) {
        if(txtEmail.text!.isEmpty || txtMessage.text!.isEmpty || txtKudosAmount.text!.isEmpty) {
            showDialog("Please fill in all the fields", title: "Give kudos failed")
        } else {
            closeAllInputs()
            loadingActivity = CozyLoadingActivity(text: "Loading...", sender: self, disableUI: true)
            performGiveKudos()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("kudos screen apear")
        //checkSessionActive()
    }
    
    func performGiveKudos() {
        //spinner.startAnimating()
        DataManager.giveKudos(txtEmail.text!, amount: txtKudosAmount.text!, message: txtMessage.text!) { (response) -> Void in
            if response.error {
                print("should show give kudos failed")
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                    self.showDialog("Server error", title: "Give kudos failed")
                }
            } else {
                let json = JSON(data: response.json!)
                if let info = json["receiver"].string {
                    let amount : Int = json["amount"].int!
                    print("data from give kudos \(info)")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadingActivity.hideLoadingActivity(success: true, animated: false)
                        self.showDialog("Give kudos success!", title: "\(info) received \(amount) kudos!")
                    }
                } else {
                    print("wrong mapping \(json)")
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                }
            }
        }
    }
    
    func performSearchUser() {
        DataManager.searchUser(txtEmail.text!) { (response) -> Void in
            if response.error {
                print("should show search user failed")
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                    self.showDialog("Server error", title: "Search user failed")
                }
            } else {
                self.searchResults = [self.defaultUser]
                let json = JSON(data: response.json!)
                print("search json: \(json)")
                if let users = json["userList"].array {
                    for user in users {
                        let completeUser = UserModel(firstName : "noname", lastName : "", email : "")
                        if let email = user["email"].string {
                            completeUser.email = email
                        }
                        if let firstName = user["firstName"].string {
                            completeUser.firstName = firstName
                        }
                        if let lastName = user["lastName"].string {
                            completeUser.lastName = lastName
                        }
                        self.searchResults.append(completeUser)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.followingTable.reloadData()
                        self.loadingActivity.hideLoadingActivity(success: true, animated: false)
                    }
                } else {
                    print("wrong mapping \(json)")
                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = searchResults[row].firstName + " " + searchResults[row].lastName
        print("return row \(searchResults[row].firstName)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("selected row \(searchResults[row].email)")
        dispatch_async(dispatch_get_main_queue()) {
            self.txtEmail.text = self.searchResults[row].email
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func closeAllInputs() {
        textFieldShouldReturn(txtMessage)
        textFieldShouldReturn(txtKudosAmount)
        textFieldShouldReturn(txtEmail)
    }
    
}

