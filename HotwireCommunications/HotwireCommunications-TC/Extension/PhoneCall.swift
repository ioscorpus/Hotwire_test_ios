//
//  PhoneCall.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 20/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController
{
  func dialPhone(withDialTitle: String,contactNumber: String,languageCode: String)
  {
  
    let dialerAlert = UIAlertController(title: "Support_Call".localized(lang: languageCode, comment: "")+" "+withDialTitle, message: nil, preferredStyle: .alert)
    dialerAlert.addAction(UIAlertAction(title: "Support_Yes".localized(lang: languageCode, comment: ""), style: .default, handler: { (alert) in
      self.makeCall(withPhoneNumber: contactNumber)
    }))
    dialerAlert.addAction(UIAlertAction(title: "Support_Cancel".localized(lang: languageCode, comment: ""), style: .cancel, handler: { (alert) in
      
    }))
    self.navigationController?.present(dialerAlert, animated: true, completion: nil)
    return
  }
 
  
  func makeCall(withPhoneNumber:String)
  {
    if let phoneCallURL = URL(string: "tel://"+withPhoneNumber)
    {
      let application:UIApplication = UIApplication.shared
      if (application.canOpenURL(phoneCallURL)) {
        if #available(iOS 10.0, *) {
          application.open(phoneCallURL, options: [:], completionHandler: nil)
        } else {
          application.openURL(phoneCallURL)
        }
      }
    }
  }

  
}
