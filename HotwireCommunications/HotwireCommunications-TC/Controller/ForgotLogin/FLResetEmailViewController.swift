//
//  FLResetEmailViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 11/11/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SwiftyJSON

class FLResetEmailViewController:  BaseViewController,UITextFieldDelegate {
  
  
  let checkCodeBtnBackgroundColor = UIColor(colorLiteralRed: 234.0/255.0, green: 63.0/255.0, blue: 91.0/255.0, alpha: 1.0)
  
  var varificationString = ""
  
 // var languageCode:String!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var contentView: UIView!
  
  @IBOutlet var lblPageTitle: UILabel!
  
  
  @IBOutlet var CallMeButton: UIButton!
  @IBOutlet weak var firstVerificationCharactertxtfild: UITextField!
  
  @IBOutlet weak var secondVerificatioinCharacterTxtFld: UITextField!
  
  @IBOutlet weak var thirdVerificationCharacterTxtFld: UITextField!
  
  @IBOutlet weak var fourthVerificationCharacterTxtFld: UITextField!
  
  @IBOutlet weak var fifthVerificatinCharacterTxtFld: UITextField!
  
  @IBOutlet weak var sixVerificationCharacterTxtFld: UITextField!
  
  @IBOutlet weak var checkCodeBtn: UIButton!
  
  var txfldEnterVarificationCode : UITextField!
  @IBOutlet var lblAboutVarificationInfo: UILabel!
  @IBOutlet weak var btnSendEmailAgain: UIButton!
  // Toolbar variable declaration
  var toolBar:UIToolbar!
  var submitButton:UIButton!
  var mainStoryboard = "Main"
  // Data values comming from previous Controller
  var verifiCationType:otpVerificationType!
  var mailId:String!
  var phoneNumber:String!
  var shouldCheckVarificationCodeNow = false
  var flowType:FlowType!
  var isAlreadyLoggin = false
  var loader: LoaderView?
  // animation
  
  
  
  @IBOutlet var tappedGusture: UITapGestureRecognizer!
  //MARK:- controller lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewProperty()
   
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
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //MARK:- Refresh view
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    self.navigationItem.title =  "ResetPassword".localized(lang: languageCode, comment: "")
    
    lblPageTitle.text = "EnterVerificationCode".localized(lang: languageCode, comment: "")
    
    btnSendEmailAgain.setTitle("ResendCode".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    
    CallMeButton.setTitle("CallMeButtonTitle".localized(lang: languageCode, comment: ""), for: .normal);
    if(verifiCationType == otpVerificationType.email)
    {
    lblAboutVarificationInfo.text = "PhoneEmailOTPInstruction".localized(lang: languageCode, comment: "") + mailId
    }
    else{
    lblAboutVarificationInfo.text = "PhoneEmailOTPInstruction".localized(lang: languageCode, comment: "") + phoneNumber
    }
  //  toolBar = addDoneButton(selector: #selector(FLResetEmailViewController.submitButtonAction(_:)))
    //txfldEnterVarificationCode.inputAccessoryView = toolBar
    setUpBackButonOnLeft()
    if(isAlreadyLoggin != true){
    setUpCancelButonOnRightWithAnimation()
    }
  }
  func configureViewProperty(){
    self.navigationItem.setHidesBackButton(true, animated:true);
    /*
     
     <Name> configureViewProperty </Name>
     <Input Type>    </Input Type>
     <Return> void </Return>
     <Purpose> commented as underline view i.e. txfldEnterVarificationCode is not of use.  </Purpose>
     <History>
     <Header> Version 2.0 </Header>
     <Date>  28/02/17. </Date>
     <Author> Nirbhay Singh </Author>
     </History>
     
     
     txfldEnterVarificationCode.layer.cornerRadius = 4.0
     txfldEnterVarificationCode.leftViewMode = UITextFieldViewMode.always
     txfldEnterVarificationCode.layer.masksToBounds = true
     txfldEnterVarificationCode.layer.borderColor = kColor_SignUpbutton.cgColor
     txfldEnterVarificationCode.layer.borderWidth = 1.0
     txfldEnterVarificationCode.returnKeyType = .next
     txfldEnterVarificationCode.enablesReturnKeyAutomatically = true
     txfldEnterVarificationCode.autocorrectionType = UITextAutocorrectionType.no
     */
    //  changeDoneButtonColorWhenKeyboardShows(self)
    if(verifiCationType == otpVerificationType.mobileNumber){
    CallMeButton.isHidden = false
    }
    checkCodeBtn.backgroundColor = UIColor.gray
    firstVerificationCharactertxtfild.becomeFirstResponder()
    btnSendEmailAgain.layer.borderColor = kColor_continueSelected.cgColor
    btnSendEmailAgain.setTitleColor(kColor_continueSelected, for: UIControlState.normal)
    CallMeButton.layer.borderColor = kColor_continueSelected.cgColor
    CallMeButton.setTitleColor(kColor_continueSelected, for: UIControlState.normal)
  }
  /***********************************************************************************************************
   <Name> setUpBackButonOnRight </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to set the custom back button </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  11/11/16. </Date>
   </History>
   ***********************************************************************************************************/
  
  func setUpBackButonOnLeft(){
    self.navigationItem.setHidesBackButton(true, animated:true);
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Back".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    btn1.imageEdgeInsets = imageEdgeInsets;
    btn1.titleEdgeInsets = titleEdgeInsets;
    btn1.setImage(UIImage(named: "RedBackBtn"), for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(FLPhoneNoVerifyViewController.backButtonTappedAction(_:)), for: .touchUpInside)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  /***********************************************************************************************************
   <Name> addDoneButton </Name>
   <Input Type>  Selector  </Input Type>
   <Return> UIToolbar </Return>
   <Purpose> method to set the toolbar on keyboard </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  11/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addDoneButton(selector:Selector) -> UIToolbar {
    let toolbar = UIToolbar()
    let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    submitButton = UIButton()
    submitButton.frame = KFrame_Toolbar
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
  
  /***********************************************************************************************************
   <Name> textFieldDidBeginEditing </Name>
   <Input Type>  UITextField  </Input Type>
   <Return>  </Return>
   <Purpose> To append input string in the text field into the variable </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  28/02/17 </Date>
   <Author> Nirbhay Singh </Author>
   </History>
   ***********************************************************************************************************/
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    varificationString = textField.text!
    if varificationString != ""
    {
      if textField == firstVerificationCharactertxtfild{
        firstVerificationCharactertxtfild.text = varificationString
      }
        
      else if textField == secondVerificatioinCharacterTxtFld{
        secondVerificatioinCharacterTxtFld.text = varificationString
      }
        
      else if textField == thirdVerificationCharacterTxtFld{
        thirdVerificationCharacterTxtFld.text = varificationString
      }
        
      else if textField == fourthVerificationCharacterTxtFld{
        fourthVerificationCharacterTxtFld.text = varificationString
      }
        
      else if textField == fifthVerificatinCharacterTxtFld{
        fifthVerificatinCharacterTxtFld.text = varificationString
      }
        
      else if textField == sixVerificationCharacterTxtFld{
        sixVerificationCharacterTxtFld.text = varificationString
      }
    }
    
    
  }
  
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if firstVerificationCharactertxtfild.text != "" {
      shouldCheckVarificationCodeNow = true
    }else{
      shouldCheckVarificationCodeNow = false
    }
    if secondVerificatioinCharacterTxtFld.text != "" {
      shouldCheckVarificationCodeNow = true
    }else{
      shouldCheckVarificationCodeNow = false
    }
    if thirdVerificationCharacterTxtFld.text != "" {
      shouldCheckVarificationCodeNow = true
    }else{
      shouldCheckVarificationCodeNow = false
    }
    
    if fourthVerificationCharacterTxtFld.text != "" {
      shouldCheckVarificationCodeNow = true
    }else{
      shouldCheckVarificationCodeNow = false
    }
    
    if fifthVerificatinCharacterTxtFld.text != "" {
      shouldCheckVarificationCodeNow = true
    }else{
      shouldCheckVarificationCodeNow = false
    }
    
    if shouldCheckVarificationCodeNow == true {
      checkCodeBtn.backgroundColor = checkCodeBtnBackgroundColor
      checkCodeBtn.isSelected = true
    }
    else{
      checkCodeBtn.backgroundColor = UIColor.gray
      checkCodeBtn.isSelected = false
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    textField.resignFirstResponder()
    
    let  isPressedBackspaceAfterSingleSpaceSymbol = (string.characters.count == 0 && range.length == 1)
    if(isPressedBackspaceAfterSingleSpaceSymbol == true){
      if textField == sixVerificationCharacterTxtFld{
        sixVerificationCharacterTxtFld.text = string
        fifthVerificatinCharacterTxtFld.becomeFirstResponder()
      }
      
      if textField == fifthVerificatinCharacterTxtFld{
        fifthVerificatinCharacterTxtFld.text = string
        fourthVerificationCharacterTxtFld.becomeFirstResponder()
      }
      
      if textField == fourthVerificationCharacterTxtFld{
        fourthVerificationCharacterTxtFld.text = string
        thirdVerificationCharacterTxtFld.becomeFirstResponder()
      }
      
      if textField == thirdVerificationCharacterTxtFld{
        thirdVerificationCharacterTxtFld.text = string
        secondVerificatioinCharacterTxtFld.becomeFirstResponder()
      }
      
      if textField == secondVerificatioinCharacterTxtFld{
        secondVerificatioinCharacterTxtFld.text = string
        firstVerificationCharactertxtfild.becomeFirstResponder()
      }
      
      if textField == firstVerificationCharactertxtfild{
        firstVerificationCharactertxtfild.text = string
        firstVerificationCharactertxtfild.resignFirstResponder()
      }

    }else{
    if textField == firstVerificationCharactertxtfild{
      firstVerificationCharactertxtfild.text = string
      secondVerificatioinCharacterTxtFld.becomeFirstResponder()
    }
    
    if textField == secondVerificatioinCharacterTxtFld{
      secondVerificatioinCharacterTxtFld.text = string
      thirdVerificationCharacterTxtFld.becomeFirstResponder()
    }
    
    if textField == thirdVerificationCharacterTxtFld{
      thirdVerificationCharacterTxtFld.text = string
      fourthVerificationCharacterTxtFld.becomeFirstResponder()
    }
    
    if textField == fourthVerificationCharacterTxtFld{
      fourthVerificationCharacterTxtFld.text = string
      fifthVerificatinCharacterTxtFld.becomeFirstResponder()
    }
    
    if textField == fifthVerificatinCharacterTxtFld{
      fifthVerificatinCharacterTxtFld.text = string
      sixVerificationCharacterTxtFld.becomeFirstResponder()
    }
    
    if textField == sixVerificationCharacterTxtFld{
      sixVerificationCharacterTxtFld.text = string
      
    }
    }
    
    return false
    
  }
  //   guard textField.text != nil else {
  //  //    return true
  // }
  
  //    if textField == firstVerificationCharactertxtfild || textField == secondVerificatioinCharacterTxtFld || textField == thirdVerificationCharacterTxtFld || textField == fourthVerificationCharacterTxtFld || textField == fifthVerificatinCharacterTxtFld || textField == sixVerificationCharacterTxtFld{
  //
  //
  //    }
  //
  //    let newLength = text.utf16.count + string.utf16.count - range.length
  //    if newLength < 6{
  //      toolBar.barTintColor = kColor_ToolBarUnselected
  //      submitButton.isSelected = false
  //
  //    }else{
  //      toolBar.barTintColor = kColor_continueSelected
  //      submitButton.isSelected = true
  //    }
  //    return newLength <= 6
  
  // return textField.text?.characters.count == 0
  //}
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //    if textField == txfldEnterVarificationCode{
    //      if txfldEnterVarificationCode.text != ""{
    //        self.view.endEditing(true)
    //        if submitButton.isSelected {
    //          let dictionary :[String:AnyObject] = ["otp":txfldEnterVarificationCode.text as AnyObject,"email":mailId as AnyObject]
    //          webServiceCallingToSubmitOtp(prameter: dictionary, withUrlType:kVerify_email_by_otp )
    //        }
    //      }
    //    }
    return true
  }
  
  //MARK:- IB button action
  @IBAction func sendEmailAgainButtonTappedAction(_ sender: AnyObject) {
    if(verifiCationType == otpVerificationType.email){
      let recoverUserParam:[String:AnyObject] = ["email":mailId as AnyObject]
      webServiceCallingToSendEmailOTP(prameter: recoverUserParam, withUrlType: kSendFirstTimeLoginOTPtoEmail)
    }else{
      let text = phoneNumber?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
     
      webServiceCallingToSendOTPToMobile(prameter: ["mobile":text! as String as AnyObject,"language":languageCode.uppercased() as AnyObject], withUrlType: kSendFirstTimeLoginOTPtoMobile)
    }
    
  }
  @IBAction func changeEmailAddressButtonTappedAction(_ sender: AnyObject) {
    
    let popUpView = self.storyboard?.instantiateViewController(withIdentifier: kStoryBoardID_EmailVarification) as! SignUpEnterEmailViewController
    popUpView.flowType = FlowType.SignUpPopup
    let navController = UINavigationController.init(rootViewController: popUpView)
    self.navigationController?.present(navController, animated: true, completion: nil)
    
  }
  
 
  
  /***********************************************************************************************************
   <Name> backButtonTappedAction </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on custom back  button tapped </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  11/11/16. </Date>
   </History>
   ***********************************************************************************************************/
  func backButtonTappedAction(_ sender : UIButton){
    self.navigationController!.popViewController(animated: true)
  }
  
  @IBAction func touchUpActionOnScrollview(_ sender: AnyObject){
    self.contentView.endEditing(true)
    if txfldEnterVarificationCode.text != ""{
      self.view.endEditing(true)
    }
  }
  @IBAction func submitButtonAction(_ sender: AnyObject) {
    //    self.performSegue(withIdentifier: kSegue_EnterPassword, sender: self)
    if checkCodeBtn.isSelected {
  var otpString = firstVerificationCharactertxtfild.text! + secondVerificatioinCharacterTxtFld.text! + thirdVerificationCharacterTxtFld.text!
      otpString = otpString + fourthVerificationCharacterTxtFld.text! + fifthVerificatinCharacterTxtFld.text! + sixVerificationCharacterTxtFld.text!
      if(verifiCationType == otpVerificationType.email){
     webServiceCallingToSubmitOtp(prameter: ["otp":otpString as AnyObject,"email":mailId as AnyObject], withUrlType: kVerify_email_by_otp)
      }else{
      phoneNumber = "1-"+phoneNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
       webServiceCallingToSubmitOtp(prameter: ["otp":otpString as AnyObject,"mobile":phoneNumber as AnyObject], withUrlType: kVerify_phone_by_otp)
      }
    }
  }
  func doneButtontappedAction(_ sender: AnyObject) {
    print("done button tapped action")
  }
  func  loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard:String, withStoryboardIdentifier identifier:String, onSelectedIndex index:Int){
    let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! TabBarViewController
    initialViewController.selectedIndex = index
    appDelegate.window?.rootViewController = initialViewController
    appDelegate.window?.makeKeyAndVisible()
  }
  
  
  //MARK: web service to send Otp with email Id
  /***********************************************************************************************************
   <Name> webServiceCallingToSubmitOtp </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service to send otp with phone number </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  18/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToSubmitOtp(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(UrlEndPoints.Login.rawValue)\(endPointUrl)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        if(endPointUrl == kVerify_email_by_otp){
        UserDefaults.standard.set(self.mailId, forKey: kEmail)
        }else{
        UserDefaults.standard.set(self.phoneNumber, forKey: kMobileNumber)
        }
        UserDefaults.standard.synchronize()
        self.methodToHandelSubmitOtpSuccess(data: data!)
        
      }else{
        self.methodToHandelSubmitOtpfailure(error: error!)
      }
      
    }
  }
  func methodToHandelSubmitOtpSuccess(data:JSON) {
    //print(data)
    
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      if(isAlreadyLoggin == true)
      {
       // UserDefaults.standard.set("1", forKey: "email_address")
        UserDefaults.standard.set("1", forKey: kEmailVerified)
        UserDefaults.standard.synchronize()
      Utility.pushDesiredViewControllerOver(viewController: self)
      }else{
        UserDefaults.standard.set("1", forKey: kIsForgot)
        UserDefaults.standard.synchronize()
      self.performSegue(withIdentifier: kSegue_UpdatePassword, sender: self)
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
  func methodToHandelSubmitOtpfailure(error:NSError?){
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
   <Date>  11/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //self.title = "Back"
    if segue.identifier == kSegue_TabBarBaseView,
      let destinationViewController = segue.destination as? TabBarBaseViewController {
      destinationViewController.transitioningDelegate = self
      swipeInteractionController.wireToViewController(viewController: destinationViewController)
    }
    if segue.identifier == kSegue_UpdatePassword{
      if let nextViewController = segue.destination as? SignUpPasswordViewController {
        nextViewController.flowType = FlowType.ResetPassword
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
   <Date>   11/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addNotificationObserver(){
    NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(application:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
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
  
  @IBAction func onCallMeButtonClieck(_ sender: Any) {
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
    if(status.lowercased() == "true")
    {
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)
      
      let alertController = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "Ok".localized(lang: languageCode, comment: ""), style: .default, handler: { (UIAlertAction) in
        
      })
      
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
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
        
        self.methodToHandelEmailOTPSendSuccess(data:data!)
      }else{
        self.methodToHandelRecoverEmailOTPfailure(error: error!)
      }
      
    }
  }
  
  func methodToHandelEmailOTPSendSuccess(data:JSON) {
    //print(data)
   
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
     
      
        
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)
      let alertController = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok".localized(lang: languageCode, comment: ""), style: .default, handler: { (UIAlertAction) in
         
        })
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
      
      
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

  func methodToHandelEmailOTPSuccess(data:JSON) {
    //print(data)
    self.performSegue(withIdentifier: kSegue_UpdatePassword, sender: self)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      if submitButton.isSelected{
        
        let message = (data["Message"].stringValue)
        let alertTitle = message.titleName(languageCode: self.languageCode)
        let alertbody = message.message(languageCode: self.languageCode)
        
        let alertController = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok".localized(lang: languageCode, comment: ""), style: .default, handler: { (UIAlertAction) in
      self.performSegue(withIdentifier: kSegue_UpdatePassword, sender: self)
        })
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
      }
      
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

}
