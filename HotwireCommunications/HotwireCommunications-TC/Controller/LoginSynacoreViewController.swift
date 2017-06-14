//
//  LoginSynacoreViewController.swift
//  HotwireCommunications-TC
//
//  Created by Chetu-macmini-26 on 30/08/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SynacorCloudId
import SwiftyJSON

final class LoginSynacoreViewController: BaseViewController,UIWebViewDelegate{
    
     let defaultUserDetail = UserDefaults.standard
    // var languageCode:String!
  
  @IBOutlet var btnRememberMe: UIButton!
  @IBOutlet var loginInfoLable: UILabel!
  @IBOutlet var userNameTextField: UITextField!
  
  @IBOutlet var ForgotUserName: UIButton!
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var viewBaseView: UIView!
   var cloudIdObject:CloudId? {
    didSet {
      guard let cloudId = self.cloudIdObject else {
        return
      }
    //  self.cloudIdWasSet(cloudId: cloudId)
    }
  }
  var loggedInUser: User?
  private var loggedInProvider: Provider?
  private var hotwireProvider:Provider?
  private var loginWebView:LoginViewController!
  // MARK: values to verify user mailId and phone number
  var userVarification:Bool = false
  var logout:Bool = false
  // MARK:
  @IBOutlet weak var btnSignUp: UIButton!
  @IBOutlet weak var btnForgotLogin: UIButton!
  //MARK:- controller lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(true)
      self.navigationController?.navigationBar.isHidden = true
      self.addNotificationObserver()
       viewUpdate()
  }
  override func viewDidAppear(_ animated: Bool)
  {
    super.viewDidAppear(animated)
    self.refreshState()
    if self.cloudIdObject != nil {
      return
    }
    CloudId.newInstanceWithConfigAtUrl(Bundle.main.url(forResource: "cloudid-config-hotwirecommunications", withExtension: "json")!) {
      [weak self]
      (cloudId, error) in
      self?.cloudIdObject = cloudId
    }
    self.addNotificationForDeviceRotation()
  }
  
//MARK:- Refresh view
  func viewUpdate(){
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
   let localizedExtension = "Language".localized(lang: languageCode, comment: "")
    loginInfoLable.text = ""//"LoginInfo".localized(lang: languageCode, comment: "")
    loginInfoLable.textColor = kColor_continueUnselected
    userNameTextField.placeholder = "UserNamePlaceHolder".localized(lang: languageCode, comment: "")
    passwordTextField.placeholder = "PasswordPlaceHolder".localized(lang: languageCode, comment: "")
//    ForgotUserName.setTitle("ForgotLogoutButton".localized(lang: languageCode, comment: ""), for: .normal)
    ForgotUserName.setTitle("Forgot_Username".localized(lang: languageCode, comment: ""), for: .normal)
    loginButton.backgroundColor = kColor_continueSelected
    loginButton.setTitle("LogIn".localized(lang: languageCode, comment: ""), for: .normal)
    btnRememberMe.setTitle("RememberMe".localized(lang: self.languageCode, comment: ""), for: .normal)
   // self.title =  "SignUp".localized(lang: languageCode, comment: "")
    
    print(localizedExtension)
  }

//MARK:- ADD notification
  func addNotificationObserver(){
    NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(application:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    
  }
  //notification method to update UI
  func applicationWillEnterForeground(application: UIApplication) {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    print("applicationWillEnterForeground")
    //viewUpdate()
  }
  
  @IBAction func onTakeTourTapped(_ sender: Any) {
    let storyboard = UIStoryboard(name: kStoryBoardMain, bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_FirsScreen) 
    self.navigationController?.pushViewController(mainViewController, animated: true)

  }
  
  @IBAction func onLoginButtonTapped(_ sender: Any)
  {
    
    // corpus
    
    let mainStoryboard = "Main"
    _ = UIApplication.shared.delegate! as! AppDelegate
    AppDelegate.loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard: mainStoryboard, withStoryboardIdentifier: "TabBarController", onSelectedIndex: 0)
    
    
    
//    self.view.endEditing(true)
//    if((userNameTextField.text?.characters.count)!>0 && (passwordTextField.text?.characters.count)!>0){
//      webServiceToVerifyPasswordAndLogin(parameters: ["username":userNameTextField.text as AnyObject,"password":passwordTextField.text as AnyObject]) { 
//  self.webServiceCallingTogetAccountStatus(prameter: ["username" : UserDefaults.standard.value(forKey: kUserNameKey) as AnyObject], withUrlType: kCheckFirstTimeLoginStatus)
//    let userDefaultForLoginTime = UserDefaults.standard
//    userDefaultForLoginTime.set(Date(), forKey: "loginTime")
//    userDefaultForLoginTime.synchronize()
//      }
//    }
//    else if(userNameTextField.text?.characters.count == 0){
//     showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: "UsernameEmptyMessage".localized(lang: languageCode, comment: ""), languageCode: languageCode)
//      UserDefaults.standard.removeObject(forKey: "loginTime")
//    }else{
//    showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: "PasswordEmptyMessage".localized(lang: languageCode, comment: ""), languageCode: languageCode)
//      UserDefaults.standard.removeObject(forKey: "loginTime")
//    }
    
  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  // MARK:- iBoutlet methods
  @IBAction func signUpButtonTappedAction(_ sender: Any) {
    let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_SignUpTermCondition)
    self.navigationController?.pushViewController(mainViewController, animated: true)
    
  }
  
  @IBAction func forgotLoginButtonTappedAction(_ sender: Any) {
    self.performSegue(withIdentifier: kSegue_ForgotLogin, sender: self)
  }
  
// MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    // HotwireCommunicationApi.sharedInstance.cloudId = self.cloudIdObject
  }
  
  // MARK: Synacore method
  /*
  private func cloudIdWasSet(cloudId: CloudId) {
    cloudId.delegate = self
    cloudId.checkKeychainWithCallback {
      (user, provider, error) in
      if self.logout{
       self.loggedInUser = nil
     }else{
        self.loggedInUser = user
      }
      self.refreshState()
    }
    if (cloudId.config.identityProvider != nil)
    {
      guard let loginController = self.cloudIdObject!.loginControllerForConfiguredIdentityProvider() else {
        return
      }
      loginController.delegate = self
      self.addChildViewController(loginController)
      DispatchQueue.main.async {
     // self.viewWebLogin.addSubview(loginController.view)
      loginController.didMove(toParentViewController: self)
      loginController.view.frame = self.view.bounds
      }
    }
  }
  */
  private func refreshState() {
    if  self.loggedInUser != nil {
      if userVarification{
      let mainStoryboard = "Main"
      loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard: mainStoryboard, withStoryboardIdentifier: "TabBarController", onSelectedIndex: 0)
      return
      }else{
        self.webServiceCallingTogetAccountStatus(prameter: ["username" : UserDefaults.standard.value(forKey: "user_name") as AnyObject], withUrlType: kCheckFirstTimeLoginStatus)
        
        //self.performSegue(withIdentifier: kSegue_UserVarificationtermAndConditon, sender: self)
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
    let loaderView = LoaderView()
    loaderView.initLoader()
    self.view.addSubview(loaderView)
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      loaderView.removeFromSuperview()
      if data != nil{
        
        self.methodToHandelAcountStatusSuccess(data:data!)
      }else{
        self.methodToHandelAccountStatusfailure(error: error!)
      }
      
    }
  }

  
  override func methodToHandelAcountStatusSuccess(data:SwiftyJSON.JSON) {
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
    //  localUserdefault.set(dataDict["userid"], forKey: "userid")
      localUserdefault.synchronize()
       LanguageManager.sharedInstance.setLanguageWithLocale(locale: Locale().initWithLanguageCode(languageCode: dataDict["iso_code"].stringValue.lowercased() as NSString, name: dataDict["language"].stringValue as NSString) as! Locale)
      var languageIndex = -1
      for locale in LanguageManager.sharedInstance.availableLocales{
        languageIndex += 1
        if(locale.languageCode == dataDict["iso_code"].stringValue){
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
*/
  
  func  loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard:String, withStoryboardIdentifier identifier:String, onSelectedIndex index:Int){
    let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! TabBarViewController
    initialViewController.selectedIndex = index
    appDelegate.window?.rootViewController = initialViewController
    appDelegate.window?.makeKeyAndVisible()
  }
}

extension LoginSynacoreViewController: CloudIdDelegate {
  
  func cloudId(_ cloudId: CloudId, didLogInUser user: User, forProvider provider: Provider) {
    print("cloudId: \(cloudId), didLoginUser: \(user), forProvider: \(provider)")
    logout = false
    loggedInUser = user
    //refreshState()
  }
  
  private func cloudId(cloudId: CloudId, keychainShouldSaveUser user: User, forProvider provider: Provider) -> Bool {
    return true
  }
  
  private func cloudId(cloudId: CloudId, didEncounterError error: NSError) {
    print("error! :\(error)")
  }
}
extension LoginSynacoreViewController: UserDetailsViewControllerDelegate {
  
  func userDetailsViewControllerDidRequestLogout(viewController: AccountViewController) {
    self.loggedInUser = nil
    self.cloudIdObject = HotwireCommunicationApi.sharedInstance.cloudId
    self.cloudIdObject?.clearKeychain()
     logout = true
    if let bundle = Bundle.main.bundleIdentifier {
      UserDefaults.standard.removePersistentDomain(forName: bundle)
    }
    //  self.dismissViewControllerAnimated(true, completion: nil)
    //add this block if you want to go back to the login view after the user logs out
//    guard let loginController = self.cloudId!.loginControllerForConfiguredIdentityProvider() else {
//      return
//    }
//    loginController.delegate = self
//    self.presentViewController(loginController, animated: true) {
//    }
  }
}
extension LoginSynacoreViewController: LoginViewControllerDelegate {
  
  func loginViewControllerDidCompleteLogin(_ viewController: LoginViewController) {
//    self.dismissViewControllerAnimated(true, completion: nil)
     viewDidAppear(true)
    }
  
  func loginViewControllerDidPressCancelButton(_ viewController: LoginViewController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  private func loginViewController(viewController: LoginViewController, didEncounterError error: NSError) {
    print(error)
  }
  private func loginViewController(viewController: LoginViewController, webViewProgressDidChange progressPercentage: Float) {
    // var objec = viewController
    
  }
}

final class ProviderTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "ProviderTableViewCell"
  
  @IBOutlet weak var providerImageView: UIImageView!
  @IBOutlet weak var providerTitleLabel: UILabel!
  @IBOutlet weak var providerTokenLabel: UILabel!
  
}
extension LoginViewController:UIWebViewDelegate{
   public func webViewDidStartLoad(_ webView: UIWebView) {
    print("Start loading")
  }
}
extension LoginViewController : UITextFieldDelegate
{
  public func textFieldDidBeginEditing(_ textField: UITextField)
  {
    textField.becomeFirstResponder()
  }
}

