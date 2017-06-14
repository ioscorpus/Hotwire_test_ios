//
//  EmailValidation.swift
// HotwireCommunications
//
// Created by Chetu-macmini-26 on 20/10/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//


import Foundation
extension BaseViewController{
/***********************************************************************************************************
 <Name> isValidEmail </Name>
 <Input Type>    </Input Type>
 <Return> void </Return>
 <Purpose> Is used to validate email id</Purpose>
 <History>
 <Header> Version 1.0 </Header>
 <Date> 02/06/16 </Date>
 </History>
 ***********************************************************************************************************/
  // email validation method to return boolen
func isValidEmail(testStr:String) -> Bool {
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
  let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
  return emailTest.evaluate(with: testStr)
}
  func testMsg(){
    print("test")
  }
}

/***********************************************************************************************************
 <Name> isEnteredTextIsValid </Name>
 <Input Type>    </Input Type>
 <Return> Bool </Return>
 <Purpose> Is used to test that corresponding textField or textView contains only spaces and newline characters</Purpose>
 <History>
 <Header> Version 1.0 </Header>
 <Date> 20/04/17 </Date>
 </History>
 ***********************************************************************************************************/
extension String
{
  func isStringEmptyAfterRemovingNewLinesAndSpaces() -> Bool
  {
    if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    {
      return true
    }
    return false
  }
}

/***********************************************************************************************************
 <Name> Server Messages Conversion </Name>
 <Input Type>    </Input Type>
 <Return> String </Return>
 <Purpose>This is used to make the alert message perfect with title</Purpose>
 <History>
 <Header> Version 1.0 </Header>
 <Date> 28/04/17 </Date>
 </History>
 ***********************************************************************************************************/
extension String
{
  func titleName(languageCode code:String) -> String
  {
    if self.components(separatedBy: "#").count > 1
    {
      return(self.components(separatedBy: "#"))[0]
    }
    else
    {
      return "Alert".localized(lang: code, comment: "")
    }
    
  }
  func message(languageCode code:String) -> String
  {
    if self.components(separatedBy: "#").count > 1
    {
      return(self.components(separatedBy: "#"))[1]
    }
    else
    {
      return self
    }
    
  }
}
