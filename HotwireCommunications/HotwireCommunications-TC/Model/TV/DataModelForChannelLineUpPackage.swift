//
//  DataModelForChannelLineUpPackage.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 21/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataModelForChannelLineUpPackage
{
  var package_Id : String
  var package_Name : String
  var package_Srt : String
  
  init(dictPkgDetail:[String : JSON])
  {
    self.package_Id = dictPkgDetail["package_id"]?.stringValue ?? ""
    self.package_Name = dictPkgDetail["name"]?.stringValue ?? ""
    self.package_Srt = dictPkgDetail["srt"]?.stringValue ?? ""
  }
  
}
