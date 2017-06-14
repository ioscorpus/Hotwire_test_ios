//
//  UserNameViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 14/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserNameViewController: BaseViewController,UITextFieldDelegate {
  @IBOutlet var userNameTitle: UILabel!
  @IBOutlet var saveBtn: UIButton!
  @IBOutlet var userNameInfoLable: UILabel!
  @IBOutlet var userNameTextField: UITextField!
  var userName:String = ""
  var loader: LoaderView?
  var isAfterLogin = false
  
  override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
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
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewUpdateContentOnBasesOfLanguage()
    if((userNameTextField.text?.characters.count)! > 0){
    saveBtn.backgroundColor = kColor_continueSelected
      saveBtn.isSelected = true
    }
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
  }
  
   // MARK: - Continue Button Action
  @IBAction func onSaveUserName(_ sender: Any) {
    if(saveBtn.isSelected)
    {
    webServiceCallingToUpdateUserName()
    }
  }
  
  /***********************************************************************************************************
   <Name> webServiceCallingToUpdateLanguage </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  18/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToUpdateUserName(){
    let finalUrlToHit = kBaseUrl+kUpdateUserNameByUser
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePutRequest(param: ["old_username" : UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject,"new_username":userNameTextField.text as AnyObject], withUrlString: finalUrlToHit){(data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        
        self.methodToHandelUsernameUpdateSuccess(data:data!)
      }else{
        self.methodToHandelUpdateUsernamefailure(error: error!)
      }
      
    }
 
  }
  
  func methodToHandelUsernameUpdateSuccess(data:SwiftyJSON.JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
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
          //  mainViewController.transitioningDelegate = self
     
          let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
            appDelegate.window?.rootViewController = nav
      }
      else
      {
        UserDefaults.standard.set(userNameTextField.text, forKey: kUserNameKey)
        UserDefaults.standard.synchronize()
        _ = self.navigationController?.popViewController(animated: true)
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
  func methodToHandelUpdateUsernamefailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  

  /***********************************************************************************************************
   <Name> viewUpdateContentOnBasesOfLanguage </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to update content on the bases of language</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 04/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
   
    self.title = "UserNameTitle".localized(lang: languageCode, comment: "")
    saveBtn.setTitle("languageSaveButtonTitle".localized(lang: languageCode, comment: ""), for: .normal)
    saveBtn.backgroundColor = kColor_continueUnselected
    userNameTitle.text = "UserNameHeading".localized(lang: languageCode, comment: "")
    userNameInfoLable.text = "UserNameInfo".localized(lang: languageCode, comment: "")
    userNameTextField.placeholder = "UserNamePlaceholder".localized(lang: languageCode, comment: "")
    userNameTextField.text = UserDefaults.standard.object(forKey: kUserNameKey) as? String
    addBarButtonOnNavigationBar()
  }
  func addBarButtonOnNavigationBar()
  {
    let btnCancel = UIBarButtonItem(title: "Cancel".localized(lang: languageCode, comment: ""), style: .plain, target: self, action:#selector(UserNameViewController.cancelBarButtonTappedAction(_:)) )
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   // MARK: - TextFieldDelegate
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if(userNameTextField.text?.characters.count == 0){
     saveBtn.backgroundColor = kColor_continueUnselected
      saveBtn.isSelected = false
    }else{
    saveBtn.backgroundColor = kColor_continueSelected
      saveBtn.isSelected = true
    }
    return true
  }
  

  
  

}
