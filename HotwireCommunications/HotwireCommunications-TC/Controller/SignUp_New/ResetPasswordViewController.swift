//
//  ResetPasswordViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 01/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResetPasswordViewController: BaseViewController,UITextFieldDelegate
{
//var languageCode:String!
  
  @IBOutlet var lblLoginAgain: UILabel!
  @IBOutlet var imgViewPswrdType: UIImageView!
  @IBOutlet var lblPswrdType: UILabel!
  @IBOutlet var titleLable: UILabel!
  
  @IBOutlet var passwordTextField: UITextField!
  
  @IBOutlet var helpAndStrengthButton: UIButton!
  @IBOutlet var passwordDetailLable: UILabel!
  
  @IBOutlet var weakPasswordView: UIView!
  
  @IBOutlet var justOkPassword: UIView!
  
  @IBOutlet var resetNewPasswordBtn: UIButton!
  @IBOutlet var greatPasswordView: UIView!
  @IBOutlet var goodpasswordView: UIView!
  var isAfterLogin : Bool = false
  var passwordIsOk : Bool = false
  var loader: LoaderView?
  
  var signUpdetailsObject:SignUpDetails!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        passwordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
        viewUpdateContentOnBasesOfLanguage()
      
        imgViewPswrdType.image = imgViewPswrdType.image!.withRenderingMode(.alwaysTemplate)
        imgViewPswrdType.tintColor = UIColor.blue
  }
  override func viewWillAppear(_ animated: Bool)
  {
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
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

  override func viewDidDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
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
    let btnCancel = UIBarButtonItem(title: "Cancel".localized(lang: languageCode, comment: ""), style: .plain, target: self, action:#selector(ResetPasswordViewController.cancelBarButtonTappedAction(_:)) )
    self.navigationItem.leftBarButtonItem = btnCancel;
    
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
    if(self.isBeingPresented){
    self.dismiss(animated: true, completion: {});
    }else{
      _ = self.navigationController?.popViewController(animated: true)
    }
  }
  /***********************************************************************************************************
   <Name> viewUpdateContentOnBasesOfLanguage </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to update content on the bases of language</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  05/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  func viewUpdateContentOnBasesOfLanguage()
  {
    if isAfterLogin == true
    {
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
     
      titleLable.text = "EnterNewPassword".localized(lang: languageCode, comment: "")
    
      
      self.title =  "Password".localized(lang: languageCode, comment: "")
      titleLable.textColor = kColor_continueUnselected
      lblLoginAgain.text = "Password_LoginAgain".localized(lang: languageCode, comment: "")
      passwordDetailLable.text = "EnterPasswordCharecter".localized(lang: languageCode, comment: "")
      helpAndStrengthButton.setTitle("", for: .normal)
      resetNewPasswordBtn.setTitle("languageSaveButtonTitle".localized(lang: languageCode, comment: ""), for: .normal)
      addBarButtonOnNavigationBar()
    }
    else
    {
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      let localUserdefault = UserDefaults.standard
      if((localUserdefault.object(forKey: kIsForgot)) != nil)
      {
        titleLable.text = "EnterNewPassword".localized(lang: languageCode, comment: "")
      }
      else
      {
        titleLable.text = "CreatePassword".localized(lang: languageCode, comment: "")
      }
      
      self.title =  "NewPasswordTitle".localized(lang: languageCode, comment: "")
      titleLable.textColor = kColor_continueUnselected
      lblLoginAgain.text = ""
      passwordDetailLable.text = "EnterPasswordCharecter".localized(lang: languageCode, comment: "")
      helpAndStrengthButton.setTitle("", for: .normal)
      resetNewPasswordBtn.setTitle("SaveNewPasswordBtn".localized(lang: languageCode, comment: ""), for: .normal)
      
    }
    
   
  
  }
  
   
  //MARK: textField delegate method
  /***********************************************************************************************************
   <Name> textFieldShouldEndEditing, shouldChangeCharactersInRange ,textFieldDidBeginEditing,textFieldShouldEndEditing </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Textfield delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  2/09/16 </Date>
   </History>
   ***********************************************************************************************************/
  func textFieldDidBeginEditing(_ textField: UITextField) {
    passwordTextField.layer.cornerRadius = 1
    passwordTextField.layer.borderColor = kColor_SignUpbutton.cgColor
   
//    resetNewPasswordBtn.backgroundColor = kColor_ContinuteUnselected
//    resetNewPasswordBtn.isSelected = false
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    // lblAboutPasswordInfo.isHidden = true
    passwordTextField.layer.borderColor = kColor_continueUnselected.cgColor
    
    
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (textField.text?.characters.count)! <= 63
    {
      weakPasswordView.backgroundColor = kColor_continueUnselected
      justOkPassword.backgroundColor = kColor_continueUnselected
      goodpasswordView.backgroundColor = kColor_continueUnselected
      greatPasswordView.backgroundColor = kColor_continueUnselected
      helpAndStrengthButton.titleLabel?.textAlignment = .right
    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
      let isUpperCased = (newString.range(of:"(.*[A-Z])", options: .regularExpression) != nil)
    let isLoweredcase = newString.range(of:"(.*[a-z])", options: .regularExpression) != nil
      let isNumeric = (newString.range(of:"(.*[0-9])", options: .regularExpression) != nil)
    let isSpecialCharecters = (newString.range(of:"(.*[!@#$&*])", options: .regularExpression) != nil)
    resetNewPasswordBtn.backgroundColor = kColor_continueUnselected
    resetNewPasswordBtn.isSelected = false
      if (newString.characters.count == 0)
      {
        weakPasswordView.backgroundColor = kColor_continueUnselected
        justOkPassword.backgroundColor = kColor_continueUnselected
        goodpasswordView.backgroundColor = kColor_continueUnselected
        greatPasswordView.backgroundColor = kColor_continueUnselected
        resetNewPasswordBtn.backgroundColor = kColor_continueUnselected
        lblPswrdType.text = ""
        lblPswrdType.textColor = kColor_continueUnselected
        imgViewPswrdType.tintColor = UIColor.blue
        resetNewPasswordBtn.backgroundColor = kColor_continueUnselected
        resetNewPasswordBtn.isSelected = false
        passwordIsOk = false
      }
      else if(newString.characters.count<=4){
      helpAndStrengthButton.setTitleColor(kColor_continueUnselected, for: .normal)
      helpAndStrengthButton.setTitle("VeryWeakStatus".localized(lang: languageCode, comment: ""), for: .normal)
      lblPswrdType.text = "VeryWeakStatus".localized(lang: languageCode, comment: "")
      lblPswrdType.textColor = kColor_continueUnselected
      imgViewPswrdType.tintColor = kColor_continueUnselected
      resetNewPasswordBtn.backgroundColor = kColor_continueUnselected
      resetNewPasswordBtn.isSelected = false
      passwordIsOk = false
    }else if(newString.characters.count < 8){
     weakPasswordView.backgroundColor = kColor_weakPassword
     helpAndStrengthButton.setTitleColor(kColor_weakPassword, for: .normal)
     helpAndStrengthButton.setTitle("WeakStatus".localized(lang: languageCode, comment: ""), for: .normal)
      helpAndStrengthButton.imageView?.tintColor = kColor_weakPassword
      lblPswrdType.text = "WeakStatus".localized(lang: languageCode, comment: "")
      imgViewPswrdType.tintColor = kColor_weakPassword
      lblPswrdType.textColor = kColor_weakPassword
      resetNewPasswordBtn.backgroundColor = kColor_continueUnselected
      resetNewPasswordBtn.isSelected = false
      passwordIsOk = false
      
    }else if(isUpperCased && isLoweredcase && !isSpecialCharecters && (newString.characters.count >= 8)){
      weakPasswordView.backgroundColor = kColor_justOkPassword
      justOkPassword.backgroundColor = kColor_justOkPassword
      helpAndStrengthButton.setTitleColor(kColor_justOkPassword, for: .normal)
      helpAndStrengthButton.setTitle("OkStatus".localized(lang: languageCode, comment: ""), for: .normal)
       lblPswrdType.text = "OkStatus".localized(lang: languageCode, comment: "")
      resetNewPasswordBtn.backgroundColor = kColor_continueSelected
      resetNewPasswordBtn.isSelected = true
      helpAndStrengthButton.imageView?.tintColor = kColor_justOkPassword
      imgViewPswrdType.tintColor = kColor_justOkPassword
      lblPswrdType.textColor = kColor_justOkPassword
      passwordIsOk = true
      
    }else if(isUpperCased && isLoweredcase && isSpecialCharecters && isNumeric && (newString.characters.count >= 8) && (newString.characters.count < 14)){
      weakPasswordView.backgroundColor = kColor_goodPassword
      justOkPassword.backgroundColor = kColor_goodPassword
      goodpasswordView.backgroundColor = kColor_goodPassword
      helpAndStrengthButton.imageView?.tintColor = kColor_goodPassword
      helpAndStrengthButton.setTitleColor(kColor_goodPassword, for: .normal)
      helpAndStrengthButton.setTitle("GoodStatus".localized(lang: languageCode, comment: ""), for: .normal)
      lblPswrdType.text = "GoodStatus".localized(lang: languageCode, comment: "")
      resetNewPasswordBtn.backgroundColor = kColor_continueSelected
      resetNewPasswordBtn.isSelected = true
      imgViewPswrdType.tintColor  = kColor_goodPassword
      lblPswrdType.textColor = kColor_goodPassword
      passwordIsOk = true
    }else if(isUpperCased && isLoweredcase && isSpecialCharecters && isNumeric && (newString.characters.count >= 14)){
      weakPasswordView.backgroundColor = kColor_greatPassword
      justOkPassword.backgroundColor = kColor_greatPassword
      goodpasswordView.backgroundColor = kColor_greatPassword
      greatPasswordView.backgroundColor = kColor_greatPassword
      helpAndStrengthButton.imageView?.tintColor = kColor_greatPassword
      helpAndStrengthButton.setTitleColor(kColor_greatPassword, for: .normal)
      helpAndStrengthButton.setTitle("GreatStatus".localized(lang: languageCode, comment: ""), for: .normal)
       lblPswrdType.text = "GreatStatus".localized(lang: languageCode, comment: "")
      resetNewPasswordBtn.backgroundColor = kColor_continueSelected
      resetNewPasswordBtn.isSelected = true
      imgViewPswrdType.tintColor = kColor_greatPassword
      lblPswrdType.textColor = kColor_greatPassword
      passwordIsOk = true
    }
    
    return true
    }else{
    return false
    }
  }
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text!.range(of:".{8}", options: .regularExpression) != nil &&  textField.text!.range(of:"(.*[A-Z])", options: .regularExpression) != nil && textField.text!.range(of:"(.*[a-z])", options: .regularExpression) != nil && textField.text!.range(of:"(.*[0-9])", options: .regularExpression) != nil && textField.text!.range(of:"(.*[!@#$&*])", options: .regularExpression) != nil{
    
      resetNewPasswordBtn.backgroundColor = kColor_continueSelected
      resetNewPasswordBtn.isSelected = true
      
    }else{
      
//      resetNewPasswordBtn.backgroundColor = kColor_continueUnselected
//      resetNewPasswordBtn.isSelected = false
    }
    
    return true
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField.text!.range(of:".{8}", options: .regularExpression) != nil &&  textField.text!.range(of:"(.*[A-Z])", options: .regularExpression) != nil && textField.text!.range(of:"(.*[a-z])", options: .regularExpression) != nil && textField.text!.range(of:"(.*[0-9])", options: .regularExpression) != nil && textField.text!.range(of:"(.*[!@#$&*])", options: .regularExpression) != nil{
      self.view.endEditing(true)
      resetNewPasswordBtn.backgroundColor = kColor_continueSelected
      resetNewPasswordBtn.isSelected = true
      
      
    }else{
      // Show ERROR
    }
    
    return true
  }
  func textFieldShouldClear(_ textField: UITextField) -> Bool
  {
    weakPasswordView.backgroundColor = kColor_continueUnselected
    justOkPassword.backgroundColor = kColor_continueUnselected
    goodpasswordView.backgroundColor = kColor_continueUnselected
    greatPasswordView.backgroundColor = kColor_continueUnselected
    resetNewPasswordBtn.backgroundColor = kColor_continueUnselected
    resetNewPasswordBtn.isSelected = false
    imgViewPswrdType.tintColor = UIColor.blue
    lblPswrdType.text = ""
    lblPswrdType.textColor = kColor_continueUnselected
    passwordIsOk = false
    return true
  }

  //Call
  @IBAction func onResetPasswordButtonTap(_ sender: Any)
  {
    let localUserdefault = UserDefaults.standard
    if(localUserdefault.object(forKey: kUserNameKey) != nil)
    {
      webServiceCallingToUpdatePassword(prameter: ["username":localUserdefault.object(forKey: kUserNameKey) as AnyObject,"password":passwordTextField.text as AnyObject], withUrl: kUpdatePassword)
    }
    else
    {
      if((localUserdefault.object(forKey: kIsForgot)) != nil)
      {
      if(localUserdefault.object(forKey: kEmail) != nil)
      {
      let recoverUserParam:[String:AnyObject] = ["contact":localUserdefault.object(forKey: kEmail) as AnyObject,"password":passwordTextField.text as AnyObject]
      webServiceCallingToRecoverNewPassword(prameter: recoverUserParam, withUrlType: kResetPassword)
        
      }else if(localUserdefault.object(forKey: kMobileNumber) != nil){
        let recoverUserParam:[String:AnyObject] = ["contact":localUserdefault.object(forKey: kMobileNumber) as AnyObject,"password":passwordTextField.text as AnyObject]
      webServiceCallingToRecoverNewPassword(prameter: recoverUserParam, withUrlType: kResetPassword)
        }
      }
      else
      {
        if passwordIsOk
        {
          signUpdetailsObject.password = passwordTextField.text
          self.performSegue(withIdentifier: kSegue_SecurityPin, sender: self)
        }
      
      }
    }
  }

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
  func webServiceCallingToRecoverUserNameAndResetPasswordByEmail(prameter:[String :AnyObject], withUrlType endPointUrl:String,isForPassword:Bool){
    let finalUrlToHit = "\(kBaseUrl)\(UrlEndPoints.Login.rawValue)\(endPointUrl)"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePostRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        if(isForPassword == true){
          self.methodToHandelResetPasswordByEmailSuccess(data: data!)
        }else{
          self.methodToHandelRecoverUserNameByEmailSuccess(data: data!)
        }
      
      }else{
        self.methodToHandelRecoverUserNameAndResetPasswordEmailfailure(error: error!)
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
  
  func methodToHandelRecoverUserNameByEmailSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)

      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        //self.performSegueWithIdentifier(kSegue_TabBarBaseView, sender: self)
        self.cancelButtonTappedActionWithAnimation()
      }))
      self.present(alert, animated: true, completion: {
        print("completion block")
      })
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
  
  func methodToHandelResetPasswordByEmailSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("success")
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)

      let alert = UIAlertController(title: alertTitle, message: "\(alertbody) \((UserDefaults.standard.object(forKey: kEmail) as! String))", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        self.performSegue(withIdentifier: kSegue_ResetEmail, sender: self)
      }))
      self.present(alert, animated: true, completion: {
        print("completion block")
      })
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

  
  func methodToMakeLoginScreenRoot()
  {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_LoginPage)
    let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
    appDelegate.window?.rootViewController = nav
  }
  
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
  func webServiceCallingToUpdatePassword(prameter:[String :AnyObject], withUrl url:String){
   
    let finalUrlToHit = kBaseUrl + url
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePutRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelUpdatePasswordSuccess(data:data!)
      }else{
        self.methodToHandelUpdatePasswordStatusfailure(error: error!)
      }
      
    }
  }
  
  
  
  func methodToHandelUpdatePasswordSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true")
    {
      print("sucess")
      let localUserdefault = UserDefaults.standard
      if(localUserdefault.object(forKey: kUserId)  == nil)
      {
        self.performSegue(withIdentifier: kSegue_SecurityPin, sender: self)
      }
      else
      {
        if isAfterLogin == true
        {
          // HotwireCommunicationApi.sharedInstance.cloudId?.clearKeychain()
          for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
          }
          UserDefaults.standard.removeObject(forKey: "loginTime")
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
          let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_LoginPage) as! LoginSynacoreViewController
          let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
          appDelegate.window?.rootViewController = nav
        }
        else
        {
          self.navigationController?.popViewController(animated: true)
        }
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
  func methodToHandelUpdatePasswordStatusfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  
  
  
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
  
  func webServiceCallingToRecoverNewPassword(prameter:[String :AnyObject], withUrlType endPointUrl:String){
    let finalUrlToHit = kBaseUrl + endPointUrl
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePutRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{

          self.methodToHandeForRecoveryOfNewPassword(data: data!)
        }
      else{
        self.methodToHandeForRecoveryOfNewPasswordFailure(error: error!)
      }
      
    }
  }
  func methodToHandeForRecoveryOfNewPassword(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("success")
//      let alertTitle = "EmailSentTitle".localized(lang: languageCode, comment: "")
//      let alertbody = "EmailSentBody".localized(lang: languageCode, comment: "")
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)

      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok".localized(lang: languageCode, comment: "Call us Now"), style: .default , handler:{ (UIAlertAction)in
        //self.performSegue(withIdentifier: kSegue_ResetEmail, sender: self)
        let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_LoginPage) as! LoginSynacoreViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
        
        
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
  
  func methodToHandeForRecoveryOfNewPasswordFailure(error:NSError?){
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
   <Date>  2/09/16 </Date>
   </History>
   ***********************************************************************************************************/
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //self.title = "Back"
   
    if segue.identifier == kSegue_SecurityPin,
      let destinationViewController = segue.destination as? SecurityPinSignUpViewController {
      destinationViewController.signUpdetailsObject = signUpdetailsObject
    }
  }

  
  @IBAction func onHelpButtonTapped(_ sender: Any)
  {
    //self.performSegue(withIdentifier: kSegue_PushPasswordHelp, sender: self)
  
    let popUpView = self.storyboard?.instantiateViewController(withIdentifier: "HelpPasswordViewController") as! HelpPasswordViewController
    
    let navController = UINavigationController.init(rootViewController: popUpView)
    self.navigationController?.present(navController, animated: true, completion: nil)
    
  }
  
  
  
}
