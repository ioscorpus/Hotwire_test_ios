//
//  SignUpEnterYouNameViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 30/08/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpEnterYouNameViewController: BaseViewController,UITextFieldDelegate {
     //var languageCode:String!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var lblPageTitle: UILabel!
    @IBOutlet var txfldFirstName : UITextField!
    @IBOutlet var txfldLastName: UITextField!
    @IBOutlet var lblAboutNameInfo: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnAlreadyHaveAccount: UIButton!
  // data objects
  var userDetails:AnyObject?
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
    }
  override func viewDidAppear(_ animated: Bool) {
    if  !btnContinue.isSelected{
      txfldFirstName.becomeFirstResponder()
    }
    if !((txfldFirstName.text?.isEmpty)!) && !((txfldLastName.text?.isEmpty)!)
    {
      btnContinue.isSelected = true
      btnContinue.backgroundColor = kColor_continueSelected
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
      if(UserDefaults.standard.object(forKey: kFirstName) != nil){
      self.navigationItem.title =  "Display_name".localized(lang: languageCode, comment: "")
        txfldLastName.text = UserDefaults.standard.object(forKey: kLastName) as! String?
        txfldFirstName.text = UserDefaults.standard.object(forKey: kFirstName) as! String?
        btnAlreadyHaveAccount.isHidden = true
        btnContinue.setTitle("languageSaveButtonTitle".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
        addBarButtonOnNavigationBar()
      }
      else{
        self.navigationItem.title =  "SignUp".localized(lang: languageCode, comment: "")
        btnContinue.setTitle("Continue".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
          setUpBackButonOnLeft()
      }
        lblPageTitle.text = "WhatYourName".localized(lang: languageCode, comment: "")
        lblPageTitle.textColor = kColor_continueUnselected
        lblAboutNameInfo.textColor = kColor_continueUnselected
        btnAlreadyHaveAccount.setTitle("AlreadyHaveAccount".localized(lang: languageCode, comment: ""), for: UIControlState.normal)
        btnAlreadyHaveAccount.backgroundColor = kAlreadyhaveAccount
        btnAlreadyHaveAccount.setTitleColor(UIColor.white, for: UIControlState.normal)
      
        txfldFirstName.placeholder = "FirstName".localized(lang: languageCode, comment: "")
        txfldLastName.placeholder = "LastName".localized(lang: languageCode, comment: "")
        lblAboutNameInfo.text = "NameInfoDetails".localized(lang: languageCode, comment: "")
      if(HotwireCommunicationApi.sharedInstance.createUserObject != nil){
      txfldFirstName.text = HotwireCommunicationApi.sharedInstance.createUserObject?.first_name
      txfldLastName.text = HotwireCommunicationApi.sharedInstance.createUserObject?.last_name
      }
      
      if let invitationCodeObject = userDetails as? InvitationCode {
        // success
       txfldFirstName.text = invitationCodeObject.first_name!
       txfldLastName.text = invitationCodeObject.last_name!
      } else {
         print("failre")
      }
    
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
    
      
        txfldFirstName.layer.cornerRadius = 4.0
        txfldFirstName.leftViewMode = UITextFieldViewMode.always
        txfldFirstName.layer.masksToBounds = true
        txfldFirstName.layer.borderColor = kColor_SignUpbutton.cgColor
        txfldFirstName.layer.borderWidth = 1.0
        txfldFirstName.keyboardType = .default
        txfldFirstName.returnKeyType = .next
        txfldFirstName.enablesReturnKeyAutomatically = true
        txfldFirstName.autocorrectionType = UITextAutocorrectionType.no
        
        txfldLastName.layer.cornerRadius = 4.0
        txfldLastName.leftViewMode = UITextFieldViewMode.always
        txfldLastName.layer.masksToBounds = true
        txfldLastName.layer.borderColor = kColor_SignUpbutton.cgColor
        txfldLastName.layer.borderWidth = 1.0
        txfldFirstName.keyboardType = .default
        txfldLastName.returnKeyType = .go
        txfldLastName.enablesReturnKeyAutomatically = true
        txfldLastName.autocorrectionType = UITextAutocorrectionType.no
        btnContinue.backgroundColor = kColor_ContinuteUnselected
        btnContinue.isSelected = false
      //lblAboutNameInfo.isHidden = false
      //btnContinue.isHidden = true
    //  signUpdetailsObject = SignUpDetails()
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
    btn1.setTitle("Back", for: UIControlState.normal)
    btn1.imageEdgeInsets = imageEdgeInsets;
    btn1.titleEdgeInsets = titleEdgeInsets;
    btn1.setImage(UIImage(named: "RedBackBtn"), for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(SignUpEnterYouNameViewController.backButtonTappedAction(_:)
      ), for: .touchUpInside)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  func addBarButtonOnNavigationBar()
  {
    let btnCancel = UIBarButtonItem(title: "Cancel".localized(lang: languageCode, comment: ""), style: .plain, target: self, action:#selector(SignUpEnterYouNameViewController.cancelBarButtonTappedAction(_:)) )
    self.navigationItem.leftBarButtonItem = btnCancel;
    
  }
  func cancelBarButtonTappedAction(_ sender : UIButton){
    if(self.isBeingPresented){
      self.dismiss(animated: true, completion: {});
    }else{
      _ = self.navigationController?.popViewController(animated: true)
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
        //////lblAboutNameInfo.isHidden = false
        //btnContinue.isHidden = true
        //btnContinue.backgroundColor = kColor_ContinuteUnselected
        btnContinue.isSelected = false
        txfldFirstName.layer.borderColor = kColor_SignUpbutton.cgColor
        txfldLastName.layer.borderColor = kColor_SignUpbutton.cgColor
    }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfldFirstName {
            self.txfldLastName.becomeFirstResponder()
        }else if textField == txfldLastName{
            if txfldFirstName.text != "" && txfldLastName.text != ""{
            //btnContinue.isHidden = false
            //lblAboutNameInfo.isHidden = true
            btnContinue.backgroundColor = kColor_continueSelected
            btnContinue.isSelected = true
              // signupdata entry
              signUpdetailsObject.firstName = txfldFirstName.text
              signUpdetailsObject.lastName = txfldLastName.text
            self.performSegue(withIdentifier: kSegue_EnterMobNumber, sender: self)
            }else{
              if txfldFirstName.text == ""{
                 txfldFirstName.becomeFirstResponder()
              }
          }
        }
        return true
    }
  func textFieldShouldClear(_ textField: UITextField) -> Bool
  {
   
    return true
  }
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if txfldFirstName.text != "" && txfldLastName.text != "" {
      self.view.endEditing(true)
      //lblAboutNameInfo.isHidden = true
      //btnContinue.isHidden = false
      btnContinue.backgroundColor = kColor_continueSelected
      btnContinue.isSelected = true
    }else{
      //lblAboutNameInfo.isHidden = true
      //btnContinue.isHidden = false
      btnContinue.backgroundColor = kColor_continueUnselected
      btnContinue.isSelected = false
    }
     txfldFirstName.layer.borderColor = kColor_continueUnselected.cgColor
     txfldLastName.layer.borderColor = kColor_continueUnselected.cgColor
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
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
     @IBAction func continueButtonTappedAction(_ sender: AnyObject) {
        // EnterMobNumber
      self.view.endEditing(true)
        if btnContinue.isSelected{
          if(UserDefaults.standard.object(forKey: kFirstName) != nil){
            webServiceCallingToUpdateFirstLastName()
          }else{
          signUpdetailsObject.firstName = txfldFirstName.text
          signUpdetailsObject.lastName = txfldLastName.text
         self.performSegue(withIdentifier: kSegue_EnterMobNumber, sender: self)
        }
      }
    }
  /***********************************************************************************************************
   <Name> alreadyHaveAccountButtonTapped </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on already have account button</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
    @IBAction func alreadyHaveAccountButtonTapped(_ sender: AnyObject) {
        cancelButtonTappedAction(sender as! UIButton)
    }
  /***********************************************************************************************************
   <Name> touchUpActionOnScrollview </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method execute when click on scrollview button to end editing</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
  @IBAction func touchUpActionOnScrollview(_ sender: AnyObject){
     self.contentView.endEditing(true)
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
  
  func backButtonTappedAction(_ sender : UIButton){
    self.navigationController!.popViewController(animated: true)
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
        self.title = "Back"
      if segue.identifier == kSegue_EnterMobNumber{
        if let nextViewController = segue.destination as? SignUpEnterMobNoViewController {
          nextViewController.flowType = FlowType.SignUp
          nextViewController.userDetails = userDetails
          nextViewController.signUpdetailsObject = signUpdetailsObject
          nextViewController.isAfterLogin = false
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
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addNotificationObserver(){
    NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(application:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    
  }
  
  /***********************************************************************************************************
   <Name> webServiceCallingToUpdateFirstLastName </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  23/02/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToUpdateFirstLastName(){
    
    let formatedString = kBaseUrl+kUpdateUserFirstLastName
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePutRequest(param: ["first_name" : txfldFirstName.text as AnyObject,"last_name":txfldLastName.text as AnyObject,"username":UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject], withUrlString: formatedString, completion: { data,error in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
      self.methodToHandelUpdateFirstLastNameSuccess(data: data!)
      }else{
      self.methodToHandelUpdateFirstLastNamefailure(error: error)
      }
    })
    
  }
  
  func methodToHandelUpdateFirstLastNameSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      // initialize serviceDataSource object and fill its value in tableview
      UserDefaults.standard.set(txfldFirstName.text, forKey: kFirstName)
      UserDefaults.standard.set(txfldLastName.text, forKey: kLastName)
      UserDefaults.standard.synchronize()
      let userDefaultForLoginTime = UserDefaults.standard
      userDefaultForLoginTime.set(Date(), forKey: "loginTime")
      userDefaultForLoginTime.synchronize()
     _ = self.navigationController?.popViewController(animated: true)
      
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
  
  func methodToHandelUpdateFirstLastNamefailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  


  //notification method to update UI
  func applicationWillEnterForeground(application: UIApplication) {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    print("applicationWillEnterForeground")
    viewUpdateContentOnBasesOfLanguage()
  }
  
}
