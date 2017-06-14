//
//  ContactAccManagerViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 19/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON
class ContactAccManagerViewController: BaseViewController
{
  @IBOutlet var lblSubject: UILabel!
  @IBOutlet var lblIssueType: UILabel!
  @IBOutlet var lblCompose: UILabel!
  @IBOutlet var txtViewMessage: UITextView!
  
  var isFromConact = ""
  var strIssue : String?
  var strIssueCode : String?
  var loader: LoaderView?

  override func viewDidLoad()
  {
    super.viewDidLoad()
    txtViewMessage.delegate = self
    txtViewMessage.becomeFirstResponder()
    viewUpdateContentOnBasesOfLanguage()
    hideKeyboard()
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  override func viewDidDisappear(_ animated: Bool) {
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
      currentViewSize = self.view.frame.size
      if let loaderView = loader
      {
        self.view.addSubview(loaderView)
      }
    }
  }
  
  func viewUpdateContentOnBasesOfLanguage()
  {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    
    lblSubject.text = "Sup_Subject".localized(lang: languageCode, comment: "")
    lblCompose.text = "Sup_ComposeMsg".localized(lang: languageCode, comment: "")
    lblIssueType.text = strIssue!
    
    setupNavigationButton()
  }
  func setupNavigationButton()
  {
    let btnDone = UIBarButtonItem(title: "Sup_Cancel".localized(lang: languageCode, comment: ""), style: .plain, target: self, action: #selector(ContactAccManagerViewController.cancelButtonTapped) )
    self.navigationItem.leftBarButtonItem = btnDone;
    
    let btnSave = UIBarButtonItem(title: "Sup_Send".localized(lang: languageCode, comment: ""), style: .plain, target: self, action: #selector(ContactAccManagerViewController.sendButtunTapped) )
    self.navigationItem.rightBarButtonItem = btnSave;

  }
  func cancelButtonTapped()
  {
    _ = navigationController?.popViewController(animated: true)
  }
   func sendButtunTapped()
  {
    guard let message = txtViewMessage.text,!(message.isStringEmptyAfterRemovingNewLinesAndSpaces())
    else
    {
      return
    }
    var dictParameter = [String : AnyObject]()
    
    if isFromConact == "Contact_Us"
    {
      dictParameter = ["username": (UserDefaults.standard.value(forKey: kUserNameKey)) as AnyObject,"subject":strIssueCode! as AnyObject,"message": message as AnyObject]
    }
    else
    {
      dictParameter = ["username": (UserDefaults.standard.value(forKey: kUserNameKey)) as AnyObject,"subject":strIssueCode! as AnyObject,"message": message as AnyObject,"msa_pro_id":msa_id as AnyObject]
    }
    callWebServiceToSendMessage(parameter:dictParameter)
   
    
  }
  
  func callWebServiceToSendMessage(parameter:[String:AnyObject])
  {
    let finalUrlToHit = kBaseUrl + KSendMessage
   
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    self.view.endEditing(true)
    print("DictParameter===\(parameter)")
    AlamoFireConnectivity.alamofirePostRequest(param: parameter, withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil
      {
        self.methodToHandleSendSuccessMessage(data:data!)
      }
      else
      {
        self.methodToHandleSendMessageFailure(error: error!)
      }
      
    }
  }
  
  func methodToHandleSendSuccessMessage(data:SwiftyJSON.JSON)
  {
    let status = data["Success"].stringValue
    if status.lowercased() == "true"
    {
      let message = (data["Message"].stringValue)
      let alertTitle = message.titleName(languageCode: self.languageCode)
      let alertbody = message.message(languageCode: self.languageCode)
      let alert = UIAlertController(title: alertTitle, message: alertbody, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized(lang:self.languageCode, comment: ""),style:UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
          for viewController in (self.navigationController?.viewControllers)!
          {
            if(viewController.isKind(of: AccountManagerViewController.self))
            {
              _ = self.navigationController?.popToViewController(viewController, animated: true)
              return
            }
          }
          _ = self.navigationController?.popToRootViewController(animated: true)
         
        })
        alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
      
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

  
  func methodToHandleSendMessageFailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}

//MARK: TextView Delegate Method
extension ContactAccManagerViewController : UITextViewDelegate
{
  func textViewDidBeginEditing(_ textView: UITextView)
  {
    
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView)
  {
    
  }
}

