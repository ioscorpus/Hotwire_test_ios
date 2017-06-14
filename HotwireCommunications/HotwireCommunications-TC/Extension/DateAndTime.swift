//
//  DateAndTime.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 13/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController
{
  func getTimeDifferenceBetweenLoginTimeAndCurrentTime(loginDate: Date) -> (String,Bool)
  {
    
    let date1:Date = Date()
    let date2: Date = loginDate
    
    let calender:Calendar = Calendar.current
    let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2, to: date1)
    print(components)
    var returnString:String = ""
    var userIsValidForChangeAccWithoutPswrd : Bool = false
    if components.year! >= 1
    {
      returnString = String(describing: components.year)+" year ago"
      userIsValidForChangeAccWithoutPswrd = false
    }
    else if components.month! >= 1
    {
      returnString = String(describing: components.month)+" month ago"
      userIsValidForChangeAccWithoutPswrd = false
    }
    else if components.day! >= 1
    {
      returnString = String(describing: components.day) + " days ago"
      userIsValidForChangeAccWithoutPswrd = false
    }
    else if components.hour! >= 1
    {
      returnString = String(describing: components.hour) + " hour ago"
      userIsValidForChangeAccWithoutPswrd = false
    }
    else if components.minute! >= 10
    {
      returnString = String(describing: components.minute) + " min ago"
      userIsValidForChangeAccWithoutPswrd = false
    }
    else if components.second! < 60
    {
      returnString = "Just Now"
      userIsValidForChangeAccWithoutPswrd = true
    }
    else
    {
      userIsValidForChangeAccWithoutPswrd = true
    }
    
    return (returnString,userIsValidForChangeAccWithoutPswrd)
  }

}
