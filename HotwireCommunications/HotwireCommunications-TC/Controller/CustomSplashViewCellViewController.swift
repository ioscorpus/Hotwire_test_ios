//
//  CustomSplashViewCellViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 06/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomSplashViewCellViewController: BaseViewController {

  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var restartingAppLable: UILabel!
  var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
      restartingAppLable.textColor = kColor_continueSelected
      
        // Do any additional setup after loading the view.
       //timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.launchDesiredScreen), userInfo: nil, repeats: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  /***********************************************************************************************************
   <Name> webServiceCallingToUpdateUserLanguage </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  18/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToUpdateUserLanguage(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    
    activityIndicator.startAnimating()
    
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      
      if data != nil{
        
        self.methodToHandelAcountStatusSuccess(data:data!)
      }else{
        self.methodToHandelAccountStatusfailure(error: error!)
      }
      
    }
  }
  
  

  /***********************************************************************************************************
   <Name> webServiceCallingTogetAccountStatus </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  18/01/17 </Date>
   </History>
   **********************************************************************************************************
  func webServiceCallingTogetAccountStatus(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    
    activityIndicator.startAnimating()
   
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      
      if data != nil{
        
       self.methodToHandelAcountStatusSuccess(data:data!)
      }else{
       self.methodToHandelAccountStatusfailure(error: error!)
      }
      
    }
  }
  */
  override func methodToHandelAcountStatusSuccess(data:SwiftyJSON.JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      Utility.storeUserAccountStatus(fromDict: data["Data"]["AccountStatus"].dictionaryObject!)
      launchDesiredScreen()
      
    }else{
      let languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      let errorcode = data["ErrorCode"].intValue
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
        self.showTheAlertViewWithLoginButton(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: data["Message"].stringValue, languageCode: languageCode)
      default:
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["ErrorType"].stringValue, languageCode: languageCode)
      }
    }
    
  }
/*
  func methodToHandelAccountStatusfailure(error:NSError?){
    if error != nil{
      let languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  */
  func launchDesiredScreen(){
    timer.invalidate()
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
    let mainViewController = storyboard.instantiateViewController( withIdentifier: "pageViewControlleSecond")
    let initialViewController = mainViewController
    appDelegate.window?.rootViewController = UINavigationController(rootViewController: initialViewController)
    appDelegate.window?.makeKeyAndVisible()
    /*
    // initialViewController.selectedIndex = index
    if(!initialViewController.conforms(to: UITabBarControllerDelegate.self)){
     
    }else{
      AppDelegate.loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard: kStoryBoardMain, withStoryboardIdentifier: "TabBarController", onSelectedIndex: 0)
    }*/
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
