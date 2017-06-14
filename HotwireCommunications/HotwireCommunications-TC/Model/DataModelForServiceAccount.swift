//
//  DataModelForServiceAccount.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-27 on 07/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//



import UIKit

class DataModelForServiceAccount: NSObject {

    var name:String?
    var account_number:String?
    var addressLine1:String?
    var addressLine2:String?
    var addressState:String?
    var addressCity:String?
    var post_code:String?
    var primary_email:String?
    var primay_number:String?
    var communityName : String?
  
    override init() {}
    
  public init(name:String , accountNumber:String , address1:String , address2:String , State:String , City:String , PostalCode:String , Email:String , MobileNumber:String,communityName:String) {
        self.name = name
        self.account_number = accountNumber
        self.addressLine1 = address1
        self.addressLine2 = address2
        self.addressState = State
        self.addressCity = City
        self.post_code = PostalCode
        self.primary_email = Email
        self.primay_number = MobileNumber
        self.communityName = communityName
        super.init()
    }
    
    
}
