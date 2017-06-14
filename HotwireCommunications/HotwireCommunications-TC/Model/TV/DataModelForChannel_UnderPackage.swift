//
//  DataModelForChannel_UnderPackage.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 21/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataModelForChannel_UnderPackage
{
  var chnl_Number : String
  var chnl_Name : String
  var chnl_Is_HD : String
  var chnl_Is_RplyOut : String
  var chnl_Is_RangeIn : String
  
  init(dictChnlDetail:[String : JSON])
  {
    self.chnl_Number = dictChnlDetail["number"]?.stringValue ?? ""
//    if self.chnl_Number == "" {
//      self.chnl_Number = "0"
//    }
    if self.chnl_Number.characters.count == 1{
      self.chnl_Number = "00"+self.chnl_Number
    }
    else if self.chnl_Number.characters.count == 2
    {
       self.chnl_Number = "0"+self.chnl_Number
    }
    self.chnl_Name = self.chnl_Number+"  "+(dictChnlDetail["name_channel"]?.stringValue)!
    self.chnl_Is_HD = dictChnlDetail["hd"]?.stringValue ?? ""
    self.chnl_Is_RplyOut = dictChnlDetail["replay_out"]?.stringValue ?? ""
    self.chnl_Is_RangeIn = dictChnlDetail["range_in"]?.stringValue ?? ""
  }
  
}
