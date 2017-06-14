//
//  DataSourceForUserAccount.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-27 on 08/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation

class DataModelForUserAccount: NSObject {

    var name:String?
    var email:String?
    var number:String?
    var passwordDetail:String?
    var userName:String?
    var isEmailVerified:String?
    var isMobileVerified:String?
    
    override init() {}
    
  public init (name:String , email:String , number:String , passwordDetail:String , isMobileVerifed:String , isEmailVerified:String,userName:String?) {
        self.name = name
        self.email = email
        self.number = number
        self.passwordDetail = passwordDetail
        self.isMobileVerified = isMobileVerifed
        self.isEmailVerified = isEmailVerified
        self.userName = userName
        super.init()
    }
}
