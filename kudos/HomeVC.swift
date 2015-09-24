//
//  ViewController.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 12/08/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var remainingKudosLabel: UILabel!
    @IBOutlet var totalKudosLabel: UILabel!
    @IBOutlet var incomingTabel: UITableView!
    
    var defaultTrans : TransactionModel!
    var incomingTrans : [TransactionModel]!
    
    let textCellIdentifier = "TransCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home screen load")
        defaultTrans = TransactionModel(senderEmail : "Incoming kudos", amount : 0)
        incomingTrans = [defaultTrans]
        incomingTabel.delegate = self
        incomingTabel.dataSource = self
        //checkSessionActive()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("home screen apear")
        setupScreen()
        
    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        DataManager.logout()
        print("goto login screen")
        self.performSegueWithIdentifier("goto_login_after_logout", sender: self)
    }
    
    func setupScreen() {
        print("home screen setup")
        getIncomingTrans()
        print("home screen remaining kudos")
        DataManager.fetcRemainingKudos { (response) -> Void in
            if response.error {
                print("some error")
            } else {
                let json = JSON(data: response.json!)
                print("data from check remaining \(json)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.remainingKudosLabel.text = "Remaining: " + "\(json)"
                }
            }
        }
        print("home screen total kudos")
        DataManager.fetchTotalKudos { (response) -> Void in
            if response.error {
                print("some error")
            } else {
                let json = JSON(data: response.json!)
                print("data from check total \(json)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.totalKudosLabel.text = "Total: " + "\(json)"
                }
            }
        }
    }
    
    func getIncomingTrans() {
        DataManager.fetchIncomingKudos() { (response) -> Void in
            if response.error {
                print("get incoming kudos failed")
                //                dispatch_async(dispatch_get_main_queue()) {
                //                    self.loadingActivity.hideLoadingActivity(success: false, animated: false)
                //                    self.showDialog("Server error", title: "Search user failed")
                //                }
            } else {
                self.incomingTrans = [self.defaultTrans]
                let json = JSON(data: response.json!)
                print("incoming kudos json: \(json)")
                if let transactions = json.array {
                    for trans in transactions {
                        let completeTrans = TransactionModel(senderEmail: "noemail", amount: 0)
                        if let email = trans["senderEmail"].string {
                            completeTrans.senderEmail = email
                        }
                        if let amount = trans["amount"].int {
                            completeTrans.amount = amount
                        }
                        self.incomingTrans.append(completeTrans)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.incomingTabel.reloadData()
                    }
                } else {
                    print("wrong mapping \(json)")
                    self.incomingTrans = [self.defaultTrans]
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = incomingTrans[row].senderEmail + " " + String(incomingTrans[row].amount)
        print("return row \(incomingTrans[row].senderEmail)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let row = indexPath.row
        //        dispatch_async(dispatch_get_main_queue()) {
        //            self.txtEmail.text = self.searchResults[row].email
        //        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomingTrans.count
    }
    
    
}

