//
//  HideKeyBoard.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 20/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import UIKit

/***********************************************************************************************************
 <Name> Hide KeyBoard</Name>
 <Input Type>    </Input Type>
 <Return> Void </Return>
 <Purpose> Is used to hide the keyboard on click outside of the keyboard</Purpose>
 <History>
 <Header> Version 1.0 </Header>
 <Date> 20/04/17 </Date>
 </History>
 ***********************************************************************************************************/
extension UIViewController
{
  func hideKeyboard()
  {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(UIViewController.dismissKeyboard))
    
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard()
  {
    view.endEditing(true)
  }
}
