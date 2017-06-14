//
//  AccountInfoViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 04/01/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccountInfoViewController: BaseViewController {
  
  var serviceDataSource:DataModelForServiceAccount?
  
  var listArray:[AccountInfo]?{
    didSet {
      self.tableView.reloadData()
    }
  }
  var loader: LoaderView?
  var headerCellIdentier = "HeaderCell"
  // Iboutlet
  @IBOutlet var tableView: UITableView!
  
  let userName:String! = "cindy1972@trashmail.com"//HotwireCommunicationApi.sharedInstance.createUserObject?.userName
  //data variables
  
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 04/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  override func viewDidLoad() {
    super.viewDidLoad()
    viewUpdateContentOnBasesOfLanguage()
    self.navigationController?.navigationBar.isHidden = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 50
    tableView.isHidden = true
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView()
    configureViewProperty()
    addNotificationObserver()
    
    setUpRightImageOnNavigationBar()
   
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    webServiceCallingToUpdateServiceAccountDetail()
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    DispatchQueue.main.async {
      self.configureViewProperty()
    }
  }
  //MARK:- Refresh view
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
    //methodToCreateViewList()
    self.title = "ServiceAccount".localized(lang: languageCode, comment: "")
  }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 04/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func configureViewProperty(){
    
    
  }
  /***********************************************************************************************************
   <Name> methodToCreateViewList </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to create a array list of object which is required to load the account list </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 04/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func methodToCreateViewList(){
    
    let localizedAccountNumber = "ServiceAccountNumber".localized(lang: languageCode, comment: "")
    let accountValue:String? = serviceDataSource?.account_number
    let accountInfo = AccountInfoCell.init(title:localizedAccountNumber, withSubText:accountValue, cellIdentifier: .HeaderWithDetailsRight)
    
    let localizedName = "ServiceAccountName".localized(lang: languageCode, comment: "")
    let nameVaue:String? = serviceDataSource?.name
    let accountHolderName = AccountInfoCell.init(title:localizedName, withSubText:nameVaue, cellIdentifier: .HeaderWithDetailsRight)
    
   // let localizedCurrentService  = "MyCurrentServices".localized(lang: languageCode, comment: "")
   // let accountService = AccountInfoCell.init(title:localizedCurrentService, withSubText:nil, cellIdentifier:.HeaderWithRightButton)
    
    let stateVaue:String? = serviceDataSource?.communityName
    
    var firstTwoCharacterOfState = ""
    
    if serviceDataSource?.addressState != nil {
      if ((serviceDataSource?.addressState?.characters.count))! >= 2{
        
        let index = stateVaue?.index((stateVaue?.startIndex)!, offsetBy: 2)
        firstTwoCharacterOfState = (stateVaue?.substring(to: index!))!.uppercased()
      }
    }
    
    var detailAddressValue:String? = ((serviceDataSource?.addressLine1)!)
    
    detailAddressValue = detailAddressValue?.appending(".")
    detailAddressValue = detailAddressValue?.appending((serviceDataSource?.addressLine2)!)
    detailAddressValue = detailAddressValue?.appending("\n")
    detailAddressValue = detailAddressValue?.appending((serviceDataSource?.addressCity)!)
    detailAddressValue = detailAddressValue?.appending(", ")
    detailAddressValue = detailAddressValue?.appending(firstTwoCharacterOfState)
//     detailAddressValue = detailAddressValue?.appending((serviceDataSource?.addressState)!)
    detailAddressValue = detailAddressValue?.appending(" ")
    detailAddressValue = detailAddressValue?.appending((serviceDataSource?.post_code)!)
    
    let serviceAddress = AccountInfoCell.init(title:stateVaue, withSubText: detailAddressValue, cellIdentifier: .HeaderWithDetailBotom)
    
    let localizedphoneNumber  = "PrimaryNumber".localized(lang: languageCode, comment: "")
    let phoneNumberValue:String? = serviceDataSource?.primay_number
    let phoneNumber = AccountInfoCell.init(title:localizedphoneNumber, withSubText:phoneNumberValue, cellIdentifier: .HeaderWithDetailsRight)
    
   // let localizedphoneNumber2  = "AddaSecondNumber".localized(lang: languageCode, comment: "")
   // let phoneNumber2 = AccountInfoCell.init(title:localizedphoneNumber2, withSubText:nil, cellIdentifier: .BlueColorHeader)
    
    let localizedEmail = "PrimaryEmail".localized(lang: languageCode, comment: "")
    let emailValue:String? = serviceDataSource?.primary_email
    let Email = AccountInfoCell.init(title:localizedEmail, withSubText:emailValue, cellIdentifier: .HeaderWithDetailsRight)
    
    
    //let localizedEmail2  = "AddaSecondEmail".localized(lang: languageCode, comment: "")
   // let Email2 = AccountInfoCell.init(title:localizedEmail2, withSubText:nil, cellIdentifier: .BlueColorHeader)
    
    
    let localizedServiceAddress = "SERVICEADDRESS".localized(lang: languageCode, comment: "")
    let listSection1 = AccountInfo.init(sectionHeading: localizedServiceAddress, withList: [accountHolderName!,accountInfo!], iconList: nil)
   // let localizedAccountService = "ACCOUNTSERVICES".localized(lang: languageCode, comment: "")
   // let listSection2 = AccountInfo.init(sectionHeading: localizedAccountService, withList: [accountService!], iconList: nil)
    
    
    let listSection3 = AccountInfo.init(sectionHeading: localizedServiceAddress, withList: [serviceAddress!], iconList: nil)
    
    let localizedACCOUNTCONTACTS = "ACCOUNTCONTACTS".localized(lang: languageCode, comment: "")
    let listSection6 = AccountInfo.init(sectionHeading: localizedACCOUNTCONTACTS, withList: [Email!,phoneNumber!], iconList: nil)
    listArray = [AccountInfo]()
    
    // listArray will contain only those element that are required for Phase 1
    // listArray? = [listSection1!, listSection2! ,listSection3!, listSection4!,listSection5!, listSection6!]
    listArray? = [listSection1!,listSection3!,listSection6!]
  }
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
   <Date>  04/01/17 </Date>
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
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: - web service
  
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
  func webServiceCallingToUpdateServiceAccountDetail(){
    var finalUrlToHit = kBaseUrl
    let formatedString = "Account/get_service_account_info/"
    
    finalUrlToHit = finalUrlToHit.appending(formatedString)
    finalUrlToHit = finalUrlToHit.appending(UserDefaults.standard.object(forKey: kUserNameKey) as! String)
    
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrlToHit, completion: {data,error in
      
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        self.methodToHandelServiceAccountDetailStatusSuccess(data: data!)
      }else{
        self.methodToHandelServiceAccountDetailStatusfailure(error: error)
      }
    })
  }
  
  func methodToHandelServiceAccountDetailStatusSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      // initialize serviceDataSource object and fill its value in tableview
      let jsonData = data["Data"].dictionaryValue
      let jsonService = jsonData["Service"]?.dictionaryValue
      
      let name = jsonService?["name"]?.stringValue
      let acccountNumber  = jsonService?["account_number"]?.stringValue
      let address1  = jsonService?["addressLine1"]?.stringValue
      let address2  = jsonService?["addressLine2"]?.stringValue
      let state  = jsonService?["addressState"]?.stringValue
      let city  = jsonService?["addressCity"]?.stringValue
      let postalCode  = jsonService?["post_code"]?.stringValue
      let email  = jsonService?["primary_email"]?.stringValue
      let mobile  = jsonService?["primay_number"]?.stringValue
      let community = jsonService?["msa_property"]?.stringValue
      
      serviceDataSource = DataModelForServiceAccount(name: name!, accountNumber: acccountNumber!, address1: address1!, address2: address2!, State: state!, City: city!, PostalCode: postalCode!, Email: email!, MobileNumber: mobile!,communityName: community!)
      
      
      methodToCreateViewList()
      tableView.isHidden = false
      self.tableView.reloadData()
      
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
  
  func methodToHandelServiceAccountDetailStatusfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  
}
// MARK: - Tableview delegate and data source
extension AccountInfoViewController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentier) as! HeaderTableViewCell
    let listObject:AccountInfo = listArray![section]
    headerCell.lblHeaderTitle.text = listObject.header
    return headerCell
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    if listArray == nil {
      return 0
    }
    return (listArray?.count)!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (listArray?.count)! != 0{
      let listObject:AccountInfo = listArray![section]
      if listObject.subList != nil{
        return (listObject.subList?.count)!
      }}
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let listObject:AccountInfo = listArray![indexPath.section]
    let sublistObject:AccountInfoCell = listObject.subList![indexPath.row]
    
    switch sublistObject.cellIdentifierType {
    case cellIdentifier.BlueColorHeader?,.HeaderWithRightButton?:
      let cell = tableView.dequeueReusableCell(withIdentifier: (sublistObject.cellIdentifierType?.rawValue)!) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      return cell
    case .HeaderWithDetailBotom?,.HeaderWithDetailsRight?:
      let cell = tableView.dequeueReusableCell(withIdentifier: (sublistObject.cellIdentifierType?.rawValue)!) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitle
      return cell
    default:
      return UITableViewCell()
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section > 0{
      return 38
    }
    return 0
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let listObject:AccountInfo = listArray![indexPath.section]
    let sublistObject:AccountInfoCell = listObject.subList![indexPath.row]
    switch sublistObject.cellIdentifierType {
    case .BlueColorHeader?,.HeaderWithRightButton?,.HeaderWithDetailsRight?:
      return 52
    case cellIdentifier.HeaderWithDetailBotom?:
      return UITableViewAutomaticDimension
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  
}

