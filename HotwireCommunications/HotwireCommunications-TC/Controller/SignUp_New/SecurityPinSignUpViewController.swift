//
//  SecurityPinSignUpViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 04/10/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SwiftyJSON
class SecurityPinSignUpViewController:BaseViewController,UITextFieldDelegate {
 // var languageCode:String!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var contentView: UIView!
  
  @IBOutlet var lblPageTitle: UILabel!
  @IBOutlet var txfldEnterSecurityCode : UITextField!
  @IBOutlet var lblAboutSecurityCodeInfo: UILabel!
  @IBOutlet weak var btnContinue: UIButton!
  @IBOutlet weak var btnAlreadyHaveAccount: UIButton!
  // processing view
  @IBOutlet var viewWhiteBackground: UIView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var lbl_LoadingText: UILabel!
  // Toolbar variable declaration
  var toolBar:UIToolbar!
  var continueButton:UIButton!
  // data object
  var createUserObject :CreateUser?
   var signUpdetailsObject:SignUpDetails!
  var loader: LoaderView?
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 04/10/16 </Date>
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
    lblAboutSecurityCodeInfo.isHidden = true
    btnContinue.isHidden = false
    viewWhiteBackground.isHidden = true
    activityIndicator.isHidden = true
    lbl_LoadingText.isHidden = true
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if !btnContinue.isSelected{
      txfldEnterSecurityCode.becomeFirstResponder()
    }
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    self.navigationItem.title =  "SignUp".localized(lang: languageCode, comment: "")
    lblPageTitle.text = "CreateSecurityPin".localized(lang: languageCode, comment: "")
    btnAlreadyHaveAccount.setTitle("AlreadyHaveAccount".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    btnAlreadyHaveAccount.backgroundColor = kAlreadyhaveAccount
    btnAlreadyHaveAccount.setTitleColor(UIColor.white, for: UIControlState.normal)
    btnContinue.setTitle("Continue".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    btnContinue.backgroundColor = kColor_ContinuteUnselected
    btnContinue.isSelected = false
    txfldEnterSecurityCode.placeholder = "EnterPin".localized(lang: languageCode, comment: "")
    lblAboutSecurityCodeInfo.text = "SecurityPinInfoText".localized(lang: languageCode, comment: "")
    toolBar = addDoneButton(selector: #selector(SecurityPinSignUpViewController.toolBarContinueButtonAction(_:)))
    txfldEnterSecurityCode.inputAccessoryView = toolBar
    lbl_LoadingText.text = "CreateYourAccount".localized(lang: languageCode, comment: "")
    lblPageTitle.textColor = kColor_continueUnselected
    lblAboutSecurityCodeInfo.textColor = kColor_continueUnselected
     setUpBackButonOnLeft()
  }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/

  func configureViewProperty(){
   
    txfldEnterSecurityCode.becomeFirstResponder()
  //  txfldEnterSecurityCode.layer.cornerRadius = 4.0
    txfldEnterSecurityCode.leftViewMode = UITextFieldViewMode.always
    txfldEnterSecurityCode.layer.masksToBounds = true
    txfldEnterSecurityCode.layer.borderColor = kColor_SignUpbutton.cgColor
    txfldEnterSecurityCode.layer.borderWidth = 1.0
    txfldEnterSecurityCode.returnKeyType = .next
    txfldEnterSecurityCode.enablesReturnKeyAutomatically = true
    
  }
  /***********************************************************************************************************
   <Name> setUpBackButonOnLeft </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to set the custom back button </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func setUpBackButonOnLeft(){
    self.navigationItem.setHidesBackButton(true, animated:true);
    let btn1 = UIButton(frame:KFrame_CancelBarbutton )
    btn1.setTitle("Back".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    btn1.imageEdgeInsets = imageEdgeInsets;
    btn1.titleEdgeInsets = titleEdgeInsets;
    btn1.setImage(UIImage(named:"RedBackBtn"), for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(SecurityPinSignUpViewController.backButtonTappedAction(_:)), for: .touchUpInside)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  /***********************************************************************************************************
   <Name> backButtonTappedAction </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on custom back button to navigate to next view</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func backButtonTappedAction(_ sender : UIButton){
    self.navigationController!.popViewController(animated: true)
  }
  /***********************************************************************************************************
   <Name> addDoneButton </Name>
   <Input Type>  Selector  </Input Type>
   <Return> UIToolbar </Return>
   <Purpose> method to set the toolbar on keyboard </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addDoneButton(selector:Selector) -> UIToolbar {
    let toolbar = UIToolbar()
    let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    continueButton = UIButton()
    continueButton.frame = KFrame_Toolbar
    continueButton.setTitle("Done".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
    continueButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    continueButton.setTitleColor(UIColor.white, for: UIControlState.selected)
    continueButton.addTarget(self, action: selector, for: .touchUpInside)
    continueButton.titleLabel!.font = kFontStyleSemiBold20
    
    let toolbarButton = UIBarButtonItem()
    toolbarButton.customView = continueButton
    toolbar.setItems([flexButton, toolbarButton], animated: true)
    toolbar.barTintColor = kColor_NavigationBarColor
    toolbar.sizeToFit()
    return toolbar
  }
  //MARK: Text field Delegate
  /***********************************************************************************************************
   <Name> textFieldShouldEndEditing, shouldChangeCharactersInRange ,textFieldDidBeginEditing, textFieldShouldClear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Textfield delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func textFieldDidBeginEditing(_ textField: UITextField) {
    lblAboutSecurityCodeInfo.isHidden = false
   // btnContinue.isHidden = true
    txfldEnterSecurityCode.layer.borderColor = kColor_SignUpbutton.cgColor
//    btnContinue.backgroundColor = kColor_ContinuteUnselected
//    btnContinue.isSelected = false
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
   // btnContinue.backgroundColor = kColor_continueSelected
    txfldEnterSecurityCode.layer.borderColor = kColor_continueUnselected.cgColor
    return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else {
      return true
    }
    let newLength = text.utf16.count + string.utf16.count - range.length
    if newLength < 4{
     // toolBar.barTintColor = kColor_ToolBarUnselected
      btnContinue.isSelected = false
      btnContinue.backgroundColor = kColor_continueUnselected
      btnContinue.titleLabel?.textColor = UIColor(colorLiteralRed: 192.0, green: 198.0, blue: 212.0, alpha: 1)
    }else{
      btnContinue.isSelected = true
      toolBar.barTintColor = kColor_NavigationBarColor
      btnContinue.backgroundColor = kColor_continueSelected
      btnContinue.titleLabel?.textColor = .white
    }
    return newLength <= 4
  }
  func textFieldShouldClear(_ textField: UITextField) -> Bool
  {
    toolBar.barTintColor = kColor_NavigationBarColor
    btnContinue.isSelected = false
    btnContinue.backgroundColor = kColor_continueUnselected
    btnContinue.titleLabel?.textColor = UIColor(colorLiteralRed: 192.0, green: 198.0, blue: 212.0, alpha: 1)
    return true
  }

  //MARK:- IB button action
  /***********************************************************************************************************
   <Name> continueButtonTappedAction </Name>
   <Input Type>  AnyObject  </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on continue button</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/

  @IBAction func continueButtonTappedAction(_ sender: AnyObject) {
    // EnterMobNumber
   if txfldEnterSecurityCode.text != "" &&  txfldEnterSecurityCode.text?.characters.count == 4 && btnContinue.isSelected{
    signUpdetailsObject.fourDigitPin = Int(txfldEnterSecurityCode.text!)
    webServiceCallingToCreateUser(urlType: "createUser")
    }
  }
  /***********************************************************************************************************
   <Name> alreadyHaveAccountButtonTapped </Name>
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on alreadyHaveAccount Button  tapped </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func alreadyHaveAccountButtonTapped(_ sender: AnyObject) {
    cancelButtonTappedAction(sender as! UIButton)
    
  }
  /***********************************************************************************************************
   <Name> touchUpActionOnScrollview </Name>
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method execute when clic3k on Scroll view to end editing on view</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func touchUpActionOnScrollview(_ sender: AnyObject){
    self.contentView.endEditing(true)
    if txfldEnterSecurityCode.text?.characters.count == 4{
      self.view.endEditing(true)
      btnContinue.backgroundColor = kColor_continueSelected
      btnContinue.titleLabel?.textColor = .white
      btnContinue.isSelected = true
    }
  }
  /***********************************************************************************************************
   <Name> toolBarContinueButtonAction </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on tool bar Continue button tapped </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func toolBarContinueButtonAction(_ sender: AnyObject)
  {
    self.view.endEditing(true)
//    if txfldEnterSecurityCode.text != "" &&  txfldEnterSecurityCode.text?.characters.count == 4{
//      self.view.endEditing(true)
//      viewWhiteBackground.isHidden = false
//      activityIndicator.isHidden = false
//      lbl_LoadingText.isHidden = false
//      self.view.bringSubview(toFront: viewWhiteBackground)
//      activityIndicator.startAnimating()
//      signUpdetailsObject.fourDigitPin = Int(txfldEnterSecurityCode.text!)
//      webServiceCallingToCreateUser(urlType: "createUser")
//
//     
//    }
  }
  /***********************************************************************************************************
   <Name> methodToShowLoading </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to show activiy indicator and show loading </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
  func methodToShowLoading(){
   // let triggerTime = (Int64(NSEC_PER_SEC) * 3)
    let when = DispatchTime.now() + 0 // change 2 to desired number of seconds
    DispatchQueue.main.asyncAfter(deadline: when) {
      _ = "Main"
      //self.loadControllerPageSelectedByUser(storyBoard: mainStoryboard, withStoryboardIdentifier: kStoryBoardID_LoginPage)
       self.webServiceCallingTogetAccountStatus(prameter: ["username" : UserDefaults.standard.value(forKey: kUserNameKey) as AnyObject], withUrlType: kCheckFirstTimeLoginStatus)
        let userDefaultForLoginTime = UserDefaults.standard
        userDefaultForLoginTime.set(Date(), forKey: "loginTime")
        userDefaultForLoginTime.synchronize()
     // self.performSegue(withIdentifier: kSegue_WelcomeScreen, sender: self)
    }
//    dispatch_after(dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), triggerTime), dispatch_get_main_queue(), { () -> Void in
//      self.performSegue(withIdentifier: kSegue_WelcomeScreen, sender: self)
//    })
    
  }
  
  func  loadTabBarControllerPageSelectedByUserOnParticuralIndex(storyBoard:String, withStoryboardIdentifier identifier:String, onSelectedIndex index:Int){
    let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! TabBarViewController
    initialViewController.selectedIndex = index
    appDelegate.window?.rootViewController = initialViewController
    appDelegate.window?.makeKeyAndVisible()
  }
  
  func  loadControllerPageSelectedByUser(storyBoard:String, withStoryboardIdentifier identifier:String){
    let storyboard = UIStoryboard(name:storyBoard, bundle: nil)
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let mainViewController = storyboard.instantiateViewController(withIdentifier: identifier)
    let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
    appDelegate.window?.rootViewController = nav
  }
  // MARK: Create User web service
  //to Create user web service integration
  /***********************************************************************************************************
   <Name> webServiceCallingToCreateUser </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  28/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToCreateUser(urlType:String){
    let finalUrlToHit = "\(kBaseUrl)\(kValidate_Create_user)"
//    let pram = [
//        "invitation_code":788465,
//        "customer_number":"",
//        "first_name":"ankit",
//        "last_name":"kumar",
//        "phone":5555555555,
//        "email":"ankitk2@chetu.com",
//        "password":"Chetu@123",
//        "pin":100001,
//        "head_of_household":"true",
//        "verify":"true"]
    
    var prameter = [String:AnyObject]()
    prameter["invitation_code"] = signUpdetailsObject.invitaionCode == nil ? "" as AnyObject?
      : signUpdetailsObject.invitaionCode as AnyObject?

   // prameter["customer_number"] = signUpdetailsObject.customerNumber == nil ? ""as AnyObject?
//      : signUpdetailsObject.customerNumber as AnyObject?

    prameter["first_name"] = signUpdetailsObject.firstName as AnyObject?
    prameter["last_name"] = signUpdetailsObject.lastName as AnyObject?
    let phoneNum = (UserDefaults.standard.object(forKey: kMobileNumber) as! String)
    prameter["phone"] = phoneNum as AnyObject//signUpdetailsObject.mobileNumber as AnyObject?
    prameter["email"] = signUpdetailsObject.emailAddress as AnyObject?
    prameter["password"] = signUpdetailsObject.password as AnyObject?
    prameter["pin"] = signUpdetailsObject.fourDigitPin as AnyObject?
    prameter["primary"] = "false" as AnyObject?
    if(signUpdetailsObject.customerNumber != nil){
    prameter["customer_number"] = signUpdetailsObject.customerNumber as AnyObject?
    }
    //prameter["property_address_id"] = 22 as AnyObject?
    prameter["head_of_household"] = true as AnyObject?
    prameter["verify"] = true as AnyObject?
    prameter["time_zone_name"] = "Eastern Standard Time" as AnyObject?
    prameter["language_iso_code"] = "EN" as AnyObject?
    loader = LoaderView()
      
    loader?.initLoader()
    self.view.addSubview(loader!)

    AlamoFireConnectivity.alamofirePutRequest(param: prameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        self.methodToHandelCreateUserSuccess(data: data!)
      }else{
        self.methodToHandelCreateUserfailure(error: error!)
      }
    }
  }
  func methodToHandelCreateUserSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true")
    {
      let dataValue = data["Data"].dictionary
      let createUser = dataValue!["User"]?.dictionary
      createUserObject = CreateUser.init(dictionary:createUser!)
     // let triggerTime = (Int64(NSEC_PER_SEC) * 3)
      UserDefaults.standard.set(createUser?["email"]?.stringValue, forKey: kEmail)
      UserDefaults.standard.set(createUser?["first_name"]?.stringValue, forKey: kFirstName)
      UserDefaults.standard.set(createUser?["last_name"]?.stringValue, forKey: kLastName)
      UserDefaults.standard.set(createUser?["phone"]?.stringValue, forKey: kMobileNumber)
      UserDefaults.standard.set(createUser?["user_id"]?.stringValue, forKey: kUserId)
      UserDefaults.standard.set(createUser?["username"]?.stringValue, forKey: kUserNameKey)
      UserDefaults.standard.set(createUser?["access_token"]?.stringValue, forKey: kAccessToken)
      UserDefaults.standard.set(createUser?["token_type"]?.stringValue, forKey: kTokenType)
      UserDefaults.standard.synchronize()
      DispatchQueue.main.asyncAfter(deadline: .now()) {
        self.lbl_LoadingText.text = "LoggingIn".localized(lang: self.languageCode, comment: "")
        self.methodToShowLoading()
      }
//      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
//        self.lbl_LoadingText.text = "LoggingIn".localized(self.languageCode, comment: "")
//        self.methodToShowLoading()
//      })
    }
    /*else{
      self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["Message"].stringValue, languageCode: languageCode)
    }*/
    else{
      let message = (data["Message"].stringValue)
             self.showTheAlertViewWith(title: message.titleName(languageCode: self.languageCode), withMessage: message.message(languageCode: self.languageCode), languageCode: self.languageCode)
    
    }

  }
  
  func methodToHandelCreateUserfailure(error:NSError?){
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
   <Date>  04/10/16 </Date>
   </History>
   ***********************************************************************************************************/
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == kSegue_WelcomeScreen,
      let destinationViewController = segue.destination as? WelcomeUserViewController {
        destinationViewController.createUserObject = createUserObject
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
   <Date>   04/10/16 </Date>
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
