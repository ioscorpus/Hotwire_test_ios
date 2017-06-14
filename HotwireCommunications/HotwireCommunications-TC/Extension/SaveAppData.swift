//
//  SaveAppData.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 13/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController
{
  func saveAppData(withObject : Any, forKey: String)
  {
    let saveData = UserDefaults.standard
    saveData.set(withObject, forKey: forKey)
    saveData.synchronize()
  }
  func getSavedInfo(withKey : String) -> Any
  {
    return UserDefaults.standard.object(forKey: withKey) ?? ""
  }
  
}
