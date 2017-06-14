//
//  DataModelForAccountManager.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 18/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataModelForAccountManager
{
  var aboutManager : String?
  var mngrName : String?
  var mngrImgUrl : String?
  var c_name : String?
  var mngrOfficeAddress : String?
  var mngrOfficeContact : String?
  var mngrPersonalContact : String?
  var mngr_msa_pro_id : String?
 
  init(dictAccontManagerDetail: [String : JSON])
  {
    //Here we have used the nil coalescing operator to handle the nil values.you can assign default value if it is nil.
    
    self.aboutManager = dictAccontManagerDetail["m_about"]?.stringValue ?? ""
    self.mngrName = dictAccontManagerDetail["m_name"]?.stringValue ?? ""
    self.mngrImgUrl = dictAccontManagerDetail["m_picture"]?.stringValue ?? ""
    self.c_name = dictAccontManagerDetail["c_name"]?.stringValue ?? ""
    self.mngrOfficeAddress = dictAccontManagerDetail["m_office_address"]?.stringValue ?? ""
    self.mngrOfficeContact = dictAccontManagerDetail["m_phone_work"]?.stringValue ?? ""
    self.mngrPersonalContact = dictAccontManagerDetail["m_phone_mobile"]?.stringValue ?? ""
    self.mngr_msa_pro_id =  dictAccontManagerDetail["msa_pro_id"]?.stringValue ?? ""
    msa_id = self.mngr_msa_pro_id!
  }
  
  
}
