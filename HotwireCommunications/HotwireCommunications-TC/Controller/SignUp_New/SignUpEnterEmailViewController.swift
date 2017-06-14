//
//  SignUpEnterEmailViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 30/08/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpEnterEmailViewController: BaseViewController,UITextFieldDelegate {
   // var languageCode:String!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    var isAlreadyLogin = false
    @IBOutlet var lblPageTitle: UILabel!
    @IBOutlet var txfldEnterEmailAddress : UITextField!
    @IBOutlet var lblAboutEmailAddressInfo: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnAlreadyHaveAccount: UIButton!
    @IBOutlet var lblBottomSeperater: UILabel!
    var ContinueButton:UIBarButtonItem!
    var loader: LoaderView?

  // keyboard button
  
  var flowType:FlowType = FlowType.SignUp
  @IBOutlet var tappedGesture: UITapGestureRecognizer!
   var emailId = " jsmith@gmail.com"
  // data objects
  var userDetails:AnyObject?
  var signUpdetailsObject:SignUpDetails!
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  
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
      if(signUpdetailsObject != nil){
        btnAlreadyHaveAccount.isHidden = true
        if flowType == .SignUp
        {
          self.navigationItem.title =  "SignUp".localized(lang: languageCode, comment: "")
        }
        else
        {
          self.title = "EmailAddressTitle".localized(lang: languageCode, comment: "")
        }
        
      }
    }
  override func viewDidAppear(_ animated: Bool)
  {
    if !btnContinue.isSelected{
      txfldEnterEmailAddress.becomeFirstResponder()
    }
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
    
  override func viewDidDisappear(_ animated: Bool)
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
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
      func viewUpdateContentOnBasesOfLanguage(){
        languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
        txfldEnterEmailAddress.placeholder = "EnterEmailAddress".localized(lang: languageCode, comment: "")
         btnContinue.setTitle("Continue".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
        switch flowType {
        case .SignUpPopup:
           self.navigationItem.title =  "ChangeEmail".localized(lang: languageCode, comment: "")
             lblAboutEmailAddressInfo.text = "VerifyEmailAddressInfo".localized(lang: languageCode, comment: "")
           addBarButtonOnNavigationBar()
           tappedGesture.isEnabled = false
          btnAlreadyHaveAccount.isHidden = true
          case .SignUp:
           self.navigationItem.title =  "SignUp".localized(lang: languageCode, comment: "")
             lblAboutEmailAddressInfo.text = "EmailAddressInfoText".localized(lang: languageCode, comment: "")
           tappedGesture.isEnabled = true
           if let invitationCodeObject = userDetails as? InvitationCode {
            // success
             let userEmailaddress = invitationCodeObject.emailaddress!
              txfldEnterEmailAddress.text = String(userEmailaddress)
           } else {
            print("failre")
          }
        case .ResetPassword:
           self.navigationItem.title =  "ResetPassword".localized(lang: languageCode, comment: "")
           lblAboutEmailAddressInfo.text = "ForgotLoginInfoText".localized(lang: languageCode, comment: "")
           btnContinue.setTitle("LoginSendVerificationCode".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
           tappedGesture.isEnabled = true
           btnAlreadyHaveAccount.isHidden = true
           //lblBottomSeperater.isHidden = true
           setUpCancelButonOnRightWithAnimation()
        case .RecoverUsername:
          self.navigationItem.title =  "RecoverUsername".localized(lang: languageCode, comment: "")
          lblAboutEmailAddressInfo.text = "ForgotUserNameEmailInfoText".localized(lang: languageCode, comment: "")
          tappedGesture.isEnabled = true
          btnAlreadyHaveAccount.isHidden = true
          btnContinue.setTitle("SendUsernameBtn".localized(lang: languageCode, comment: ""), for: .normal)
          //lblBottomSeperater.isHidden = true
          setUpCancelButonOnRightWithAnimation()
        default:
          self.navigationItem.title =  "RecoverUsername".localized(lang: languageCode, comment: "")
          lblAboutEmailAddressInfo.text = "ForgotLoginInfoText".localized(lang: languageCode, comment: "")
          tappedGesture.isEnabled = true
          btnAlreadyHaveAccount.isHidden = true
          //lblBottomSeperater.isHidden = true
          setUpCancelButonOnRightWithAnimation()
        }
        lblPageTitle.text = "WhatYourEmailId".localized(lang: languageCode, comment: "")
        lblPageTitle.textColor = kColor_continueUnselected
        lblAboutEmailAddressInfo.textColor = kColor_continueUnselected
        btnAlreadyHaveAccount.setTitle("AlreadyHaveAccount".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
        btnAlreadyHaveAccount.backgroundColor = kAlreadyhaveAccount
        btnAlreadyHaveAccount.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        setUpBackButonOnLeft()
    }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
 

    func configureViewProperty(){
     
       // txfldEnterEmailAddress.becomeFirstResponder()
        txfldEnterEmailAddress.layer.cornerRadius = 4.0
        txfldEnterEmailAddress.leftViewMode = UITextFieldViewMode.always
        txfldEnterEmailAddress.layer.masksToBounds = true
        txfldEnterEmailAddress.layer.borderColor = kColor_SignUpbutton.cgColor
        txfldEnterEmailAddress.layer.borderWidth = 1.0
        txfldEnterEmailAddress.returnKeyType = .go
        txfldEnterEmailAddress.enablesReturnKeyAutomatically = true
        txfldEnterEmailAddress.autocorrectionType = UITextAutocorrectionType.no
      btnContinue.backgroundColor = kColor_ContinuteUnselected
      btnContinue.isSelected = false
      lblAboutEmailAddressInfo.isHidden = false
    //  btnContinue.isHidden = true
    }
  /***********************************************************************************************************
   <Name> setUpBackButonOnLeft </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to set the custom back button </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
 
  func setUpBackButonOnLeft(){
    self.navigationItem.setHidesBackButton(true, animated:true);
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Back".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    btn1.imageEdgeInsets = imageEdgeInsets;
    btn1.titleEdgeInsets = titleEdgeInsets;
    btn1.setImage(UIImage(named: "RedBackBtn"), for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(SignUpEnterEmailViewController.backButtonTappedAction(_:)), for: .touchUpInside)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  /***********************************************************************************************************
   <Name> backButtonTappedAction </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on custom back button to navigate to next view</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
 
  func backButtonTappedAction(_ sender : UIButton)
  {
    if self.isBeingPresented
    {
      self.dismiss(animated: true, completion: {});
    }
    else
    {
      self.navigationController!.popViewController(animated: true)
    }
    
  }

    //MARK: textField delegate method
  /***********************************************************************************************************
   <Name> textFieldShouldEndEditing, shouldChangeCharactersInRange ,textFieldDidBeginEditing, textFieldShouldClear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Textfield delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblAboutEmailAddressInfo.isHidden = false
       // btnContinue.isHidden = true
      txfldEnterEmailAddress.layer.borderColor = kColor_SignUpbutton.cgColor
      if((textField.text?.characters.count)!>0){
      if isValidEmail(testStr: textField.text!){
        //self.view.endEditing(true)
        btnContinue.backgroundColor = kColor_continueSelected
        btnContinue.isSelected = true
        //  lblAboutEmailAddressInfo.isHidden = true
        btnContinue.isHidden = false
        
      }else{
        btnContinue.backgroundColor = kColor_continueUnselected
        btnContinue.isSelected = false
        //  lblAboutEmailAddressInfo.isHidden = true
        btnContinue.isHidden = false
      }
      }else{

        btnContinue.backgroundColor = kColor_ContinuteUnselected
        btnContinue.isSelected = false
      }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      txfldEnterEmailAddress.layer.borderColor = kColor_continueUnselected.cgColor
      if isValidEmail(testStr: textField.text!){
        self.view.endEditing(true)
        btnContinue.backgroundColor = kColor_continueSelected
        btnContinue.isSelected = true
      //  lblAboutEmailAddressInfo.isHidden = true
        btnContinue.isHidden = false
        
      }else{
        btnContinue.backgroundColor = kColor_continueUnselected
        btnContinue.isSelected = false
      //  lblAboutEmailAddressInfo.isHidden = true
        btnContinue.isHidden = false
      }
        return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    if isValidEmail(testStr: newString){
      btnContinue.backgroundColor = kColor_continueSelected
      btnContinue.isSelected = true
    }else{
      btnContinue.backgroundColor = kColor_continueUnselected
      btnContinue.isSelected = false
    }
    txfldEnterEmailAddress.layer.borderColor = kColor_continueUnselected.cgColor
   
    return true
  }
  func textFieldShouldClear(_ textField: UITextField) -> Bool
  {
    btnContinue.backgroundColor = kColor_continueUnselected
    btnContinue.isSelected = false
    return true
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
       if isValidEmail(testStr: textField.text!){
            self.view.endEditing(true)
         btnContinue.backgroundColor = kColor_continueSelected
         btnContinue.isSelected = true
         self.view.endEditing(true)
        switch flowType {
        case .SignUpPopup:
          //self.dismiss(animated: true, completion: {});
          print("It is of SignUpPopUp type")
          
        case .SignUp:
          let prameter = ["email":txfldEnterEmailAddress.text! as String]
          //webServiceCallingToSendEmailOTP(prameter: prameter as [String : AnyObject], withUrlType: kSendFirstTimeLoginOTPtoEmail)
          webServiceCallingToValidateEmailID(prameter: prameter as [String : AnyObject], withUrlType: kValidate_Email_Number)
            //self.performSegueWithIdentifier(kSegue_EnterPassword, sender: self)
        case .ResetPassword:
          let recoverUserParam:[String:AnyObject] = ["email":txfldEnterEmailAddress.text as AnyObject]
          webServiceCallingToRecoverUserNameAndResetPasswordByEmail(prameter: recoverUserParam, withUrlType: kPassword_reset_by_email)
    //       webServiceCallingToSendEmailOTP(prameter: recoverUserParam, withUrlType: kSendFirstTimeLoginOTPtoEmail)
          
        case .RecoverUsername:
          let recoverUserParam:[String:AnyObject] = ["email":txfldEnterEmailAddress.text as AnyObject]
          webServiceCallingToRecoverUserNameAndResetPasswordByEmail(prameter: recoverUserParam, withUrlType: kRecoverUserNameByEmail)
        default:
          let alertTitle = "RecoverUserNameEmailNoTitle".localized(lang: languageCode, comment: "")
          var alertbody = "RecoverUserNameEmailNoBody".localized(lang: languageCode, comment: "")
          alertbody = alertbody.components(separatedBy: "?")[0] as String+txfldEnterEmailAddress.text!+alertbody.components(separatedBy: "?")[1]
          let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
            //self.performSegueWithIdentifier(kSegue_TabBarBaseView, sender: self)
             self.cancelButtonTappedActionWithAnimation()
          }))
          self.present(alert, animated: true, completion: {
            print("completion block")
          })
        }
//        if varificationMode {
//          self.view.endEditing(true)
//          self.dismissViewControllerAnimated(true, completion: {});
//          
//        }else{
//         self.performSegueWithIdentifier(kSegue_EnterPassword, sender: self)
//        }
       }else{
 //       btnContinue.backgroundColor = kColor_continueUnselected
 //       btnContinue.selected = false
        showTheAlertViewWith(title: "Invalid EmailId", withMessage: "Please enter valid email address", languageCode: languageCode)
      }
      btnContinue.isSelected = false
      btnContinue.backgroundColor = kColor_ContinuteUnselected
        return true
    }
  
    //MARK:- IB button action
  
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
      if btnContinue.isSelected
      {
        let message = (data["Message"].stringValue)
        let alertTitle = message.titleName(languageCode: self.languageCode)
        let alertbody = message.message(languageCode: self.languageCode)
        
        let alertController = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok".localized(lang: languageCode, comment: ""), style: .default, handler: { (UIAlertAction) in
          self.performSegue(withIdentifier: kSegue_ResetEmail, sender: self)
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

  /***********************************************************************************************************
   <Name> continueButtonTappedAction </Name>
   <Input Type>  AnyObject  </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on continue button</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
    @IBAction func continueButtonTappedAction(_ sender: AnyObject) {
        // EnterMobNumber
      self.view.endEditing(true)
      if isValidEmail(testStr: txfldEnterEmailAddress.text!){
        self.view.endEditing(true)
        btnContinue.backgroundColor = kColor_continueSelected
        btnContinue.isSelected = true
        self.view.endEditing(true)
        switch flowType {
        case .SignUpPopup:
          
            webServiceCallingToChangeEmailOTP(prameter: ["email":txfldEnterEmailAddress.text! as AnyObject,"username":UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject], withUrlType: kUpdateEmailByUser)
       
        case .SignUp:
          let prameter = ["email":txfldEnterEmailAddress.text! as String]
          if(isAlreadyLogin == true){
          webServiceCallingToSendEmailOTP(prameter: prameter as [String : AnyObject], withUrlType: kSendFirstTimeLoginOTPtoEmail)
          }else{
          webServiceCallingToValidateEmailID(prameter: prameter as [String : AnyObject], withUrlType: kValidate_Email_Number)
          }
        //self.performSegueWithIdentifier(kSegue_EnterPassword, sender: self)
        case .ResetPassword:
          
           let recoverUserParam:[String:AnyObject] = ["email":txfldEnterEmailAddress.text as AnyObject]
        webServiceCallingToRecoverUserNameAndResetPasswordByEmail(prameter: recoverUserParam, withUrlType: kPassword_reset_by_email)
        case .RecoverUsername:
          let recoverUserParam:[String:AnyObject] = ["email":txfldEnterEmailAddress.text as AnyObject]
          webServiceCallingToRecoverUserNameAndResetPasswordByEmail(prameter: recoverUserParam, withUrlType: kRecoverUserNameByEmail)
        default:
          let alertTitle = "RecoverUserNameEmailNoTitle".localized(lang: languageCode, comment: "")
          //let alertbody = "RecoverUserNameEmailNoBody".localized(lang: languageCode, comment: "")
          var alertbody = "RecoverUserNameEmailNoBody".localized(lang: languageCode, comment: "")
          alertbody = alertbody.components(separatedBy: "?")[0] as String+txfldEnterEmailAddress.text!+alertbody.components(separatedBy: "?")[1]
          let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
            //self.performSegueWithIdentifier(kSegue_TabBarBaseView, sender: self)
            self.cancelButtonTappedActionWithAnimation()
          }))
          self.present(alert, animated: true, completion: {
            print("completion block")
          })
        }
      }
      else{
        //       btnContinue.backgroundColor = kColor_continueUnselected
        //       btnContinue.selected = false
        if btnContinue.isSelected
        {
           showTheAlertViewWith(title: "Invalid EmailId", withMessage: "Please enter valid email address", languageCode: languageCode)
        }
       
      }

      
//      if isValidEmail(testStr: txfldEnterEmailAddress.text!){
//        let prameter = ["email":txfldEnterEmailAddress.text! as String]
//        webServiceCallingToValidateEmailID(prameter: prameter as [String : AnyObject], withUrlType: kValidate_Email_Number)
//        
//        }else{
//         showTheAlertViewWith(title: "Invalid EmailId", withMessage: "Please enter valid email address", languageCode: languageCode)
//      }
    }
  /***********************************************************************************************************
   <Name> alreadyHaveAccountButtonTapped </Name>
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on already Have Account button</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
    @IBAction func alreadyHaveAccountButtonTapped(_ sender: AnyObject) {
        cancelButtonTappedAction(sender as! UIButton)
        
    }
  
  
  func webServiceCallingToChangeEmailOTP(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePutRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelEmailByUserNameOTPSuccess(data:data!)
      }else{
        self.methodToHandelRecoverEmailByUserNameOTPfailure(error: error!)
      }
      
    }
  }
  func methodToHandelEmailByUserNameOTPSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
//      let message = (data["Message"].stringValue)
//      let alertTitle = message.titleName(languageCode: self.languageCode)
//      let alertbody = message.message(languageCode: self.languageCode)
    
      UserDefaults.standard.set(txfldEnterEmailAddress.text! as String, forKey: kEmail)
      UserDefaults.standard.synchronize()
     self.dismiss(animated: true, completion: {});
      
      
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
  func methodToHandelRecoverEmailByUserNameOTPfailure(error:NSError?){
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
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on Scroll view to end editing on view</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
  
    @IBAction func touchUpActionOnScrollview(_ sender: AnyObject){
        self.contentView.endEditing(true)
//        if txfldEnterEmailAddress.text != ""{
//            self.view.endEditing(true)
//            btnContinue.backgroundColor = kColor_continueSelected
//            btnContinue.selected = true
//        }else{
//          btnContinue.backgroundColor = kColor_continueUnselected
//          btnContinue.selected = false
//       }
    }
  /***********************************************************************************************************
   <Name> addBarButtonOnNavigationBar </Name>
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method to add a navigation bar button on view when this page is reuse to varify email address</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addBarButtonOnNavigationBar(){
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Cancel".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(SignUpEnterEmailViewController.cancelBarButtonTappedAction(_:)), for: .touchUpInside)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
    
  }
  // MARK: method help to reuse view controller
  /***********************************************************************************************************
   <Name> cancelBarButtonTappedAction </Name>
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on Cancel button tapped while view is reused from varify email address </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
  func cancelBarButtonTappedAction(_ sender : UIButton){
    self.dismiss(animated: true, completion: {});
  }
  
  // MARK: - web service
  //to validate EmailId code
  /***********************************************************************************************************
   <Name> webServiceCallingToValidateEmailID </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  28/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToValidateEmailID(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(endPointUrl)"
    //\(Format.json.rawValue)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)

   AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
    self.loader?.removeFromSuperview()
    self.loader = nil
          if data != nil{
            self.methodToHandelValidateEmailIDSuccess(data: data!)
          }else{
            self.methodToHandelValidateEmailIDfailure(error: error!)
          }
    }

  }
  func methodToHandelValidateEmailIDSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true")
    {
       signUpdetailsObject.emailAddress = txfldEnterEmailAddress.text
      
       self.performSegue(withIdentifier: kSegue_UpdatePassword, sender: self)
    }else{
      let errorcode = data["ErrorCode"].intValue
      let message = (data["Message"].stringValue)
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
       self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
        break;
      case ErrorCode.InvalidUseCredential.rawValue:
       
        self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
        break;
      default:
        self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
      }

    }
  }
  func methodToHandelValidateEmailIDfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  //MARK: Recover User & reset password from email web services
  /***********************************************************************************************************
   <Name> webServiceCallingToRecoverUserNameByMobileNumber </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  18/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToRecoverUserNameAndResetPasswordByEmail(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = "\(kBaseUrl)\(UrlEndPoints.Login.rawValue)\(endPointUrl)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)

    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        switch self.flowType {
        case .ResetPassword:
           self.methodToHandelResetPasswordByEmailSuccess(data: data!)
        case .RecoverUsername:
           self.methodToHandelRecoverUserNameByEmailSuccess(data: data!)
        default:
          print("Non of them")
        }
      }else{
        self.methodToHandelRecoverUserNameAndResetPasswordEmailfailure(error: error!)
      }
      
    }
  }
  func methodToHandelRecoverUserNameByEmailSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true")
    {
     
      let alertTitle = "RecoverUserNameEmailNoTitle".localized(lang: languageCode, comment: "")
     // let alertbody = "RecoverUserNameEmailNoBody".localized(lang: languageCode, comment: "")
      var alertbody = "RecoverUserNameEmailNoBody".localized(lang: languageCode, comment: "")
      alertbody = alertbody.components(separatedBy: "?")[0] as String+txfldEnterEmailAddress.text!+alertbody.components(separatedBy: "?")[1]
      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        //self.performSegueWithIdentifier(kSegue_TabBarBaseView, sender: self)
        self.cancelButtonTappedActionWithAnimation()
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
  func methodToHandelResetPasswordByEmailSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("success")
      let alertTitle = "EmailSentTitle".localized(lang: languageCode, comment: "")
      let alertbody = "EmailSentBody".localized(lang: languageCode, comment: "")
      //let alert = UIAlertController(title: alertTitle, message: "\(alertbody) \(emailId)", preferredStyle: .alert)
      
      
      let alert = UIAlertController(title: alertTitle, message: "\(alertbody) \(txfldEnterEmailAddress.text!)", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        self.performSegue(withIdentifier: kSegue_ResetEmail, sender: self)
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
  func methodToHandelRecoverUserNameAndResetPasswordEmailfailure(error:NSError?){
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
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.title = "Back"
      
      if segue.identifier == kSegue_UpdatePassword,
        let destinationViewController = segue.destination as? ResetPasswordViewController {
        destinationViewController.signUpdetailsObject = signUpdetailsObject
      }
      if segue.identifier == kSegue_ResetEmail,
        let destinationViewController = segue.destination as? FLResetEmailViewController {
        destinationViewController.mailId =  txfldEnterEmailAddress.text
        destinationViewController.flowType = flowType
        destinationViewController.verifiCationType = otpVerificationType.email
        destinationViewController.isAlreadyLoggin = isAlreadyLogin
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
   <Date>  30/08/16 </Date>
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
  
}
