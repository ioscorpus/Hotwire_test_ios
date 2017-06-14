//
//  TV_ChannelLineUpViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 11/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class TV_ChannelLineUpViewController: BaseViewController
{
  @IBOutlet var tblViewChannelList: UITableView!
  var loader : LoaderView?
  var selectedTitle  : String?
  var strPkgID : String?
  var isAdditionalClicked = false
		
  
  fileprivate var dataModelForChannelLineUpPackage : DataModelForChannelLineUpPackage?
  fileprivate var arrChannelLineUpPkgList : [DataModelForChannelLineUpPackage] = []
  fileprivate var arrAdditionalChannelLineUpPkgList : [DataModelForChannelLineUpPackage] = []
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    viewUpdateContentOnBasesOfLanguage()
    backButtonWithOutTitle()
    self.navigationItem.backBarButtonItem?.title = ""
    setUpRightImageOnNavigationBar()
    tblViewChannelList.isHidden = true
    callWebServiceToGetChannePkglList()
  }
  override func viewWillAppear(_ animated: Bool)
  {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
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
 
  func viewUpdateContentOnBasesOfLanguage()
  {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    
    self.title = "TV_channelLineUp".localized(lang: languageCode, comment: "")
  }
  
  //MARK: WebServiceCall
  func callWebServiceToGetChannePkglList()
  {
    let finalUrl = kBaseUrl + KGetChannelLineUpPackage + "/" + "507"
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrl, completion: {data,error in
      
      if data != nil
      {
        self.methodToHandelResponseOfChannelLineUpPackage(data: data!)
      }
      else
      {
        print("Some error occured")
        self.methodToHandelResponseOfChannelLineUpPackageFailure(error: error!)
      }
      self.loader?.removeFromSuperview()
      self.loader = nil
    })
  }
  
  //MARK: Handle WebService Success Response
  func methodToHandelResponseOfChannelLineUpPackage(data:SwiftyJSON.JSON)
  {
    let status = data["Success"].stringValue
    if status.lowercased() == "true"
    {
      let jsonData = data["Data"].dictionaryValue
      let arrPkgList = jsonData["packages"]?.arrayValue
      guard let arrManagerDetail = arrPkgList
        else
      {
        return
      }
      for dictDetail in arrManagerDetail
      {
        dataModelForChannelLineUpPackage = DataModelForChannelLineUpPackage(dictPkgDetail: dictDetail.dictionaryValue)
        
        if (dataModelForChannelLineUpPackage?.package_Id.contains("D")) != nil&&(dataModelForChannelLineUpPackage?.package_Id.characters.count)!>1
        {
          arrAdditionalChannelLineUpPkgList.append(dataModelForChannelLineUpPackage!)
        }
        else
        {
          if dataModelForChannelLineUpPackage?.package_Id != "D"
          {
            arrChannelLineUpPkgList.append(dataModelForChannelLineUpPackage!)

          }
        }
        
      }
      tblViewChannelList.isHidden = false
      tblViewChannelList.reloadData()
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
  
   //MARK: Handle WebService Failure Response
  func methodToHandelResponseOfChannelLineUpPackageFailure(error:NSError?)
  {
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  func additionalChannelBtnClicked(_ sender: UITapGestureRecognizer)
  {
    if isAdditionalClicked == true
    {
      isAdditionalClicked = false
    }
    else
    {
      isAdditionalClicked = true
    }
    tblViewChannelList.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
      if segue.identifier == KTV_ChannelTypeSegue
      {
        let controller = segue.destination as! TV_ChannelTypeViewController
        controller.title = selectedTitle!
        controller.strPkgID = strPkgID!
        controller.strProperty_Code = "507"
      }
      else if segue.identifier == KTV_AdditionalChannelListSegue
      {
        let controller = segue.destination as! TV_AdditionalChannelListViewController
        controller.title = selectedTitle!
        controller.strPkgID = strPkgID!
        controller.strProperty_Code = "507"
      }
  }
 }

//MARK: TableViewDataSource
extension TV_ChannelLineUpViewController : UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if isAdditionalClicked == true
    {
      if section == 0
      {
        if !(arrChannelLineUpPkgList.isEmpty)
        {
          return (arrChannelLineUpPkgList.count)
        }
        return 0
      }
      else
      {
        return arrAdditionalChannelLineUpPkgList.count
      }
      
    }
    else
    {
      if section == 0
      {
        if !(arrChannelLineUpPkgList.isEmpty)
        {
          return (arrChannelLineUpPkgList.count)
        }
        return 0
      }
      else
      {
        return 0
      }
    }
    
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelLineUp_Cell", for: indexPath) as! HomeBasicTableViewCell
    let lblPlus = cell.viewWithTag(1) as! UILabel
    lblPlus.isHidden = true
    
    let imgRightArrow = cell.viewWithTag(2) as! UIImageView
    imgRightArrow.isHidden = false
    
    if indexPath.section == 0
    {
      cell.lblHeaderTitle.text = (arrChannelLineUpPkgList[indexPath.row]).package_Name
      cell.constraintLeading.constant = 5
    }
    else
    {
       cell.lblHeaderTitle.text = (arrAdditionalChannelLineUpPkgList[indexPath.row]).package_Name
       cell.constraintLeading.constant = 10
    }
    return cell
  }
  
}

//MARK: TableViewDelegate
extension TV_ChannelLineUpViewController : UITableViewDelegate
{
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    if section == 0
    {
      return 38
    }
    else
    {
      return 52
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    if section == 0
    {
      let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier) as! HeaderTableViewCell
      headerCell.lblHeaderTitle.text = "CHANNEL PACKEGES"
      headerCell.isUserInteractionEnabled = false
      return headerCell
    }
    else
    {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelLineUp_Cell") as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = "Additional Channels"
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.additionalChannelBtnClicked(_:)))
      cell.addGestureRecognizer(tapGesture)
      let lblPlus = cell.viewWithTag(1) as! UILabel
      lblPlus.isHidden = false
      
      let imgRightArrow = cell.viewWithTag(2) as! UIImageView
      imgRightArrow.isHidden = true
      if isAdditionalClicked == true
      {
        lblPlus.text = "-"
      }
      else
      {
        lblPlus.text = "+"
      }
      return cell
    }
    
    
  }
 
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    
      if indexPath.section == 0
      {
        selectedTitle = (arrChannelLineUpPkgList[indexPath.row]).package_Name
        strPkgID = (arrChannelLineUpPkgList[indexPath.row]).package_Id
        self.performSegue(withIdentifier: KTV_ChannelTypeSegue, sender: nil)
      }
      else
      {
        selectedTitle = (arrAdditionalChannelLineUpPkgList[indexPath.row]).package_Name
        strPkgID = (arrAdditionalChannelLineUpPkgList[indexPath.row]).package_Id
        self.performSegue(withIdentifier: KTV_AdditionalChannelListSegue, sender: nil)
      }

   }
}
