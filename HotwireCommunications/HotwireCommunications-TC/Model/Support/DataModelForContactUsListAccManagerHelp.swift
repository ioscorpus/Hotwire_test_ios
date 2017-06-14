//
//  DataModelForContactUsListAccManagerHelp.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 19/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import SwiftyJSON
class  DataModelForContactUsListAccManagerHelp
{
  var strServiceType : String
  var strIssueType : String
  
  init(dictHelpDetail: [String : JSON])
  {
    self.strServiceType = dictHelpDetail["contact_content"]?.stringValue ?? ""
    self.strIssueType = dictHelpDetail["code"]?.stringValue ?? ""
  }
}
