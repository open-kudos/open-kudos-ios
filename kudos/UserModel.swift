//
//  UserModel.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 07/09/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

class UserModel {
    
    var totalKudos : Int!
    var remainingKudos : Int!
    var firstName : String!
    var email : String!
    var lastName : String!
    
    init(firstName : String, lastName : String, email : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
}


