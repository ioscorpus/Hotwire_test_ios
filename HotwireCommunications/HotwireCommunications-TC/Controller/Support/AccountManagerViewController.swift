//
//  AccountManagerViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 17/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccountManagerViewController: BaseViewController
{
  @IBOutlet var tblViewAccManager: UITableView!
  @IBOutlet var imgViewBackground: UIImageView!
  @IBOutlet var imgViewAccManager: UIImageView!
  @IBOutlet var lblAccManagerName: UILabel!
  @IBOutlet var lblAccmanagerAddress: UILabel!
  
  var loader: LoaderView?
  fileprivate var dataModelForAccountManager : DataModelForAccountManager?
  fileprivate let arrHeaderTitle = ["","Sup_office_address","Sup_contact_info"]
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    viewUpdateContentOnBasesOfLanguage()
    makeImageRoundedWithBorder()
    tblViewAccManager.estimatedRowHeight = 79
    tblViewAccManager.rowHeight = UITableViewAutomaticDimension
    tblViewAccManager.isHidden = true
    callWebServiceToGetTheAccountManagerInfo()
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
 
  override func viewDidDisappear(_ animated: Bool)
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
    
    self.title = "Sup_AccountManager".localized(lang: languageCode, comment: "")
  }
  
  func makeImageRoundedWithBorder()
  {
    imgViewAccManager.layer.cornerRadius = 46.5
    imgViewAccManager.layer.borderWidth = 2
    imgViewAccManager.layer.borderColor = (UIColor.white).cgColor
    imgViewAccManager.layer.masksToBounds = true
    imgViewAccManager.clipsToBounds = true
  }
 
  func callWebServiceToGetTheAccountManagerInfo()
  {
    let finalUrl = kBaseUrl + kgetAccountManagerInfo + "/" + (UserDefaults.standard.object(forKey: kUserNameKey) as! String)
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrl, completion: {data,error in
      
      if data != nil
      {
        self.methodToHandelResponseOfAccountManagerInfoApi(data: data!)
      }
      else
      {
        print("Some error occured")
        self.methodToHandelResponseOfAccountManagerInfofailure(error: error!)
      }
      self.loader?.removeFromSuperview()
      self.loader = nil
    })
  }
 
  func methodToHandelResponseOfAccountManagerInfoApi(data:SwiftyJSON.JSON)
  {
    let status = data["Success"].stringValue
    if status.lowercased() == "true"
    {
      let jsonData = data["Data"].dictionaryValue
      let dictManager = jsonData["Manager"]?.dictionaryValue
      guard let dictManagerDetail = dictManager
      else {
        return
      }
      dataModelForAccountManager = DataModelForAccountManager(dictAccontManagerDetail : dictManagerDetail)
      
      loadTheImageAndChangeTheNameOfAccountManager()
      tblViewAccManager.isHidden = false
      tblViewAccManager.reloadData()
    }
    else
    {
      let errorcode = data["ErrorCode"].intValue
      switch errorcode
      {
      case ErrorCode.AlreadyUseCredential.rawValue:
        self.showTheAlertViewWithLoginButton(title: "Alert".localized(lang: languageCode, comment: ""), withMessage: data["Message"].stringValue, languageCode: languageCode)
      default:
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:data["Message"].stringValue, languageCode: languageCode)
      }
    }
  }
 
  func methodToHandelResponseOfAccountManagerInfofailure(error:NSError?)
  {
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  
  func loadTheImageAndChangeTheNameOfAccountManager()
  {
    lblAccManagerName.text = dataModelForAccountManager?.mngrName
    lblAccmanagerAddress.text = dataModelForAccountManager?.c_name
    if dataModelForAccountManager?.mngrImgUrl != ""
    {
      AlamoFireConnectivity.loadImageUsingAlamofireWith(url: (dataModelForAccountManager?.mngrImgUrl)!, completion: { (response) in
        if let image = response.result.value {
          print("image downloaded: \(image)")
          self.imgViewAccManager.image = image
        
        }
      })
    }
  }
  
  /*func makeCall(withPhoneNumber:String)
  {
    if let phoneCallURL = URL(string: "tel://"+withPhoneNumber)
    {
      let application:UIApplication = UIApplication.shared
      if (application.canOpenURL(phoneCallURL)) {
        if #available(iOS 10.0, *) {
          application.open(phoneCallURL, options: [:], completionHandler: nil)
        } else {
          application.openURL(phoneCallURL)
        }
      }
    }
  }*/

  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == KAccountManagerHelpSegue
    {
      let controller = segue.destination as! AccountManagerHelpViewController
      controller.title = "Sup_Contact".localized(lang: languageCode, comment: "") + " " + ((dataModelForAccountManager?.mngrName)!.components(separatedBy: " "))[0]
      
    }
  }
  
}

//MARK EXTENSION UitableviewDelegate and UitableViewDataSource
extension AccountManagerViewController: UITableViewDataSource,UITableViewDelegate
{
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    guard dataModelForAccountManager != nil
    else
    {
      return 0
    }
    switch section
    {
      case 0:
        return 1
      
      case 1:
        return 1
      
      case 2:
        return 2
      
      default:
        return 0
    }
    
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    switch section
    {
    case 0:
      return 0
    case 1:
      return 38
    case 2:
      return 38
    default:
      return 38
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier) as! HeaderTableViewCell
    headerCell.lblHeaderTitle.text = (arrHeaderTitle[section]).localized(lang: languageCode, comment: "")
    headerCell.isUserInteractionEnabled = false
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    
    let sectionNo = indexPath.section
    let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalRepresentative_Cell", for: indexPath) as! HomeBasicTableViewCell
   
    switch sectionNo
    {
    case 0:

      cell.lblHeaderTitle.text = (((dataModelForAccountManager?.aboutManager)!).utf8Data?.attributedString)?.string
    
      return cell
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "stringWithRegularCell", for: indexPath) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = "10360 USA Today Way"
      cell.lblDetailText.text = "Miramar FL 33025"
      let lblContactNo = cell.viewWithTag(1) as! UILabel
      lblContactNo.isHidden = true
      
      let imgViewRightArrow = cell.viewWithTag(2) as! UIImageView
      
      imgViewRightArrow.isHidden = true
      return cell
    
    case 2:
      if indexPath.row == 0
      {
         let cell = tableView.dequeueReusableCell(withIdentifier: "OfficeContact_Cell", for: indexPath) as! HomeBasicTableViewCell
        cell.lblHeaderTitle.text = "Office".localized(lang: languageCode, comment: "")
        cell.lblDetailText.text = (dataModelForAccountManager?.mngrOfficeContact)!
        return cell
      }
      else if indexPath.row == 1
      {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactNo_Cell", for: indexPath) as! HomeBasicTableViewCell
        if let managerName = dataModelForAccountManager?.mngrName
        {
          cell.lblHeaderTitle.text = "Sup_Contact".localized(lang: languageCode, comment: "") + " " + (managerName.components(separatedBy: " "))[0]
        }
        else
        {
          cell.lblHeaderTitle.text = "Sup_Contact".localized(lang: languageCode, comment: "")
        }
        return cell
      }
    
    default:
      return cell
    }
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    if indexPath.section == 2 && indexPath.row == 0
    {
      if let officeContactToShow = dataModelForAccountManager?.mngrOfficeContact
      {
        var officeContact = officeContactToShow
        if officeContact != ""
        {
         officeContact = officeContact.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
         officeContact = officeContact.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
         officeContact = officeContact.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
         officeContact = officeContact.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
          
          dialPhone(withDialTitle: officeContactToShow, contactNumber: officeContact, languageCode: languageCode)

        }
      }
    }
    else if indexPath.section == 2 && indexPath.row == 1
    {
      performSegue(withIdentifier: KAccountManagerHelpSegue, sender: self)
    }
  }
  
}


