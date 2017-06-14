//
//  AccountLanguageListViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 03/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccountLanguageListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

  @IBOutlet var parentTableView: UITableView!
  
  var saveButton:UIButton!
  var languageArray:[SwiftyJSON.JSON]! = Array()
  var selectedIndex = -1;
  var selectedLanguageCode:String! = ""
  var selectedLanguage:String! = ""
  var loader: LoaderView?
  
  override func viewDidLoad()
  {
      super.viewDidLoad()
      parentTableView.dataSource = self
      parentTableView.delegate = self
      viewUpdateContentOnBasesOfLanguage()
      webServiceCallingToFetchLanguage()
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
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
  func viewUpdateContentOnBasesOfLanguage(){
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    self.title  = "LanguageTitle".localized(lang: languageCode, comment: "")
   parentTableView.reloadData()
    //     lblTitle.text = "Account".localized(lang: languageCode, comment: "")
    
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return 38
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderTableViewCell
    headerCell.lblHeaderTitle.text = "Laungage_Options".localized(lang: self.languageCode, comment: "")
    return headerCell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return languageArray.count+1
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if(indexPath.row == languageArray.count){
     return 150
    }
    return 60
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if(indexPath.row<languageArray.count){
    let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier_LanguageChoice) as? AccountLanguageTableViewCell
      cell?.languageInEnglish.text = languageArray[indexPath.row]["iso_code"].stringValue
      cell?.mainLanguage.text = languageArray[indexPath.row]["name"].stringValue
      cell?.selectionImage.isHidden = true
      if(LanguageManager.sharedInstance.availableLocales.count < languageArray.count){
      let locale = Locale().initWithLanguageCode(languageCode: languageArray[indexPath.row]["iso_code"].stringValue.lowercased() as NSString, name: languageArray[indexPath.row]["name"].stringValue as NSString)
        LanguageManager.sharedInstance.availableLocales.append(locale as! Locale)
        
        
      }
      if(selectedIndex>=0)
      {
        if(indexPath.row == selectedIndex)
        {
          cell?.selectionImage.isHidden = false
        }
      }
      else
      {
        if(cell?.languageInEnglish.text == (UserDefaults.standard.object(forKey: kiSOCode) as? String)?.uppercased()){
         cell?.selectionImage.isHidden = false
        }
      }
      return cell!
    }else{
    let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier_LanguageIntroWithButon)
      //(cell?.viewWithTag(1) as? UILabel)?.text = "languageIntro".localized(lang: languageCode, comment: "")
      (cell?.viewWithTag(1) as? UILabel)?.text = ""
      saveButton = cell?.viewWithTag(2) as? UIButton
      (cell?.viewWithTag(2) as? UIButton)?.setTitle("languageSaveButtonTitle".localized(lang: languageCode, comment: ""), for: .normal)
      (cell?.viewWithTag(2) as? UIButton)?.addTarget(self, action: #selector(AccountLanguageListViewController.restartApp(_:)), for: .touchUpInside)
      if(selectedIndex == -1)
      {
        saveButton.backgroundColor = kColor_continueUnselected
        saveButton.isUserInteractionEnabled = false
      }
      else
      {
        saveButton.backgroundColor = kColor_continueSelected
        saveButton.backgroundColor = kColor_continueSelected
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.isUserInteractionEnabled = true
        
      }
      return cell!
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    if(indexPath.row<languageArray.count)
    {
      selectedIndex = indexPath.row
      selectedLanguageCode = languageArray[indexPath.row]["iso_code"].stringValue.lowercased()
      selectedLanguage = languageArray[indexPath.row]["name"].stringValue
      tableView.reloadData()
    
      
    }
  }
   func restartApp(_ sender : UIButton)
   {
      webServiceCallingToUpdateLanguage()
   }
  
    
    // MARK: - Web API

  /***********************************************************************************************************
   <Name> webServiceCallingToFetchLanguage </Name>
   <Input Type> Url , and premeters </Input Type>
   <Return> void </Return>
   <Purpose> method to call a almofire web service method from alamofire connection class to request post web service </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  18/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func webServiceCallingToFetchLanguage(){
    let finalUrlToHit = kBaseUrl+kFetchLanguages
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrlToHit){(data, error) in

      if data != nil{
        self.loader?.removeFromSuperview()
        self.loader = nil
        self.methodToHandelLanguageListSuccess(data:data!)
      }else{
        self.methodToHandelGetLanguagefailure(error: error!)
      }
      
    }
    
  }
  
  func methodToHandelLanguageListSuccess(data:SwiftyJSON.JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      LanguageManager.sharedInstance.availableLocales.removeAll()
      languageArray = data["Data"]["Languages"].arrayValue
      parentTableView.reloadData()
    }else{
      let errorcode = data["ErrorCode"].intValue
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
        self.showTheAlertViewWithLoginButton(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: data["Message"].stringValue, languageCode: languageCode)
      default:
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["Message"].stringValue, languageCode: languageCode)
      }
    }
  }
  func methodToHandelGetLanguagefailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
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
  func webServiceCallingToUpdateLanguage(){
    let finalUrlToHit = kBaseUrl+kUpdateLanguages
    let loaderView = LoaderView()
    loaderView.initLoader()
    self.view.addSubview(loaderView)
    AlamoFireConnectivity.alamofirePutRequest(param: ["language" : selectedLanguageCode as AnyObject,"username":UserDefaults.standard.object(forKey: kUserNameKey) as AnyObject], withUrlString: finalUrlToHit){(data, error) in
      loaderView.removeFromSuperview()
      if data != nil{
        
        self.methodToHandelLanguageUpdateSuccess(data:data!)
      }else{
        self.methodToHandelUpdateLanguagefailure(error: error!)
      }
      
    }
  }

  func methodToHandelLanguageUpdateSuccess(data:SwiftyJSON.JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
       UserDefaults.standard.set(selectedIndex, forKey: "language")
      UserDefaults.standard.set(selectedLanguageCode, forKey: kiSOCode)
      UserDefaults.standard.set(selectedLanguage, forKey: kLanguageKey)
      UserDefaults.standard.synchronize()
       LanguageManager.sharedInstance.setLanguageWithLocale(locale: Locale().initWithLanguageCode(languageCode: selectedLanguageCode as NSString, name: selectedLanguage as NSString) as! Locale)
      self.navigationController?.popViewController(animated: true)
      //Utility.restartApp(viewController: self)
    }else{
      let errorcode = data["ErrorCode"].intValue
      switch errorcode {
      case ErrorCode.AlreadyUseCredential.rawValue:
        self.showTheAlertViewWithLoginButton(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: data["Message"].stringValue, languageCode: languageCode)
      default:
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["Message"].stringValue, languageCode: languageCode)
      }
    }
  }
  func methodToHandelUpdateLanguagefailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  


}
