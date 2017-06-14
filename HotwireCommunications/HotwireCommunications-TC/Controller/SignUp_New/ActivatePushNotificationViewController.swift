//
//  ActivatePushNotificationViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 08/10/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON

class ActivatePushNotificationViewController:BaseViewController {
 // var languageCode:String!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var contentView: UIView!
  
  @IBOutlet var lblPageTitle: UILabel!
  @IBOutlet var lblServiceCreditOffer: UILabel!
  @IBOutlet var lblAboutPushNotificationInfo: UILabel!
  @IBOutlet weak var btnTurnOnPushNotification: UIButton!
  @IBOutlet var notificationImageView: UIImageView!
  // login or signup flag
  var login:Bool = false
  enum notificationChoice{
    case accepted
    case rejected
   }
  
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewProperty()
    
    // Do any additional setup after loading the view.
  }
  //MARK:- DeviceOrientation changed method
  
//  func deviceRotated()
//  {
//    if loader != nil
//    {
//      
//      loader?.removeFromSuperview()
//      loader = LoaderView()
//      loader?.initLoader()
//      if let loaderView = loader
//      {
//        self.view.addSubview(loaderView)
//      }
//    }
//  }
  override func viewWillAppear(_ animated: Bool) {
   self.navigationController?.navigationBar.isHidden = false
   self.navigationItem.setHidesBackButton(true, animated: false)
    viewUpdateContentOnBasesOfLanguage()
    addNotificationObserver()
    NotificationCenter.default.addObserver(self, selector: #selector(ActivatePushNotificationViewController.userAllowPushNotificationSettingToSetNotification(_:)), name: NSNotification.Name(rawValue: "ApplicationDidRegisterForRemoteNotificationsNotification"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ActivatePushNotificationViewController.userDisallowPushNotificationSettingToSetNotification(_:)), name: NSNotification.Name(rawValue: "ApplicationDidFailToRegisterUserNotificationSettingsNotification"), object: nil)
    updateButtonStatus()
//    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
  }
  
  //MARK:- Refresh view
  /***********************************************************************************************************
   <Name> viewUpdateContentOnBasesOfLanguage </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to update content on the bases of language</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    if login{
       self.navigationItem.title =  "AccountSetup".localized(lang: languageCode, comment: "")
    }else{
    self.navigationItem.title =  "SetUp".localized(lang: languageCode, comment: "")
    }
    
    lblPageTitle.text = "TurnOnPushNotification".localized(lang: languageCode, comment: "")
    lblAboutPushNotificationInfo.text = ""//"TurnOnPushNotificationInfoText".localized(lang: languageCode, comment: "")
    lblServiceCreditOffer.text = "TurnOnPushNotificationInfoText".localized(lang: languageCode, comment: "")//"FreeServiceCredit".localized(lang: languageCode, comment: "")
    btnTurnOnPushNotification.setTitle("TurnOnPushNotificationBtnTitle".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
  //  btnTurnOnPushNotification.backgroundColor = kColor_ContinuteUnselected
    btnTurnOnPushNotification.isSelected = false
  
  }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func configureViewProperty(){
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String

    let btnSkip = UIBarButtonItem(title: "Skip".localized(lang: languageCode, comment: ""), style: .plain, target: self, action: #selector(ActivatePushNotificationViewController.skipButtonTappedAction(_:)) )
    self.navigationItem.rightBarButtonItem = btnSkip;

    
  }
  func updateButtonStatus() {
    // as currentNotificationSettings() is set to return an optional, even though it always returns a valid value, we use a sane default (.None) as a fallback
//    let notificationSettings: UIUserNotificationSettings = UIApplication.shared.currentUserNotificationSettings ?? UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil)
//  
//    if notificationSettings.types.rawValue == 0 {
//      if UIApplication.shared.isRegisteredForRemoteNotifications {
//        // set button status to 'failed'
//      } else {
//        // set button status to 'default'
//        btnTurnOnPushNotification.backgroundColor =  kColor_continueSelected
//      }
//    } else {
//      // set button status to 'completed'
//        btnTurnOnPushNotification.backgroundColor =  kColor_ContinuteUnselected
//    }
    if UIApplication.shared.isRegisteredForRemoteNotifications {
      // set button status to 'failed'
      btnTurnOnPushNotification.backgroundColor =  kColor_continueUnselected
    } else {
      // set button status to 'default'
      btnTurnOnPushNotification.backgroundColor =  kColor_continueSelected
    }

    
    

  }
  
  //MARK:- IB button action
  /***********************************************************************************************************
   <Name> continueButtonTappedAction </Name>
   <Input Type>  AnyObject  </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on continue button used to add push notification service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func continueButtonTappedAction(_ sender: AnyObject) {
   // syntex to open application setting
//    if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
//      UIApplication.sharedApplication().openURL(settingsURL)
//    }
    //
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
        if !accepted {
          print("Notification access denied.")
          self.webServiceCallingToUpdatePushNotificationStatus(prameter: ["username" : UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject], withChoice: .rejected)
          
        }else{
          print("Notification access accepted.")
          self.webServiceCallingToUpdatePushNotificationStatus(prameter: ["username" :UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject], withChoice: .accepted)
         
        }
      }
      UIApplication.shared.registerForRemoteNotifications()
    } else {
      // for ios 9 and prior
      UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
      UIApplication.shared.registerForRemoteNotifications()
    }
//    if btnTurnOnPushNotification.selected{
//      self.performSegueWithIdentifier(kSegue_PushNotificationActivation, sender: self)
//    }
  }
  /***********************************************************************************************************
   <Name> skipButtonTappedAction </Name>
   <Input Type>  AnyObject  </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on skip button used to navigate to next screen </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func skipButtonTappedAction(_ sender : UIButton){
    if (UserDefaults.standard.object(forKey: kUserId) != nil){
//      UserDefaults.standard.set("1", forKey: kNotificationEnable)
//      UserDefaults.standard.synchronize()
//      Utility.pushDesiredViewControllerOver(viewController: self)
//    self.performSegue(withIdentifier: kSegue_AccoutSetup, sender: self)
      let mainStoryboard = "Main"
      _ = UIApplication.shared.delegate! as! AppDelegate
      AppDelegate.loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard: mainStoryboard, withStoryboardIdentifier: "TabBarController", onSelectedIndex: 0)
    }else{
    self.performSegue(withIdentifier: kSegue_VarificationPhoneNo, sender: self)
    }
  }
  
  // MARK: - Navigation
  /***********************************************************************************************************
   <Name> prepareForSegue </Name>
   <Input Type> UIStoryboardSegue,AnyObject </Input Type>
   <Return> void </Return>
   <Purpose> method call when segue called  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
    self.title = "Back"
    if segue.identifier == kSegue_VarificationPhoneNo{
      if let nextViewController = segue.destination as? VerifyPhoneNoViewController {
        nextViewController.login = login
      }
    }else if segue.identifier == kSegue_AccoutSetup{
      if let nextViewController = segue.destination as? AccountSetupViewController {
        nextViewController.login = login
      }
    }
  }
  //MARK:- ADD notification
  /***********************************************************************************************************
   <Name> addNotificationObserver </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication come to foreground and update selected languge </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>   08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addNotificationObserver(){
    NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(application:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    
  }
  //notification method to update UI
  func applicationWillEnterForeground(application: UIApplication) {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    print("applicationWillEnterForeground")
    viewUpdateContentOnBasesOfLanguage()
  }
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }


  /***********************************************************************************************************
   <Name> applicationDidRegisterForRemoteNotificationsNotification </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication sucessfully register remote notification </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>   08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func userAllowPushNotificationSettingToSetNotification(_ notification: NSNotification) {
        print("applicationDidRegisterForRemoteNotificationsNotification")
        if login{
          UserDefaults.standard.set("true", forKey: "push_notification_enabled")
          UserDefaults.standard.synchronize()
          Utility.pushDesiredViewControllerOver(viewController: self)
        //  self.performSegue(withIdentifier: kSegue_AccoutSetup, sender: self)
        }else{
          self.performSegue(withIdentifier: kSegue_VarificationPhoneNo, sender: self)
        }
    }
  
//    let notificationSettings: UIUserNotificationSettings = UIApplication.sharedApplication.currentUserNotificationSettings ?? UIUserNotificationSettings(forTypes: [.None], categories: nil)
//    
//    if notificationSettings.types != .none {
//      print("applicationDidRegisterForRemoteNotificationsNotification")
//      if login{
//        self.performSegue(withIdentifier: kSegue_AccoutSetup, sender: self)
//      }else{
//        self.performSegue(withIdentifier: kSegue_VarificationPhoneNo, sender: self)
//      }
//    }
    
//  }
  /***********************************************************************************************************
   <Name> applicationDidFailToRegisterUserNotificationSettingsNotification </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication fail to register remote notification </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>   08/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  func userDisallowPushNotificationSettingToSetNotification(_ notification: NSNotification) {
   print("applicationDidFailToRegisterUserNotificationSettingsNotification")
    UserDefaults.standard.set("false", forKey: "push_notification_enabled")
    UserDefaults.standard.synchronize()
    Utility.pushDesiredViewControllerOver(viewController: self)
  //  self.performSegue(withIdentifier: kSegue_VarificationPhoneNo, sender: self)
  }
  
  
  // MARK: - web service
  
  /***********************************************************************************************************
   <Name> webServiceCallingToUpdatePushNotificationStatus </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToUpdatePushNotificationStatus(prameter:[String :AnyObject], withChoice choice:notificationChoice){
    var finalUrlToHit = kBaseUrl
    if(choice == .accepted){
     finalUrlToHit = finalUrlToHit + kPushNotificationAcceptURL
    }else{
    finalUrlToHit = finalUrlToHit + kPushNotificationRejectedURL
    }
    let loaderView = LoaderView()
    loaderView.initLoader()
    DispatchQueue.main.async { [unowned self] in
      self.view.addSubview(loaderView)
    }
   
     
    AlamoFireConnectivity.alamofirePutRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      DispatchQueue.main.async { [unowned self] in
       loaderView.removeFromSuperview()
      }
      
      if data != nil{
        
        self.methodToHandelPushNotificationStatusSuccess(data:data!,selectedChoice: choice)
      }else{
        self.methodToHandelPushNotificationStatusfailure(error: error!)
      }
      
    }
  }
  
  func methodToHandelPushNotificationStatusSuccess(data:JSON, selectedChoice choice:notificationChoice) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      if(choice == .accepted){
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ApplicationDidFailToRegisterUserNotificationSettingsNotification"), object: self)
      }else{
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ApplicationDidRegisterForRemoteNotificationsNotification"), object: self)
      }
      
    }
    /*else{
      let errorcode = data["ErrorCode"].intValue
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
        self.showTheAlertViewWithLoginButton(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: data["Message"].stringValue, languageCode: languageCode)
      default:
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["Message"].stringValue, languageCode: languageCode)
      }
    }*/
    else{
      let message = (data["Message"].stringValue)
      let errorcode = data["ErrorCode"].intValue
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
        self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
      default:
        self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
      }
    }

  }
  func methodToHandelPushNotificationStatusfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }

 }
