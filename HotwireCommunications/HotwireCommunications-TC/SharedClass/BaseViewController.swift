//
//  BaseViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 09/09/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

//

import UIKit
import SwiftyJSON
// import SynacorCloudId
class BaseViewController: UIViewController {
  enum FlowType {
    case Login
    
    case SignUp
    case SignUpPopup
    case ResetPassword
    case RecoverUsername
  }
  enum otpVerificationType {
    case mobileNumber
    case email
  }
   let swipeInteractionController = SwipeInteractionController()
   let flipPresentAnimationController = FlipPresentAnimationController()
   let flipDismissAnimationController = FlipDismissAnimationController()
   var languageCode:String!
   var loaderInBase: LoaderView?

 func newDoneButtonWithOld(oldButton: UIView, withkeyboadState keyboardShow:Bool) -> UIButton{
  return UIButton()
  }
    override func viewDidLoad()
    {
      super.viewDidLoad()
      let navigationBar = self.navigationController?.navigationBar
      navigationBar?.isHidden = false
      navigationBar?.isTranslucent = false
      navigationBar?.barStyle = UIBarStyle.default
      navigationBar?.barTintColor = kColor_NavigationBarColor
      navigationBar?.tintColor = UIColor.white
      navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      UIApplication.shared.isStatusBarHidden = false
      UIApplication.shared.statusBarStyle = .lightContent
     // SFUIDisplay-Semibold
      self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :kFontStyleSemiBold18!, NSForegroundColorAttributeName : UIColor.white]
    }

  // MARK:- methods to modify navigation bar
  // method to add logo on left
  func setUpLeftImageOnNavigationBar(){
    let image = UIImage(named: "fisionNavbarLogo")
    let imageview:UIImageView = UIImageView.init(frame: kFrame_BarlogoIconSize)
    imageview.image = image
    let logoButton = UIBarButtonItem.init(customView: imageview)
   // ImageButton.tintColor = UIColor.clearColor()
    self.navigationItem.leftBarButtonItem = logoButton
  }
  
  // MARK:- methods to modify navigation bar
  // method to add logo on left
  
  func setLeftButtonWithImageName(name:String) {
    let image = UIImage(named: name)
    let logoButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(leftButtonTapped))
    self.navigationItem.leftBarButtonItem = logoButton
  }
  // method to add logo on right
  
  func setRightButtonWithImageName(name:String) {
    
    let image = UIImage(named: name)
    let logoButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(dismissMe))
    self.navigationItem.rightBarButtonItem = logoButton
  }
  
  func leftButtonTapped()  {
    
  }
  func dismissMe () {}
  
  func showAuthenticationAlert(authenticationSuccessHandler:@escaping ()->Void){
   let passwordAlert = UIAlertController(title: "PasswordAlerTitle".localized(lang: languageCode, comment: ""), message: "PasswordAlertMessage".localized(lang: languageCode, comment: ""), preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel".localized(lang: languageCode, comment: ""), style: .default) { (UIAlertAction) in
      passwordAlert.dismiss(animated: true, completion: nil)
    }
    passwordAlert.addTextField { (textField) in
      textField.isSecureTextEntry = true
    }
    passwordAlert.addAction(cancelAction)
    let okAction = UIAlertAction(title: "OK".localized(lang: languageCode, comment: ""), style: .default) { (UIAlertAction) in
      self.webServiceToVerifyPasswordAndLogin(parameters: ["username":UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject,"password":passwordAlert.textFields![0].text as AnyObject], completionHandler: {
        authenticationSuccessHandler()
      })
    }
    passwordAlert.addAction(okAction)
    self.present(passwordAlert, animated: true) {
      
    }
  }
  
  func dontShowAlertAuthentication(authenticationSuccessHandler:@escaping ()->Void)
  {
    
  }
  

  func webServiceToVerifyPasswordAndLogin(parameters:[String:AnyObject],completionHandler:@escaping ()->Void){
    
    loaderInBase = LoaderView()
    loaderInBase?.initLoader()
    self.view.addSubview(loaderInBase!)
    AlamoFireConnectivity.alamofirePostRequest(param: parameters, withUrlString: kBaseUrl+kLoginUser) { (data, error) in
      self.loaderInBase?.removeFromSuperview()
      self.loaderInBase = nil
      if data != nil{
        let status = data?["Success"].stringValue
        if(status?.lowercased() == "true"){
          let dataValue = data?["Data"].dictionary
          let createUser = dataValue!["User"]?.dictionary
          let localUserdefault = UserDefaults.standard
          localUserdefault.set(createUser?["email"]?.stringValue, forKey: kEmail)
          if(createUser?["first_name"] != nil){
          localUserdefault.set(createUser?["first_name"]?.stringValue, forKey: kFirstName)
          }else{
          localUserdefault.set(createUser?["firstname"]?.stringValue, forKey: kFirstName)
          }
          if(createUser?["last_name"] != nil){
            localUserdefault.set(createUser?["last_name"]?.stringValue, forKey: kLastName)
          }else{
            localUserdefault.set(createUser?["lastname"]?.stringValue, forKey: kLastName)
          }
          //localUserdefault.set(createUser?["last_name"]?.stringValue, forKey: kLastName)
          localUserdefault.set(createUser?["phone"]?.stringValue, forKey: kMobileNumber)
          localUserdefault.set(createUser?["username"]?.stringValue, forKey: kUserNameKey)
          localUserdefault.set(createUser?["user_id"]?.stringValue, forKey: kUserId)
          localUserdefault.set(createUser?["access_token"]?.stringValue, forKey: kAccessToken)
          localUserdefault.set(createUser?["token_type"]?.stringValue, forKey: kTokenType)
          localUserdefault.synchronize()
          //Utility.storeUserAccountStatus(fromDict: createUser!)
         // HotwireCommunicationApi.sharedInstance.createUserObject = CreateUser.init(dictionary: createUser!)
          let userDefaultForLoginTime = UserDefaults.standard
          userDefaultForLoginTime.set(Date(), forKey: "loginTime")
          userDefaultForLoginTime.synchronize()
          completionHandler()
        }
        else{
          let message = (data?["Message"].stringValue)!
          let errorcode = data?["ErrorCode"].intValue
          switch errorcode {
          case ErrorCode.AlreadyUseCredential.rawValue?:
            self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
          default:
             self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
          }
        }
      }else{
      self.methodToHandelServicePasswordVarificationStatusfailure(error: error)
      }
    }
  }
  
  func methodToHandelServicePasswordVarificationStatusfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  // method to add logo on right
  func setUpRightImageOnNavigationBar(){
    let image = UIImage(named: "powerIcon")
  //  let imageview:UIImageView = UIImageView.init(frame: kFrame_BarlogoIconSize)
    let logoButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(leftButtonTapped))
    // ImageButton.tintColor = UIColor.clearColor()
    self.navigationItem.rightBarButtonItem = logoButton
  }
  
  func setUpImageOnNavigationBarCenterTitle(){
    let image = UIImage(named: "fisionNavbarLogo")
    let imageview:UIImageView = UIImageView.init(frame: kFrame_BarlogoIconSize)
    imageview.image = image
   // let logoButton = UIBarButtonItem.init(customView: imageview)
    // ImageButton.tintColor = UIColor.clearColor()
    self.navigationItem.titleView = imageview
  }
  
  
  
  func setUpCancelButonOnRight(){
    let btn1 = UIButton(frame:KFrame_DoneBarbutton )
    btn1.setTitle("Cancel", for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(BaseViewController.cancelButtonTappedAction(_:)
      
      
      ), for: .touchUpInside)
    self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  func setUpCancelButonOnLeft()
  {
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Cancel", for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(BaseViewController.cancelButtonTappedAction(_:)
      
      
      ), for: .touchUpInside)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  
  func setUpCancelButonOnLeftWithAnimation(){
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Cancel", for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(BaseViewController.cancelButtonTappedActionWithAnimation), for: .touchUpInside)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  
  func popToRootView(){
  self.navigationController?.popToRootViewController(animated: true)
  }
  
  func onBackPresssed()
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  func setUpCancelButonOnRightWithAnimation(){
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Cancel", for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(BaseViewController.cancelButtonTappedActionWithAnimation), for: .touchUpInside)
    self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  func backButtonWithOutTitle()
  {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
    
  func addNotificationForDeviceRotation()
  {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotatedInBaseViewController), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  func deviceRotatedInBaseViewController()
  {
    if loaderInBase != nil
    {
      loaderInBase?.removeFromSuperview()
      loaderInBase = LoaderView()
      loaderInBase?.initLoader()
      if let loaderView = loaderInBase
      {
        self.view.addSubview(loaderView)
      }
    }
  }
  
  //MARK:- IBoutlet Barbutton Action
  func cancelButtonTappedAction(_ sender : AnyObject){
     let languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    let activeSheetTitle:String = "CancelTitle".localized(lang: languageCode, comment: "")
    let activeSheetBody:String = "CancelActiveSheetBody".localized(lang: languageCode, comment: "")
    
    let alert = UIAlertController(title: activeSheetTitle, message: activeSheetBody , preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "ConfirmCancel".localized(lang: languageCode, comment: "Cancel confirm"), style: .default , handler:{ (UIAlertAction)in
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
      let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_LoginPage)
      let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
      appDelegate.window?.rootViewController = nav
    }))
    alert.addAction(UIAlertAction(title: "Cancel".localized(lang: languageCode, comment: "cancel button"), style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
      print("User click Dismiss button")
    }))
    if UIDevice.current.userInterfaceIdiom == .pad{
      alert.popoverPresentationController?.sourceView = self.view
      alert.popoverPresentationController?.sourceRect = CGRect(0, self.view.bounds.size.height , self.view.bounds.size.width, 1.0) //CGRectMake
    }
    self.present(alert, animated: true, completion: {
      print("completion block")
    })
  }
  func cancelButtonTappedActionWithAnimation(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_LoginPage)
     mainViewController.transitioningDelegate = self
    let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
    appDelegate.window?.rootViewController = nav
    swipeInteractionController.wireToViewController(viewController: nav)
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
   ***********************************************************************************************************/
  func webServiceCallingTogetAccountStatus(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    loaderInBase = LoaderView()
    loaderInBase?.initLoader()
    self.view.addSubview(loaderInBase!)
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loaderInBase?.removeFromSuperview()
      self.loaderInBase = nil
      if data != nil{
        
        self.methodToHandelAcountStatusSuccess(data:data!)
      }else{
        self.methodToHandelAccountStatusfailure(error: error!)
      }
      
    }
  }
  
  
  func methodToHandelAcountStatusSuccess(data:SwiftyJSON.JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      let dataDict = data["Data"]["AccountStatus"]
      // Utility.storeUserAccountStatus(fromDict: dataDict as Dictionary<String, AnyObject>)
      let localUserdefault = UserDefaults.standard
      localUserdefault.set(dataDict["email_address"].stringValue, forKey: kEmail)
      localUserdefault.set(dataDict["email_verified"].stringValue, forKey: kEmailVerified)
      localUserdefault.set(dataDict["first_name"].stringValue, forKey: kFirstName)
      localUserdefault.set(dataDict["last_name"].stringValue, forKey: kLastName)
      localUserdefault.set(dataDict["mobile_number"].stringValue, forKey: kMobileNumber)
      localUserdefault.set(dataDict["mobile_verified"].stringValue, forKey: kMobileNumberVerified)
      localUserdefault.set(dataDict["username"].stringValue, forKey: kUserNameKey)
      localUserdefault.set(dataDict["address_line1"].stringValue, forKey: kAddress1)
      localUserdefault.set(dataDict["address_line2"].stringValue, forKey: kAddress2)
      localUserdefault.set(dataDict["iso_code"].stringValue, forKey: kiSOCode)
      localUserdefault.set(dataDict["language"].stringValue, forKey: kLanguageKey)
      localUserdefault.set(dataDict["last_login_time"].stringValue, forKey: kLastLoginTime)
      localUserdefault.set(dataDict["pp_accepted"].stringValue, forKey: kPPAccepted)
      localUserdefault.set(dataDict["profile_pic_name"].stringValue, forKey: kProfilePicName)
      localUserdefault.set(dataDict["push_notification_enabled"].stringValue, forKey: kNotificationEnable)
      localUserdefault.set(dataDict["tos_accepted"].stringValue, forKey: kTOSAccepted)
      localUserdefault.set(dataDict["msa_property"].stringValue, forKey: kCommunityName)
      //  localUserdefault.set(dataDict["userid"], forKey: "userid")
      localUserdefault.synchronize()
      LanguageManager.sharedInstance.setLanguageWithLocale(locale: Locale().initWithLanguageCode(languageCode: dataDict["iso_code"].stringValue.lowercased() as NSString, name: dataDict["language"].stringValue as NSString) as! Locale)
      var languageIndex = -1
      for locale in LanguageManager.sharedInstance.availableLocales{
        languageIndex += 1
        if(locale.languageCode == dataDict["iso_code"].stringValue.lowercased()){
          break
        }
      }
      UserDefaults.standard.set(languageIndex, forKey: "language")
      UserDefaults.standard.synchronize()
      Utility.pushDesiredViewControllerOver(viewController: self)
    }else{
      let errorcode = data["ErrorCode"].intValue
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
        self.showTheAlertViewWithLoginButton(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: data["Message"].stringValue, languageCode: languageCode)
      default:
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["Message"].stringValue, languageCode: languageCode)
      }
    }
  }
  func methodToHandelAccountStatusfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  

}
extension UIBarButtonItem
{
  class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
    let button = UIButton(type: .custom)
    button.setImage(colorfulImage, for: .normal)
    button.frame = CGRect.init(0, 0, 44.0, 44.0)
    button.addTarget(target, action: action, for: .touchUpInside)
    
    let barButtonItem = UIBarButtonItem(customView: button)
    return barButtonItem
  }
}
extension BaseViewController: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    flipPresentAnimationController.originFrame = self.view.frame
    return flipPresentAnimationController
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    flipDismissAnimationController.destinationFrame =  self.view.frame
    return flipDismissAnimationController
  }
  
  func interactionControllerForDismissal(using animator:UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
  }
}


