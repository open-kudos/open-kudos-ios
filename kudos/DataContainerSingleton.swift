//
//  DataContainerSingleton.swift
//  SwiftDataContainerSingleton
//
//  Created by Duncan Champney on 4/19/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Foundation
import UIKit


/**
This struct defines the keys used to save the data container singleton's properties to NSUserDefaults.
This is the "Swift way" to define string constants.
*/
struct DefaultsKeys
{
    static let firstName  = "firstName"
    static let lastName = "lastName"
    static let phone = "phone"
    static let startedToWork = "startToWork"
    static let position = "position"
    static let department = "department"
    static let team = "team"
    static let email = "email"
    static let birthday = "birthday"
}

/**
:Class:   DataContainerSingleton
This class is used to save app state data and share it between classes.
It observes the system UIApplicationDidEnterBackgroundNotification and saves its properties to NSUserDefaults before
entering the background.
Use the syntax `DataContainerSingleton.sharedDataContainer` to reference the shared data container singleton
*/

class DataContainerSingleton
{
    static let sharedDataContainer = DataContainerSingleton()
    
    //------------------------------------------------------------
    //Add properties here that you want to share accross your app
    var firstName: String?
    var lastName: String?
    var phone: String?
    var startedToWork: String?
    var position: String?
    var department: String?
    var team: String?
    var email: String?
    var birthday: String?
    //------------------------------------------------------------
    
    var goToBackgroundObserver: AnyObject?
    
    init()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        //-----------------------------------------------------------------------------
        //This code reads the singleton's properties from NSUserDefaults.
        //edit this code to load your custom properties
        firstName = defaults.objectForKey(DefaultsKeys.firstName) as! String?
        lastName = defaults.objectForKey(DefaultsKeys.lastName) as! String?
        phone = defaults.objectForKey(DefaultsKeys.phone) as! String?
        startedToWork = defaults.objectForKey(DefaultsKeys.startedToWork) as! String?
        position = defaults.objectForKey(DefaultsKeys.position) as! String?
        department = defaults.objectForKey(DefaultsKeys.department) as! String?
        team = defaults.objectForKey(DefaultsKeys.team) as! String?
        email = defaults.objectForKey(DefaultsKeys.email) as! String?
        birthday = defaults.objectForKey(DefaultsKeys.birthday) as! String?
        //-----------------------------------------------------------------------------
        
        //Add an obsever for the UIApplicationDidEnterBackgroundNotification.
        //When the app goes to the background, the code block saves our properties to NSUserDefaults.
        goToBackgroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            UIApplicationDidEnterBackgroundNotification,
            object: nil,
            queue: nil)
            {
                (note: NSNotification!) -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                //-----------------------------------------------------------------------------
                //This code saves the singleton's properties to NSUserDefaults.
                //edit this code to save your custom properties
                defaults.setObject( self.firstName, forKey: DefaultsKeys.firstName)
                defaults.setObject( self.lastName, forKey: DefaultsKeys.lastName)
                defaults.setObject( self.phone, forKey: DefaultsKeys.phone)
                defaults.setObject( self.startedToWork, forKey: DefaultsKeys.startedToWork)
                defaults.setObject( self.position, forKey: DefaultsKeys.position)
                defaults.setObject( self.department, forKey: DefaultsKeys.department)
                defaults.setObject( self.team, forKey: DefaultsKeys.team)
                defaults.setObject( self.email, forKey: DefaultsKeys.email)
                defaults.setObject( self.birthday, forKey: DefaultsKeys.birthday)
                //-----------------------------------------------------------------------------
                
                //Tell NSUserDefaults to save to disk now.
                defaults.synchronize()
        }
    }
}
