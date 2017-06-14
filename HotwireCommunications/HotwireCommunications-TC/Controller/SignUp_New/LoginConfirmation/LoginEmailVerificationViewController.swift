//
//  LoginEmailVerificationViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 03/11/16.
//  Copyright © 2016 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginEmailVerificationViewController: BaseViewController ,UITextFieldDelegate{
  //var languageCode:String!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var contentView: UIView!
  @IBOutlet var lblPageTitle: UILabel!
  @IBOutlet var txfldEnterEmailAddress : UITextField!
  @IBOutlet var lblAboutEmailAddressInfo: UILabel!
  @IBOutlet weak var btnContinue: UIButton!
  // login or signup flag
  var login:Bool = false
  var isAlreadyLogin = false
  var loader: LoaderView?
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewProperty()
    if(isAlreadyLogin == true)
    {
      txfldEnterEmailAddress.text = UserDefaults.standard.object(forKey: kEmail) as! String?
      
    }
   
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
  
 
  override func viewWillAppear(_ animated: Bool)
  {
    viewUpdateContentOnBasesOfLanguage()
    addNotificationObserver()
    self.navigationController?.navigationBar.isHidden = false
     if(UserDefaults.standard.object(forKey: kEmailVerified) != nil)
     {
      addBarButtonOnNavigationBar()
     }
     else
     {
        self.navigationItem.setHidesBackButton(true, animated: false)
     }
  }
  
  func addBarButtonOnNavigationBar()
  {
    let btnCancel = UIBarButtonItem(title: "Cancel".localized(lang: languageCode, comment: ""), style: .plain, target: self, action:#selector(LoginEmailVerificationViewController.cancelBarButtonTappedAction(_:)) )
    self.navigationItem.leftBarButtonItem = btnCancel;
    
  }
  func cancelBarButtonTappedAction(_ sender : UIButton)
  {
    if(self.isBeingPresented){
      self.dismiss(animated: true, completion: {});
    }else{
      _ = self.navigationController?.popViewController(animated: true)
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
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    self.navigationItem.title =  "AccountSetup".localized(lang: languageCode, comment: "")
    
    lblPageTitle.text = "VerifyEmailAddress".localized(lang: languageCode, comment: "")
    btnContinue.setTitle("LoginSendVerificationCode".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    txfldEnterEmailAddress.placeholder = "EnterEmailAddress".localized(lang: languageCode, comment: "")
    lblAboutEmailAddressInfo.text = "VerifyEmailAddressInfo".localized(lang: languageCode, comment: "")
    if(isAlreadyLogin == true)
    {
      self.navigationItem.title =  "EmailAddressTitle".localized(lang: languageCode, comment: "")
      lblAboutEmailAddressInfo.text = "VerifyEmailAddressInfoAfterLogin".localized(lang: languageCode, comment: "")
      btnContinue.backgroundColor = kColor_continueSelected
      btnContinue.titleLabel?.textColor = .white
      btnContinue.isSelected = true
      
    }
  }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
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
    txfldEnterEmailAddress.keyboardType = .emailAddress
    txfldEnterEmailAddress.enablesReturnKeyAutomatically = true
    txfldEnterEmailAddress.autocorrectionType = UITextAutocorrectionType.no
    btnContinue.backgroundColor = kColor_ContinuteUnselected
    btnContinue.isSelected = false
    lblAboutEmailAddressInfo.isHidden = false
    //btnContinue.isHidden = true
  }   //MARK: textField delegate method
  
  /***********************************************************************************************************
   <Name> textFieldShouldEndEditing, shouldChangeCharactersInRange ,textFieldDidBeginEditing, textFieldShouldClear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Textfield delegate methods to handel texfield status action</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  func textFieldDidBeginEditing(_ textField: UITextField)
  {
    lblAboutEmailAddressInfo.isHidden = false
    //btnContinue.isSelected = false
  }
  /*func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
  {
    if isValidEmail(testStr: textField.text!){
      self.view.endEditing(true)
      btnContinue.backgroundColor = kColor_continueSelected
      btnContinue.isSelected = true
     // lblAboutEmailAddressInfo.isHidden = false
      btnContinue.isHidden = false
      
    }else{
      btnContinue.backgroundColor = kColor_continueUnselected
      btnContinue.isSelected = false
    //  lblAboutEmailAddressInfo.isHidden = true
      btnContinue.isHidden = false
    }
    return true
  }*/
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    if isValidEmail(testStr: newString)
    {
            btnContinue.backgroundColor = kColor_continueSelected
            btnContinue.isSelected = true
            btnContinue.titleLabel?.textColor = .white
    }
    else{
            btnContinue.backgroundColor = kColor_continueUnselected
            btnContinue.isSelected = false
            btnContinue.titleLabel?.textColor = .gray
    }
    
    
    return true
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    if isValidEmail(testStr: textField.text!)
    {
      self.view.endEditing(true)
      btnContinue.backgroundColor = kColor_continueSelected
      btnContinue.isSelected = true
      self.performSegue(withIdentifier: kSegue_LoginEmailVarification, sender: self)
    }
    else
    {
      showTheAlertViewWith(title: "Invalid EmailId", withMessage: "Please enter valid email address", languageCode: languageCode)
    }
    return true
  }
  func textFieldShouldClear(_ textField: UITextField) -> Bool
  {
    btnContinue.backgroundColor = kColor_continueUnselected
    btnContinue.isSelected = false
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
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func continueButtonTappedAction(_ sender: AnyObject)
  {
    // EnterMobNumber
    if btnContinue.isSelected == true
    {
       webServiceCallingToValidateEmailID(prameter: ["email":txfldEnterEmailAddress.text! as String as AnyObject], withUrlType: kValidate_Email_Number)
    }
   
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
    if(status.lowercased() == "true"){
      /*//signUpdetailsObject.emailAddress = txfldEnterEmailAddress.text
      UserDefaults.standard.set(txfldEnterEmailAddress.text, forKey: kEmail)
      UserDefaults.standard.synchronize()
      Utility.pushDesiredViewControllerOver(viewController: self)*/
      UserDefaults.standard.set(data["Data"]["Email"].stringValue, forKey: kEmail)
      UserDefaults.standard.synchronize()
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let mainViewController = storyboard.instantiateViewController( withIdentifier: kSegue_VarificationEmailAddress) as! VerifyEmailAddressViewController
      mainViewController.isAlreadyLogin = true
      self.navigationController?.pushViewController(mainViewController, animated: true)

    }else{
      let errorcode = data["ErrorCode"].intValue
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
        // self.showTheAlertViewWithLoginButton(title: "EmailAlreadyInUseTitle".localized(lang: languageCode, comment: ""), withMessage: data["Message"].stringValue, languageCode: languageCode)
        self.showTheAlertViewWith(title: "EmailAlreadyInUseTitle".localized(lang: languageCode, comment: ""), withMessage: txfldEnterEmailAddress.text!+" "+"EmailAlreadyInUseBody".localized(lang: languageCode, comment: ""), languageCode: languageCode)
        break;
      case ErrorCode.InvalidUseCredential.rawValue:
        
        self.showTheAlertViewWith(title: "EmailInvalidTitle".localized(lang: languageCode, comment: ""), withMessage: "EmailInvalidBody".localized(lang: languageCode, comment: ""), languageCode: languageCode)
        break;
      default:
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["Message"].stringValue, languageCode: languageCode)
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
  
  /***********************************************************************************************************
   <Name> alreadyHaveAccountButtonTapped </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on Already have account button tapped</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func alreadyHaveAccountButtonTapped(_ sender: AnyObject) {
    cancelButtonTappedAction(sender as! UIButton)
    
  }
  /***********************************************************************************************************
   <Name> touchUpActionOnScrollview </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on Scroll view to handle end editing</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func touchUpActionOnScrollview(_ sender: AnyObject){
    self.contentView.endEditing(true)
    
  }
  // MARK: - Navigation
  
  /***********************************************************************************************************
   <Name> prepareForSegue </Name>
   <Input Type> UIStoryboardSegue,AnyObject </Input Type>
   <Return> void </Return>
   <Purpose> method call when segue called  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
   </History>
   ***********************************************************************************************************/
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if(segue.identifier == kSegue_LoginEmailVarification){
    if let nextViewController = segue.destination as? VerifyEmailAddressViewController {
      nextViewController.isAlreadyLogin = isAlreadyLogin
    }
  }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  //MARK:- ADD notification
  /***********************************************************************************************************
   <Name> addNotificationObserver </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication come to foreground and update selected languge </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  03/11/16 </Date>
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
