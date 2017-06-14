//
//  Utility.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 20/02/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
import UIKit

public class Utility:NSObject{

  class func pushDesiredViewControllerOver(viewController:UIViewController){
  let localUserdefault = UserDefaults.standard
   
    if(localUserdefault.object(forKey: kEmail) as? String != nil && localUserdefault.object(forKey: kEmailVerified) as! String == "0"){
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kSegue_VarificationEmailAddress) as! VerifyEmailAddressViewController
      mainViewController.isAlreadyLogin = true
      viewController.navigationController?.pushViewController(mainViewController, animated: true)
      
    }else if(localUserdefault.object(forKey: kLastLoginTime)  == nil)
    {
      let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: "LoginUserVarificationViewController") //as! ActivatePushNotificationViewController
      //    mainViewController.login = true
      viewController.navigationController?.pushViewController(mainViewController, animated: true)
     //viewController.performSegue(withIdentifier: kSegue_UserVarificationtermAndConditon, sender: self)
    }else if(localUserdefault.object(forKey: kTOSAccepted) as! String == "0" && localUserdefault.object(forKey: kPPAccepted) as! String
      == "0"){
      let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_TermsNCondition) as! TermsNConditionTableViewController
      
      viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }
    else if(localUserdefault.object(forKey: kMobileNumber) as? String == nil){
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
      mainViewController.isAfterLogin = true
     // mainViewController.signUpdetailsObject = signupDetails
      viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else if(localUserdefault.object(forKey: kMobileNumberVerified) as! String == "0"){
     /* let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
      mainViewController.isAfterLogin = true
      viewController.navigationController?.pushViewController(mainViewController, animated: true)*/
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneVerification) as! VerifyPhoneNoViewController
      mainViewController.login = true
      mainViewController.isAlreadyLogin = true
      mainViewController.phoneNum = localUserdefault.object(forKey: kMobileNumber) as? String
      viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else if(localUserdefault.object(forKey: kEmail) as? String == nil){
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_emailVarification) as! LoginEmailVerificationViewController
      mainViewController.isAlreadyLogin = true
      viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else if(localUserdefault.object(forKey: kEmailVerified) as! String == "0"){
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kSegue_VarificationEmailAddress) as! VerifyEmailAddressViewController
      mainViewController.isAlreadyLogin = true
      viewController.navigationController?.pushViewController(mainViewController, animated: true)

    }
    else if(((localUserdefault.object(forKey: kNotificationEnable) as! String).characters.count == 0)){
      let storyboard = UIStoryboard(name: kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_PushNotification) as! ActivatePushNotificationViewController//TabBarViewController
      mainViewController.login = true
     viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else{
       let mainStoryboard = "Main"
      _ = UIApplication.shared.delegate! as! AppDelegate
      AppDelegate.loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard: mainStoryboard, withStoryboardIdentifier: "TabBarController", onSelectedIndex: 0)

    }
  }
  
  class func storeUserAccountStatus(fromDict:Dictionary<String, Any>){
    let localUserdefault = UserDefaults.standard
    for (key,value) in fromDict{
      if ((value as? NSNull) != nil){
        localUserdefault.set("", forKey: key)
   
      }
      else{
        
 localUserdefault.set(value, forKey: key)
      }
      
    }
    localUserdefault.synchronize()
  }
  
  class func getDesiredViewController()->UIViewController{
    let localUserdefault = UserDefaults.standard
    if(localUserdefault.object(forKey: kEmail) as? String != nil && localUserdefault.object(forKey: kEmailVerified) as! String == "0"){
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kSegue_VarificationEmailAddress) as! VerifyEmailAddressViewController
      mainViewController.isAlreadyLogin = true
      return mainViewController
      
    }else if(localUserdefault.object(forKey: kLastLoginTime) == nil)
    {
      let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: "LoginVarification")
      return mainViewController
    }else if(localUserdefault.object(forKey: kTOSAccepted) as! String == "0" && localUserdefault.object(forKey: kPPAccepted) as! String
      == "0"){
      let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_TermsNCondition) as! TermsNConditionTableViewController
      //    mainViewController.login = true
      
      return mainViewController
      //viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else if(localUserdefault.object(forKey: kMobileNumber)as? String == nil){
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
      mainViewController.isAfterLogin = true
     
      return mainViewController
     // viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else if(localUserdefault.object(forKey: kMobileNumberVerified) as! String == "0"){
//      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
//      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
//      mainViewController.isAfterLogin = true
//      
//      return mainViewController
      
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneVerification) as! VerifyPhoneNoViewController
      mainViewController.login = true
      mainViewController.isAlreadyLogin = true
      mainViewController.phoneNum = localUserdefault.object(forKey: kMobileNumber) as? String
      return mainViewController
      //viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else if(localUserdefault.object(forKey: kEmail) as? String == nil){
      // viewController.performSegue(withIdentifier: kSegue_VarificationEmailAddress, sender: self)
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_emailVarification) as! LoginEmailVerificationViewController
      mainViewController.isAlreadyLogin = true
      return mainViewController
    //  viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else if(localUserdefault.object(forKey: kEmailVerified) as! String == "0"){
      //viewController.performSegue(withIdentifier: kSegue_LoginEmailVarification, sender: self)
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kSegue_VarificationEmailAddress) as! VerifyEmailAddressViewController
      mainViewController.isAlreadyLogin = true
      return mainViewController
      //viewController.navigationController?.pushViewController(mainViewController, animated: true)
      
    }else if((localUserdefault.object(forKey: kNotificationEnable) == nil) || (localUserdefault.object(forKey: kNotificationEnable) as! String).characters.count == 0){
      let storyboard = UIStoryboard(name: kStoryBoardSignUp, bundle: nil)
      //      let appDelegate = UIApplication.shared.delegate! as! AppDelegate
      let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_PushNotification) as! ActivatePushNotificationViewController//TabBarViewController
      mainViewController.login = true
      return mainViewController
      //viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }else{
      let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: "TabBarController") as! TabBarViewController
      return mainViewController
    }
  }

  class func restartApp(viewController:UIViewController){
    for key in UserDefaults.standard.dictionaryRepresentation().keys {
      UserDefaults.standard.removeObject(forKey: key.description)
    }
    let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
    let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_CustomLaunch)
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    
      appDelegate.window?.rootViewController = UINavigationController(rootViewController: mainViewController)
      appDelegate.window?.makeKeyAndVisible()
  }
  
  class func getUserNameFormCloudID(rawDataUrlString:String) -> String {
   /* let startingIndex = rawDataUrlString.indexOf(string: "username=")
    
    let substring2 = rawDataUrlString.substring(from: startingIndex!)//
    let endingIndex = substring2.indexOf(string: "&zipcode=")
 */
    return UserDefaults.standard.object(forKey: kUserNameKey) as! String
  }
}
