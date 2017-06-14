//
//  VerifyPhoneNoViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 13/10/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SwiftyJSON

class VerifyPhoneNoViewController:BaseViewController,UITextFieldDelegate {
  //var languageCode:String!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var contentView: UIView!
  @IBOutlet var checkCodeBtn: UIButton!
  var isCallOptionSelected = false
  @IBOutlet var lblPageTitle: UILabel!
  @IBOutlet var txfldEnterVarificationCode : UITextField!
  @IBOutlet var lblAboutVarificationInfo: UILabel!
  @IBOutlet weak var btnSendCodeAgain: UIButton!
  @IBOutlet weak var btnChangeMobileNumber: UIButton!
  @IBOutlet weak var btnCallMeInstead: UIButton!
  var viewTitleKey:String!
  // Toolbar variable declaration
  var toolBar:UIToolbar!
  var submitButton:UIButton!
  var loader: LoaderView?
  // login signUp flag
   var login:Bool!
  // data object 
  var createUserObject :CreateUser?
  public var isAlreadyLogin:Bool!
  public var phoneNum:String!
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 13/10/16. </Date>
   </History>
   ***********************************************************************************************************/
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewProperty()
    btnCallMeInstead.isUserInteractionEnabled = false
    for viewController in (navigationController?.viewControllers)!{
      if(viewController.isKind(of:ContactInfoViewController.self)){
        webServiceCallingToChangeAndSendOTPToMobile(prameter: ["mobile":UserDefaults.standard.object(forKey: kMobileNumber) as AnyObject,"language":languageCode.uppercased() as AnyObject,"username":UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject])
       return
      }
    }
    self.webServiceCallingToSendOTPToMobile(prameter: ["mobile":UserDefaults.standard.object(forKey: kMobileNumber) as AnyObject,"language":languageCode.uppercased() as AnyObject], withUrlType: kSendFirstTimeLoginOTPtoMobile)
   
  }
  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
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
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
 
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK:- Refresh view
  /***********************************************************************************************************
   <Name> viewUpdateContentOnBasesOfLanguage </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to update content on the bases of language</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  13/10/16. </Date>
   </History>
   ***********************************************************************************************************/
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
    //btnChangeMobileNumber.isUserInteractionEnabled = false
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    if isFromContactInfo == true
    {
      self.navigationItem.title  = "MobileNumberTitle".localized(lang: languageCode, comment: "")
      lblPageTitle.text = "EnterVerificationCode".localized(lang: languageCode, comment: "")
      btnCallMeInstead.isHidden = true
      checkCodeBtn.setTitle("CheckCode".localized(lang: languageCode, comment: ""), for: .normal)
      btnSendCodeAgain.setTitle("Resend_Code".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
      btnChangeMobileNumber.setTitle("CallmeInsteadBtnTitle".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
      let aboutVarificationInfo = "\("EnterVerificationCodeInfo".localized(lang: languageCode, comment: "")) \((UserDefaults.standard.object(forKey: kMobileNumber) as! String)) "
      lblAboutVarificationInfo.text = aboutVarificationInfo
      addBarButtonOnNavigationBar()

    }
    else
    {
      self.navigationItem.title =  "Verification".localized(lang: languageCode, comment: "")
      
      lblPageTitle.text = "VerifyYourPhoneNumberTitle".localized(lang: languageCode, comment: "")
      
      btnSendCodeAgain.setTitle("SendCodeAgainBtnTitle".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
      btnChangeMobileNumber.setTitle("ChangeMobileNumberBtnTitle".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
      btnCallMeInstead.setTitle("CallmeInsteadBtnTitle".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
      txfldEnterVarificationCode.placeholder = "EnterVerificationCode".localized(lang: languageCode, comment: "")
      if !login{
        let aboutVarificationInfo = "\("EnterVerificationCodeInfo".localized(lang: languageCode, comment: "")) \((UserDefaults.standard.object(forKey: kMobileNumber) as! String)) "
        lblAboutVarificationInfo.text = aboutVarificationInfo
      }else{
        lblAboutVarificationInfo.text = "\("MobileVerificationCodeSignup".localized(lang: languageCode, comment: ""))"
      }
      if(isAlreadyLogin == true){
        self.navigationItem.title  = "MobileNumberTitle".localized(lang: languageCode, comment: "")
        checkCodeBtn.setTitle("CheckCode".localized(lang: languageCode, comment: ""), for: .normal)
        if(UserDefaults.standard.object(forKey: kMobileNumberVerified) ==  nil){
          addBarSkipButtonOnNavigationBar()
        }
      }
      toolBar = addDoneButton( selector: #selector(VerifyPhoneNoViewController.submitButtonAction(_:)))
      txfldEnterVarificationCode.inputAccessoryView = toolBar
    }
    
  
 
  }
  
  func changeUIForCallButton(){
    if(isCallOptionSelected == true){
    lblAboutVarificationInfo.text = "\("EnterVerificationCodeForCallPreInfo".localized(lang: languageCode, comment: "")) \(UserDefaults.standard.object(forKey: kMobileNumber)) "+"EnterVerificationCodeForCallPostInfo".localized(lang: languageCode, comment: "")
    }else{
    lblAboutVarificationInfo.text = "\("EnterVerificationCodeInfo".localized(lang: languageCode, comment: "")) \(UserDefaults.standard.object(forKey: kMobileNumber)) "
    }
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
   <Name> addBarButtonOnNavigationBar </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to add cancel bar button on navigation bar</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addBarSkipButtonOnNavigationBar(){
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Skip".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    btn1.titleLabel?.font = kFontStyleSemiBold18
    btn1.addTarget(self, action: #selector(SignUpEnterMobNoViewController.skipBarButtonTappedAction(_:)), for: .touchUpInside)
    self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn1), animated: true)
  }
  
  /***********************************************************************************************************
   <Name> skipBarButtonTappedAction </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on cancel button action </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func skipBarButtonTappedAction(_ sender : UIButton){
       self.performSegue(withIdentifier: kSegue_SetUpEmail, sender: self)
  }

  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 13/10/16.</Date>
   </History>
   ***********************************************************************************************************/
  func configureViewProperty(){
   self.navigationItem.setHidesBackButton(true, animated:true);
    txfldEnterVarificationCode.layer.cornerRadius = 4.0
    txfldEnterVarificationCode.leftViewMode = UITextFieldViewMode.always
    txfldEnterVarificationCode.layer.masksToBounds = true
    txfldEnterVarificationCode.layer.borderColor = kColor_SignUpbutton.cgColor
    txfldEnterVarificationCode.layer.borderWidth = 1.0
    txfldEnterVarificationCode.returnKeyType = .next
    txfldEnterVarificationCode.enablesReturnKeyAutomatically = true
    checkCodeBtn.layer.cornerRadius = 4.0
    btnSendCodeAgain.layer.borderColor = kColor_continueSelected.cgColor
    btnSendCodeAgain.setTitleColor(kColor_continueSelected, for: UIControlState.normal)
    btnChangeMobileNumber.layer.borderColor = kColor_continueSelected.cgColor
    btnCallMeInstead.layer.borderColor = kColor_continueSelected.cgColor
    btnChangeMobileNumber.setTitleColor(kColor_continueSelected, for: UIControlState.normal)
    btnCallMeInstead.setTitleColor(kColor_continueSelected, for: UIControlState.normal)
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
    submitButton.frame = KFrame_Toolbar
    submitButton.setTitle("Done".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    submitButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    submitButton.setTitleColor(UIColor.white, for: UIControlState.selected)
    submitButton.addTarget(self, action: selector, for: .touchUpInside)
    submitButton.titleLabel!.font = kFontStyleSemiBold20
    
    let toolbarButton = UIBarButtonItem()
    toolbarButton.customView = submitButton
    toolbar.setItems([flexButton, toolbarButton], animated: true)
    toolbar.barTintColor = kColor_ToolBarUnselected
    toolbar.backgroundColor = kColor_NavigationBarColor
    toolbar.sizeToFit()
    return toolbar
  }
  //(VerifyPhoneNoViewController.submitButtonAction(_:)))
   //MARK: textField delegate method
  /***********************************************************************************************************
   <Name> textFieldShouldEndEditing, textFieldShouldClear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Textfield delegate methods to handel texfield status action</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  13/10/16. </Date>
   </History>
   ***********************************************************************************************************/
  

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    print("textFieldShouldEndEditing")
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else {
      return true
    }
    let newLength = text.utf16.count + string.utf16.count - range.length
    if newLength < 6{
      //btnSendCodeAgain.setTitle("CallmeAgainBtnTitle".localized(lang: languageCode, comment: ""), for: .normal)
      //btnCallMeInstead.setTitle("TextmeInsteadBtnTitle".localized(lang: languageCode, comment: ""), for: .normal)
//      toolBar.barTintColor = kColor_ToolBarUnselected
//      submitButton.isSelected = false
      checkCodeBtn.backgroundColor = kColor_continueUnselected
      checkCodeBtn.titleLabel?.textColor = UIColor.gray
      checkCodeBtn.isSelected = false
    
    }else{
       //btnSendCodeAgain.setTitle("SendCodeAgainBtnTitle".localized(lang: languageCode, comment: ""), for: .normal)
      //btnCallMeInstead.setTitle("CallmeInsteadBtnTitle".localized(lang: languageCode, comment: ""), for: .normal)
      //toolBar.barTintColor = kColor_continueSelected
      checkCodeBtn.backgroundColor = kColor_continueSelected
      checkCodeBtn.titleLabel?.textColor = .white
      checkCodeBtn.isSelected = true
    }
    return newLength <= 6
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    toolBar.barTintColor = kColor_ToolBarUnselected
    checkCodeBtn.backgroundColor = kColor_continueUnselected
    checkCodeBtn.titleLabel?.textColor = UIColor.gray
    checkCodeBtn.isSelected = false
    return true
  }
  //MARK:- IB button action
  /***********************************************************************************************************
   <Name> continueButtonTappedAction </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on continue button</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  13/10/16. </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func callMeInsteadButtonTappedAction(_ sender: AnyObject) {
    isCallOptionSelected = !isCallOptionSelected
    
    changeUIForCallButton()
//    let popUpView = self.storyboard?.instantiateViewController(withIdentifier: kStoryBoardID_ConfirmPhoneNumber) as! ConfirmPhoneNumberViewController
//    let navController = UINavigationController.init(rootViewController: popUpView)
//    self.navigationController?.present(navController, animated: true, completion: nil)
    
  }
  @IBAction func changeMobileNumberButtonTappedAction(_ sender: AnyObject)
  {
    let popUpView = self.storyboard?.instantiateViewController(withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
   // popUpView.varificationMode = true
    popUpView.flowType = FlowType.SignUpPopup
    let navController = UINavigationController.init(rootViewController: popUpView)
    self.navigationController?.present(navController, animated: true, completion: nil)
    /*let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
    let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
   
    mainViewController.flowType = FlowType.SignUpPopu
       self.navigationController?.pushViewController(mainViewController, animated: true)*/
   //_ = self.navigationController?.popViewController(animated: true)
  }
  @IBAction func sendCodeAgainButtonTappedAction(_ sender: AnyObject)
  {
      self.webServiceCallingToSendOTPToMobile(prameter: ["mobile": UserDefaults.standard.object(forKey: kMobileNumber) as AnyObject,"language":self.languageCode.uppercased() as AnyObject], withUrlType: kSendFirstTimeLoginOTPtoMobile)
  }
  
  /***********************************************************************************************************
   <Name> webServiceCallingToSendOTPToMobile </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToChangeAndSendOTPToMobile(prameter:[String :AnyObject]){
    let finalUrlToHit = kBaseUrl + kUpdateMobileByUser
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)

    AlamoFireConnectivity.alamofirePutRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelOTPToMobileSuccess(data:data!)
      }else{
        self.methodToHandelOTPToMobileStatusfailure(error: error!)
      }
      
    }
  }

  
  /***********************************************************************************************************
   <Name> webServiceCallingToSendOTPToMobile </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToSendOTPToMobile(prameter:[String :AnyObject],withUrlType endPointUrl:String){
    let finalUrlToHit = kBaseUrl + endPointUrl
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)

    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelOTPToMobileSuccess(data:data!)
      }else{
        self.methodToHandelOTPToMobileStatusfailure(error: error!)
      }
      
    }
  }
  
  func methodToHandelOTPToMobileSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      let message = (data["Message"].stringValue)

      self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage:message.message(languageCode: self.languageCode), languageCode: languageCode)
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
  func methodToHandelOTPToMobileStatusfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }


  /***********************************************************************************************************
   <Name> touchUpActionOnScrollview </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on Scroll view to handle end editing</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  13/10/16. </Date>
   </History>
   ***********************************************************************************************************/

  @IBAction func touchUpActionOnScrollview(_ sender: AnyObject){
    self.contentView.endEditing(true)
    if txfldEnterVarificationCode.text != ""{
      self.view.endEditing(true)
    }
  }
  /***********************************************************************************************************
   <Name> submitButtonAction </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on submit button on tool bar tapped action</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 13/10/16. </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func submitButtonAction(_ sender: AnyObject) {
    self.view.endEditing(true)
    if(checkCodeBtn.isSelected){
     if HotwireCommunicationApi.sharedInstance.createUserObject != nil{
     self.webServiceCallingToAuthenticateVarificationCode( otpCode: self.txfldEnterVarificationCode.text!, verifyPhoneNumberwith:String(self.createUserObject!.phone!) )
     }else{
      webServiceCallingToVerifyOTPToMobile(prameter: ["otp" :self.txfldEnterVarificationCode.text as AnyObject,"mobile":UserDefaults.standard.object(forKey: kMobileNumber) as AnyObject], withUrlType: kVerifyFirstTimeLoginOTPtoMobile)
    }
    }
   // self.performSegueWithIdentifier(kSegue_EnterEmailId, sender: self)
  }
  // MARK: - web service
  
  /***********************************************************************************************************
   <Name> webServiceCallingToVerifyOTPToMobile </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToVerifyOTPToMobile(prameter:[String :AnyObject],withUrlType endPointUrl:String){
    let finalUrlToHit = kBaseUrl + endPointUrl
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)

    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelOTPTVerificationMobileSuccess(data:data!)
      }else{
        self.methodToHandelOTPVerificationMobileStatusfailure(error: error!)
      }
      
    }
  }
  
  func methodToHandelOTPTVerificationMobileSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
//      let alertTitle = "CodeConfirmedTitle".localized(lang: languageCode, comment: "")
//      let alertbody = "CodeConfirmedMobileNumberBody".localized(lang: languageCode, comment: "")
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)
      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        if self.login as Bool{
          for viewController in (self.navigationController?.viewControllers)!{
            if(viewController.isKind(of:ContactInfoViewController.self)){
              self.navigationController?.popToViewController(viewController, animated: true)
              return
            }
          }
          UserDefaults.standard.set(self.phoneNum, forKey: "mobile_number")
          UserDefaults.standard.set("1", forKey: "mobile_verified")
          UserDefaults.standard.synchronize()
          Utility.pushDesiredViewControllerOver(viewController: self)
          // self.performSegue(withIdentifier: kSegue_SetUpEmail, sender: self)
        }else{
          
          self.performSegue(withIdentifier: kSegue_VarificationEmailAddress, sender: self)
        }
      }))
      self.present(alert, animated: true, completion: {
        print("completion block")
      })
      
      
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
  func methodToHandelOTPVerificationMobileStatusfailure(error:NSError?){
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
  func webServiceCallingToSendVarificationCode(urlType:String){
    let finalUrlToHit = "\(kBaseUrl)\(kVerify_Phone_Number)\(urlType)"
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
    }
    else{
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
   func webServiceCallingToAuthenticateVarificationCode(otpCode:String, verifyPhoneNumberwith phoneNumber:String){
    let finalUrlToHit = "\(kBaseUrl)\(kVerify_Phone_Otp)\(phoneNumber)/code/\(otpCode)"
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
//      let alertbody = "CodeConfirmedMobileNumberBody".localized(lang: languageCode, comment: "")
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)
      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        if self.login as Bool{
          self.performSegue(withIdentifier: kSegue_SetUpEmail, sender: self)
        }else{
          UserDefaults.standard.set(true, forKey: "isMobileNumberVerified")
          UserDefaults.standard.synchronize()
          Utility.pushDesiredViewControllerOver(viewController: self)
          //self.performSegue(withIdentifier: kSegue_VarificationEmailAddress, sender: self)
        }
      }))
      self.present(alert, animated: true, completion: {
        print("completion block")
      })
    }
    else{
       let message = (data["Message"].stringValue)
      self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage:message.message(languageCode: self.languageCode), languageCode: languageCode)
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
   <Date>  13/10/16. </Date>
   </History>
   ***********************************************************************************************************/

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.title = "Back"
    if segue.identifier == kSegue_VarificationEmailAddress{
      if let nextViewController = segue.destination as? VerifyEmailAddressViewController {
        nextViewController.login = login
      
      }
    }else if segue.identifier == kSegue_SetUpEmail{
      if let nextViewController = segue.destination as? LoginEmailVerificationViewController {
        nextViewController.login = login
        nextViewController.isAlreadyLogin = isAlreadyLogin
      }}
  }
  //MARK:- ADD notification
  /***********************************************************************************************************
   <Name> addNotificationObserver </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication come to foreground and update selected languge </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 13/10/16. </Date>
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
