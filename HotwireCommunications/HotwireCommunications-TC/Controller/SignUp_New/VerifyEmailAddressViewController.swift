//
//  VerifyEmailAddressViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 13/10/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SwiftyJSON

class VerifyEmailAddressViewController: BaseViewController,UITextFieldDelegate {
 // var languageCode:String!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var contentView: UIView!
  
  @IBOutlet var checkCodeBtn: UIButton!
  @IBOutlet var lblPageTitle: UILabel!
  @IBOutlet var txfldEnterVarificationCode : UITextField!
  @IBOutlet var lblAboutVarificationInfo: UILabel!
  @IBOutlet weak var btnSendEmailAgain: UIButton!
  @IBOutlet weak var btnChangeEmailAddress: UIButton!
  // Toolbar variable declaration
  var toolBar:UIToolbar!
  var submitButton:UIButton!
  var mainStoryboard = "Main"
  // login signUp flag
  var login:Bool!
  // data object
  var createUserObject :CreateUser?
  var loader: LoaderView?
  public var isAlreadyLogin:Bool!
  @IBOutlet var tappedGusture: UITapGestureRecognizer!
  //MARK:- controller lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewProperty()
    
    for viewController in (self.navigationController?.viewControllers)!{
      if(viewController.isKind(of: ContactInfoViewController.self)){
        webServiceCallingToChangeEmailOTP(prameter: ["email":UserDefaults.standard.object(forKey: kEmail) as AnyObject,"username":UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject], withUrlType: kUpdateEmailByUser)
        return
      }
    }
    let recoverUserParam:[String:AnyObject] = ["email":UserDefaults.standard.object(forKey: kEmail) as AnyObject]
    webServiceCallingToSendEmailOTP(prameter: recoverUserParam, withUrlType: kSendFirstTimeLoginOTPtoEmail)
   
  }
  
  //MARK:- DeviceOrientation changed method
  
  func deviceRotated()
  {
    if loader != nil
    {
      loader?.removeFromSuperview()
      loader = LoaderView()
      loader?.initLoader()
      if let loaderView = loader
      {
        self.view.addSubview(loaderView)
      }
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = false
    viewUpdateContentOnBasesOfLanguage()
    addNotificationObserver()
    if(UserDefaults.standard.object(forKey: kEmailVerified) != nil){
      let backItem = UIBarButtonItem()
      backItem.title = "Cancel".localized(lang: languageCode, comment: "")
      navigationItem.backBarButtonItem = backItem
      //self.navigationItem.setHidesBackButton(false, animated: true)
    }
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  
  /***********************************************************************************************************
   <Name> webServiceCallingTogetAccountStatus </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToChangeEmailOTP(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePutRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelEmailOTPSuccess(data:data!)
      }else{
        self.methodToHandelRecoverEmailOTPfailure(error: error!)
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
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToSendEmailOTP(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelEmailOTPSuccess(data:data!)
      }else{
        self.methodToHandelRecoverEmailOTPfailure(error: error!)
      }
      
    }
  }
  
  func methodToHandelEmailOTPSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)
      showTheAlertViewWith(title: alertTitle, withMessage: (alertbody.utf8Data?.attributedString?.string)!, languageCode: languageCode)
      
    }
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
  func methodToHandelRecoverEmailOTPfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }

  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  //MARK:- Refresh view
  func viewUpdateContentOnBasesOfLanguage()
  {
    var isFromContactInfo = false
    for viewController in (self.navigationController?.viewControllers)!
    {
      if(viewController.isKind(of: ContactInfoViewController.self))
      {
        isFromContactInfo = true
        break
      }
    }
    
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    self.navigationItem.title =  "Verification".localized(lang: languageCode, comment: "")
    
    lblPageTitle.text = "VerifyYourEmailAddressTitle".localized(lang: languageCode, comment: "")
    checkCodeBtn.setTitle("CheckCode".localized(lang: languageCode, comment: ""), for: .normal)
    
    checkCodeBtn.backgroundColor = kColor_continueUnselected
    txfldEnterVarificationCode.placeholder = "EnterVerificationCode".localized(lang: languageCode, comment: "")
    
    lblAboutVarificationInfo.text = "EnterVerificationCodeMailInfo".localized(lang: languageCode, comment: "") + (UserDefaults.standard.object(forKey: kEmail) as! String)
    /*if updatedEmail == ""
    {
      lblAboutVarificationInfo.text = "EnterVerificationCodeMailInfo".localized(lang: languageCode, comment: "") + (UserDefaults.standard.object(forKey: kEmail) as! String)
    }
    else
    {
      lblAboutVarificationInfo.text = "EnterVerificationCodeMailInfo".localized(lang: languageCode, comment: "") + updatedEmail
    }*/
    
    toolBar = addDoneButton(selector: #selector(VerifyEmailAddressViewController.submitButtonAction(_:)
      ))
    txfldEnterVarificationCode.inputAccessoryView = toolBar
    if(isAlreadyLogin == true)
    {
      self.navigationItem.title =  "EmailAddressTitle".localized(lang: languageCode, comment: "")
      checkCodeBtn.titleLabel?.textColor = .gray
      lblPageTitle.text = "VerifyYourEmailAddressAfterLoginTitle".localized(lang: languageCode, comment: "")
    }
    if isFromContactInfo == true
    {
       btnSendEmailAgain.setTitle("Resend_Code".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
       btnChangeEmailAddress.isHidden = true
       addBarButtonOnNavigationBar()
    }
    else
    {
      btnSendEmailAgain.setTitle("SendEmailAgain".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
      btnChangeEmailAddress.setTitle("ChangeEmailAddress".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
      btnChangeEmailAddress.isHidden = false
    }
  }
  func configureViewProperty(){
    self.navigationItem.setHidesBackButton(true, animated:true);
    txfldEnterVarificationCode.layer.cornerRadius = 4.0
    txfldEnterVarificationCode.leftViewMode = UITextFieldViewMode.always
    txfldEnterVarificationCode.layer.masksToBounds = true
    txfldEnterVarificationCode.layer.borderColor = kColor_SignUpbutton.cgColor
    txfldEnterVarificationCode.layer.borderWidth = 1.0
    txfldEnterVarificationCode.returnKeyType = .next
    txfldEnterVarificationCode.enablesReturnKeyAutomatically = true
    txfldEnterVarificationCode.autocorrectionType = UITextAutocorrectionType.no
  //  changeDoneButtonColorWhenKeyboardShows(self)
    checkCodeBtn.backgroundColor = kColor_continueUnselected
    checkCodeBtn.layer.borderColor = kColor_continueUnselected.cgColor
    checkCodeBtn.titleLabel?.textColor = .gray
    checkCodeBtn.layer.cornerRadius = 4.0
    btnSendEmailAgain.layer.borderColor = kColor_continueSelected.cgColor
    btnSendEmailAgain.setTitleColor(kColor_continueSelected, for: UIControlState.normal)
    btnChangeEmailAddress.layer.borderColor = kColor_continueSelected.cgColor
    btnChangeEmailAddress.setTitleColor(kColor_continueSelected, for: UIControlState.normal)
    
  }
  func addBarButtonOnNavigationBar()
  {
    let btnCancel = UIBarButtonItem(title: "Cancel".localized(lang: languageCode, comment: ""), style: .plain, target: self, action:#selector(VerifyEmailAddressViewController.cancelBarButtonTappedAction(_:)) )
    self.navigationItem.rightBarButtonItem = btnCancel;
    
  }
  func cancelBarButtonTappedAction(_ sender : UIButton)
  {
    if(self.isBeingPresented){
      self.dismiss(animated: true, completion: {});
    }else{
      _ = self.navigationController?.popViewController(animated: true)
    }
  }
  /***********************************************************************************************************
   <Name> addDoneButton </Name>
   <Input Type>  Selector  </Input Type>
   <Return> UIToolbar </Return>
   <Purpose> method to set the toolbar on keyboard </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  13/10/16. </Date>
   </History>
   ***********************************************************************************************************/
  func addDoneButton(selector:Selector) -> UIToolbar {
    let toolbar = UIToolbar()
    let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    submitButton = UIButton()
    submitButton.frame = KFrame_Submit
    submitButton.setTitle("SubmitBtnTitle".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    submitButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    submitButton.setTitleColor(UIColor.white, for: UIControlState.selected)
    submitButton.addTarget(self, action: selector, for: .touchUpInside)
    submitButton.titleLabel!.font = kFontStyleSemiBold20
    
    let toolbarButton = UIBarButtonItem()
    toolbarButton.customView = submitButton
    toolbar.setItems([flexButton, toolbarButton], animated: true)
    toolbar.barTintColor = kColor_ToolBarUnselected
    toolbar.sizeToFit()
    return toolbar
  }

  //MARK: textField delegate method
   func textFieldDidBeginEditing(_ textField: UITextField) {
    
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else {
      return true
    }
    let newLength = text.utf16.count + string.utf16.count - range.length
    if newLength < 6{
      checkCodeBtn.backgroundColor = kColor_continueUnselected
      checkCodeBtn.isSelected = false
      checkCodeBtn.titleLabel?.textColor = .gray
    }else{
      checkCodeBtn.backgroundColor = kColor_continueSelected
      checkCodeBtn.isSelected = true
      checkCodeBtn.titleLabel?.textColor = .white
    }
    return newLength <= 6
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == txfldEnterVarificationCode{
      if txfldEnterVarificationCode.text != ""{
        self.view.endEditing(true)
      }
    }
    return true
  }
  func textFieldShouldClear(_ textField: UITextField) -> Bool
  {
    checkCodeBtn.backgroundColor = kColor_continueUnselected
    checkCodeBtn.isSelected = false
    checkCodeBtn.titleLabel?.textColor = .gray
    return true
  }

  //MARK:- IB button action
  @IBAction func sendEmailAgainButtonTappedAction(_ sender: AnyObject) {
    let recoverUserParam:[String:AnyObject] = ["email":UserDefaults.standard.object(forKey: kEmail) as AnyObject]
    
    webServiceCallingToSendEmailOTP(prameter: recoverUserParam, withUrlType: kSendFirstTimeLoginOTPtoEmail)
   
    
  }
  @IBAction func changeEmailAddressButtonTappedAction(_ sender: AnyObject) {
    
    let popUpView = self.storyboard?.instantiateViewController(withIdentifier: kStoryBoardID_EmailVarification) as! SignUpEnterEmailViewController
    popUpView.flowType = FlowType.SignUpPopup
    let navController = UINavigationController.init(rootViewController: popUpView)
    self.navigationController?.present(navController, animated: true, completion: nil)
    
  }
 
  @IBAction func touchUpActionOnScrollview(_ sender: AnyObject)
  {
    self.contentView.endEditing(true)
    if txfldEnterVarificationCode.text != ""{
      self.view.endEditing(true)
    }
  }
  @IBAction func submitButtonAction(_ sender: AnyObject) {
      self.view.endEditing(true)
    if checkCodeBtn.isSelected{
     if HotwireCommunicationApi.sharedInstance.createUserObject != nil{
    webServiceCallingToAuthenticateVarificationCode(otpCode: txfldEnterVarificationCode.text!, verifyEmailwith: self.createUserObject!.email! )
     }else{
      webServiceCallingToVerifyEmailOTP(prameter: ["email":UserDefaults.standard.object(forKey: kEmail) as AnyObject,"otp":txfldEnterVarificationCode.text as AnyObject], withUrlType: kVerifyFirstTimeLoginOTPtoEmail)
     /* let alertTitle = "CodeConfirmedTitle".localized(lang: languageCode, comment: "")
      let alertbody = "CodeConfirmedEmailBody".localized(lang: languageCode, comment: "")
      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
         let mainStoryboard = "Main"
         self.loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard: mainStoryboard, withStoryboardIdentifier: kStoryBoardID_PushNotification, onSelectedIndex: 0) //"TabBarController"
       // self.performSegue(withIdentifier: kSegue_TabBarBaseView, sender: self)
      }))
      self.present(alert, animated: true, completion: {
        print("completion block")
      })*/
    }
      // self.performSegueWithIdentifier(kSegue_EnterEmailId, sender: self)
    }
  }
  
  func  loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard:String, withStoryboardIdentifier identifier:String, onSelectedIndex index:Int){
    UserDefaults.standard.set(true, forKey: "isEmailVerified")
    UserDefaults.standard.synchronize()
    Utility.pushDesiredViewControllerOver(viewController: self)
   /* let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! ActivatePushNotificationViewController//TabBarViewController
    initialViewController.login = isAlreadyLogin
    appDelegate.window?.rootViewController = initialViewController
    appDelegate.window?.makeKeyAndVisible()*/
  }
  // MARK: - web service
  
  /***********************************************************************************************************
   <Name> webServiceCallingTogetAccountStatus </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToVerifyEmailOTP(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelEmailOTPVerificationSuccess(data:data!)
      }else{
        self.methodToHandelRecoverEmailOTPVerificationfailure(error: error!)
      }
      
    }
  }
  
  func methodToHandelEmailOTPVerificationSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      for viewController in (self.navigationController?.viewControllers)!{
        if(viewController.isKind(of: ContactInfoViewController.self)){
         _ = self.navigationController?.popToViewController(viewController, animated: true)
          return
        }
      }
     
      UserDefaults.standard.set("1", forKey: kEmailVerified)
      UserDefaults.standard.synchronize()
      Utility.pushDesiredViewControllerOver(viewController: self)
      
     //  self.loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard: mainStoryboard, withStoryboardIdentifier: kStoryBoardID_PushNotification, onSelectedIndex: 0)
      
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
  func methodToHandelRecoverEmailOTPVerificationfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }

  //to send varification code on phone number
  /***********************************************************************************************************
   <Name> webServiceCallingToSendVarificationCode </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  06/12/16 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToSendVarificationCode(email:String){
    let finalUrlToHit = "\(kBaseUrl)\(kVerify_Phone_Number)\(email)"
    //\(Format.json.rawValue)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        self.methodToHandelSendVarificationCodeSuccess(data: data!)
      }else{
        self.methodToHandelSendVarificationCodefailure(error: error!)
      }
    }
  }
  func methodToHandelSendVarificationCodeSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      let message = data["Message"].string
      self.showTheAlertViewWith(title: (message?.titleName(languageCode: self.languageCode))!, withMessage:(message?.message(languageCode: self.languageCode))!, languageCode: languageCode)
    }else{
      let message = data["Message"].string
      self.showTheAlertViewWith(title: (message?.titleName(languageCode: self.languageCode))!, withMessage:(message?.message(languageCode: self.languageCode))!, languageCode: languageCode)
    }
  }
  func methodToHandelSendVarificationCodefailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  //to send Authanticate otp
  /***********************************************************************************************************
   <Name> webServiceCallingToAuthenticateVarificationCode </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  06/12/16 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToAuthenticateVarificationCode(otpCode:String, verifyEmailwith email:String){
    let finalUrlToHit = "\(kBaseUrl)\(kVerify_Email_Otp)\(email)/code/\(otpCode)"
    //\(Format.json.rawValue)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        self.methodToHandelAuthenticateVarificationCodeSuccess(data: data!)
      }else{
        self.methodToHandelAuthenticateVarificationCodefailure(error: error!)
      }
    }
  }
  func methodToHandelAuthenticateVarificationCodeSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
//      let alertTitle = "CodeConfirmedTitle".localized(lang: languageCode, comment: "")
//      let alertbody = "CodeConfirmedEmailBody".localized(lang: languageCode, comment: "")
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)

      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        UserDefaults.standard.set(true, forKey: "isEmailVerified")
        UserDefaults.standard.synchronize()
        Utility.pushDesiredViewControllerOver(viewController: self)
       // self.performSegue(withIdentifier: kSegue_TabBarBaseView, sender: self)
      }))
      self.present(alert, animated: true, completion: {
        print("completion block")
      })
    }else{
      let message = data["Message"].string
      self.showTheAlertViewWith(title: (message?.titleName(languageCode: self.languageCode))!, withMessage:(message?.message(languageCode: self.languageCode))!, languageCode: languageCode)

    }
  }
  func methodToHandelAuthenticateVarificationCodefailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
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
   <Date>  13/10/16 </Date>
   </History>
   ***********************************************************************************************************/
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.title = "Back"
    if segue.identifier == kSegue_TabBarBaseView,
      let destinationViewController = segue.destination as? TabBarBaseViewController {
      destinationViewController.transitioningDelegate = self
      swipeInteractionController.wireToViewController(viewController: destinationViewController)
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
   <Date>   13/10/16 </Date>
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
}
