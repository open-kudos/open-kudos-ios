//
//  TransactionModel.swift
//  kudos
//
//  Created by Mindaugas Jaunius on 20/09/15.
//  Copyright © 2015 Mindaugas Jaunius. All rights reserved.
//

class TransactionModel {
    
    var amount : Int!
    var senderEmail : String!
    var message : String!
    
    init(senderEmail : String, amount : Int) {
        self.senderEmail = senderEmail
        self.amount = amount
    }
    
}
