//
//  AccountManagerHelpViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 19/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccountManagerHelpViewController: BaseViewController
{
    @IBOutlet var tblViewAccManagerHelp: UITableView!
    @IBOutlet var lblHelp: UILabel!
  
    var listForContactOrAccountManager = ""
    var strIssue : String = ""
    var strIssueCode : String = ""
    var loader: LoaderView?
  
    fileprivate var dataModelForAccountManager : DataModelForContactUsListAccManagerHelp?
    fileprivate var arrContactUsHelpList : [DataModelForContactUsListAccManagerHelp] = []
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewUpdateContentOnBasesOfLanguage()
        tblViewAccManagerHelp.estimatedRowHeight = 38
        tblViewAccManagerHelp.rowHeight = UITableViewAutomaticDimension
        tblViewAccManagerHelp.isHidden = true
        callWebServiceToGetContactUsList()
        setUpBackButonOnLeft()
        backButtonWithOutTitle()
    }
  
  func setUpBackButonOnLeft()
  {
    self.navigationItem.setHidesBackButton(true, animated:true);
    let backBtn = UIBarButtonItem(image: UIImage(named: "RedBackBtn"), style: .plain, target: self, action: #selector(AccountManagerHelpViewController.backButtonTappedAction(_:)))
    self.navigationItem.leftBarButtonItem = backBtn

  }
  func backButtonTappedAction(_ sender : UIButton)
  {
    self.navigationController!.popViewController(animated: true)
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

  override func didReceiveMemoryWarning()
  {
      super.didReceiveMemoryWarning()
  }
  
  func viewUpdateContentOnBasesOfLanguage()
  {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    if listForContactOrAccountManager == "Contact_Us"
    {
       lblHelp.text = "Sup_Contact_Help".localized(lang: languageCode, comment: "")
    }
    else
    {
      lblHelp.text = "Sup_Help".localized(lang: languageCode, comment: "")
    }
    
  }
  
  //MARK: WebService Call To Get ContactUs List
  func callWebServiceToGetContactUsList()
  {
    let finalUrl = kBaseUrl + kGetContactUsList + "/" + (UserDefaults.standard.object(forKey: kUserNameKey) as! String)
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrl, completion: {data,error in
      
      if data != nil
      {
        self.methodToHandelResponseOfContactUsApiList(data: data!)
      }
      else
      {
        print("Some error occured")
        self.methodToHandelResponseOfContactUsApiListFailure(error: error!)
      }
      self.loader?.removeFromSuperview()
      self.loader = nil
    })
  }
  
  func methodToHandelResponseOfContactUsApiList(data:SwiftyJSON.JSON)
  {
    let status = data["Success"].stringValue
    if status.lowercased() == "true"
    {
      let jsonData = data["Data"].dictionaryValue
      let arrHelpList = jsonData["manager_contact"]?.arrayValue
      guard let arrManagerDetail = arrHelpList
      else
      {
          return
      }
      for dictHlpDetail in arrManagerDetail
      {
        dataModelForAccountManager = DataModelForContactUsListAccManagerHelp(dictHelpDetail: dictHlpDetail.dictionaryValue)

        if listForContactOrAccountManager == "Contact_Us"
        {
          arrContactUsHelpList.append(dataModelForAccountManager!)
        }
        else
        {
          if dataModelForAccountManager?.strIssueType != "CONTACTACCOUNTMANAGER"
          {
            arrContactUsHelpList.append(dataModelForAccountManager!)
          }

          
        }
       
      }
      tblViewAccManagerHelp.isHidden = false
      tblViewAccManagerHelp.reloadData()
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
  
  func methodToHandelResponseOfContactUsApiListFailure(error:NSError?)
  {
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }



  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if segue.identifier == KContactAccManagerSegue
      {
        let controller = segue.destination as! ContactAccManagerViewController
        controller.title = self.title
        controller.strIssue = strIssue
        controller.strIssueCode = strIssueCode
        controller.isFromConact = listForContactOrAccountManager
      }
    }
 

}

//MARK EXTENSION UitableviewDelegate and UitableViewDataSource
extension AccountManagerHelpViewController: UITableViewDataSource,UITableViewDelegate
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return arrContactUsHelpList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
     let cell = tableView.dequeueReusableCell(withIdentifier: KAccountManagerHelp_Cell, for: indexPath) as! HomeBasicTableViewCell
    cell.lblHeaderTitle.text = (arrContactUsHelpList[indexPath.row]).strServiceType
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    strIssue = (arrContactUsHelpList[indexPath.row]).strServiceType
    strIssueCode = (arrContactUsHelpList[indexPath.row]).strIssueType
    if strIssueCode == "CONTACTACCOUNTMANAGER"
    {
      performSegue(withIdentifier: KAccountManagerSegue, sender: self)
    }
    else
    {
       performSegue(withIdentifier: KContactAccManagerSegue, sender: self)
    }
   
  }
  
}

