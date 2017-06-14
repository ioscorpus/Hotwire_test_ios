//
//  ContactInfoViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 10/01/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactInfoViewController:BaseViewController {
  
  var userDataSource:DataModelForUserAccount?
  var loader: LoaderView?
  var listArray:[BillingInfo]?{
    didSet {
      self.tableView.reloadData()
    }
  }
  var callWebServiceAgain = true
  var headerCellIdentier = "HeaderCell"
  // Iboutlet
  @IBOutlet var tableView: UITableView!
  
  let userName:String! = UserDefaults.standard.object(forKey: kUserNameKey) as! String!
  //data variables
  
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 10/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView()
    tableView.isHidden = true
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    configureViewProperty()
    addNotificationObserver()
    viewUpdateContentOnBasesOfLanguage()
    setUpRightImageOnNavigationBar()
   
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
  
  override func viewDidAppear(_ animated: Bool)
  {
    super.viewDidAppear(animated)
    
    if callWebServiceAgain == true
    {
      webServiceCallingToUpdateUserAccountDetail()
    }
    
    
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
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
   <Date> 10/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    methodToCreateViewList()
    self.title = "UserAccountTitle".localized(lang: languageCode, comment: "")
  }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 10/01/17 </Date>
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
   <Date> 10/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func methodToCreateViewList(){
    let nameTitle = "NameTitle".localized(lang: languageCode, comment: "")
    
    let nameValue = userDataSource?.name
    let name = BillingInfoCell.init(title: nameTitle, withSubTextOne: nameValue, cellIdentifier: cellIdentifier.HeaderWithDetailBotom)
    
    
    
    let displayNameTitle = "DisplayNameTitle".localized(lang: languageCode, comment: "")
    let listSection1 = BillingInfo.init(sectionHeading: displayNameTitle, withList: [name!], iconList: nil)
    
    let logInTitle = "LogInSectionTitle".localized(lang: languageCode, comment: "")
    let UsernameTitle = "UsernameTitle".localized(lang: languageCode, comment: "")
    
    let userNameValue = userDataSource?.userName
    let userName = BillingInfoCell.init(title: UsernameTitle, withSubTextOne: userNameValue, cellIdentifier: cellIdentifier.HeaderWithDetailBotom)
    
    
    var passwordDetailValue = userDataSource?.passwordDetail
    
    if passwordDetailValue != nil
    {
      passwordDetailValue = "Last Changed :"
      passwordDetailValue = passwordDetailValue?.appending((userDataSource?.passwordDetail)!)
    }
    
    
    let passwordTitle = "PasswordTitle".localized(lang: languageCode, comment: "")
    let password = BillingInfoCell.init(title: passwordTitle, withSubTextOne: passwordDetailValue, cellIdentifier: cellIdentifier.HeaderWithDetailBotom)
    let listSection2 = BillingInfo.init(sectionHeading: logInTitle, withList: [userName!,password!], iconList: nil)
    
    let varifiedText = "VerifiedText".localized(lang: languageCode, comment: "")
    let notVerifiedText = "NotVerifiedText".localized(lang: languageCode, comment: "")
    
    var verificationCode:String?
    if userDataSource?.isEmailVerified == "1"{
      verificationCode = varifiedText
    }
    else
    {
      verificationCode = notVerifiedText
    }
    
    let emailTitle = "EmailTitle".localized(lang: languageCode, comment: "")
    let userEmailValue = userDataSource?.email
    let email = BillingInfoCell.init(title:emailTitle, withSubTextOne: userEmailValue, withSubTextTwo: verificationCode, cellIdentifier: cellIdentifier.RegularWithTwoDetailText)
    
    if userDataSource?.isMobileVerified == "1"{
      verificationCode = varifiedText
    }
    else
    {
      verificationCode = notVerifiedText
    }
    
    let phoneTitle = "PhoneTitle".localized(lang: languageCode, comment: "")
    
    let phoneValue = userDataSource?.number
    let Phone = BillingInfoCell.init(title: phoneTitle, withSubTextOne: phoneValue, withSubTextTwo: verificationCode, cellIdentifier: cellIdentifier.RegularWithTwoDetailText)
    
    let descriptionValue = "DescriptionValueInUserAccount".localized(lang: languageCode, comment: "")
    let description = BillingInfoCell.init(title: descriptionValue, cellIdentifier: cellIdentifier.CellWithDetailDescription)
    let accountRecoveryTitle = "ACCOUNTRECOVERYTitle".localized(lang: languageCode, comment: "")
    let listSection3 = BillingInfo.init(sectionHeading: accountRecoveryTitle, withList: [email!,Phone!,description!], iconList: nil)
    
    
    let legalSectionTitle = "LEGALSECTIONTITLE".localized(lang: languageCode, comment: "")
    let privacyPolicyTitle = "Privacy_Policy".localized(lang: languageCode, comment: "")
    let privacyPolicy = BillingInfoCell.init(title: privacyPolicyTitle, withCellIdentifier: cellIdentifier.CellWithDetailAndDetailDisclousre)
    let termsOfUseTitle = "Terms_of_use".localized(lang: languageCode, comment: "")
    let termsOfUse = BillingInfoCell.init(title: termsOfUseTitle, withCellIdentifier: cellIdentifier.CellWithDetailAndDetailDisclousre)
    
    let listSetction4 = BillingInfo.init(sectionHeading: legalSectionTitle, withList: [privacyPolicy!,termsOfUse!], iconList: nil)
    
    listArray = [BillingInfo]()
    listArray? = [listSection1!,listSection2!,listSection3!,listSetction4!]
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
  func webServiceCallingToUpdateUserAccountDetail(){
    var finalUrlToHit = kBaseUrl
    let formatedString = "Account/get_user_account_info/"
    
    finalUrlToHit = finalUrlToHit.appending(formatedString)
    finalUrlToHit = finalUrlToHit.appending(UserDefaults.standard.object(forKey: kUserNameKey) as! String)
    
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrlToHit, completion: {data,error in
      
      if data != nil{
        self.methodToHandelUserAccountDetailStatusSuccess(data: data!)
      }else{
        self.methodToHandelUserAccountDetailStatusfailure(error: error)
      }
      self.loader?.removeFromSuperview()
      self.loader = nil
    })
  }
  
  func methodToHandelUserAccountDetailStatusSuccess(data:JSON) {
    //print(data)
    let status = data["Success"].stringValue
    if(status.lowercased() == "true"){
      print("sucess")
      // initialize serviceDataSource object and fill its value in tableview
      
      let jsonData = data["Data"].dictionaryValue
      let jsonUser = jsonData["UserAccount"]?.dictionaryValue
      
      let name = jsonUser?["name"]?.stringValue
      let lastPasswordReset = jsonUser?["last_pwd_reset"]?.stringValue
      let email = jsonUser?["email"]?.stringValue
      let number = jsonUser?["number"]?.stringValue
      let phone_verified = jsonUser?["phone_verified"]?.stringValue
      let email_verified = jsonUser?["email_verified"]?.stringValue
      
      userDataSource = DataModelForUserAccount(name: name!, email: email!, number: number!, passwordDetail: lastPasswordReset!, isMobileVerifed: phone_verified!, isEmailVerified: email_verified!,userName:UserDefaults.standard.object(forKey: kUserNameKey) as? String)
      
      methodToCreateViewList()
      tableView.isHidden = false
      self.tableView.reloadData()
      
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
  
  func methodToHandelUserAccountDetailStatusfailure(error:NSError?){
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
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
   <Date>  10/01/17 </Date>
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
  
}
// MARK: - Tableview delegate and data source
extension ContactInfoViewController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentier) as! HeaderTableViewCell
    let listObject:BillingInfo = listArray![section]
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
      let listObject:BillingInfo = listArray![section]
      if listObject.subList != nil{
        return (listObject.subList?.count)!
      }}
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let listObject:BillingInfo = listArray![indexPath.section]
    let sublistObject:BillingInfoCell = listObject.subList![indexPath.row]
    
    switch sublistObject.cellIdentifierType {
    case cellIdentifier.RegularWithTwoDetailText?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      cell.lblTwoDetailText.text = sublistObject.cellDetailTitleTwo
      return cell
    case .CellWithoutDetail?,.BlueColorHeader?,.HeaderWithRightButton?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      return cell
    case .BlueTextWithDetail?,.HeaderWithDetailBotom?,.HeaderWithDetailsRight?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      return cell
      
    case .CellWithDetailDescription?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      print(sublistObject.cellTitle!)
      return cell
    
    case .CellWithDetailAndDetailDisclousre?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      print(sublistObject.cellTitle!)
      return cell
      
    default:
      return UITableViewCell()
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 38
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let listObject:BillingInfo = listArray![indexPath.section]
    let sublistObject:BillingInfoCell = listObject.subList![indexPath.row]
    switch sublistObject.cellIdentifierType {
    case .BlueColorHeader?,.HeaderWithRightButton?,.HeaderWithDetailsRight?,.CellWithoutDetail?,.BlueTextWithDetail?:
      return 52
    case cellIdentifier.HeaderWithDetailBotom?:
      return UITableViewAutomaticDimension
    case cellIdentifier.RegularWithTwoDetailText?,cellIdentifier.CellWithDetailDescription?:
      return 65
    case .CellWithDetailAndDetailDisclousre?:
      return 52
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if(!(indexPath.row == 2 && indexPath.section == 2 ))
    {
      if indexPath.section != 3
      {
        callWebServiceAgain = true
        if getTimeDifferenceBetweenLoginTimeAndCurrentTime(loginDate: UserDefaults.standard.object(forKey: "loginTime") as! Date).1
        {
            switch(indexPath.section){
            case 0:
              let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
              let mainViewController = storyboard.instantiateViewController( withIdentifier: "SignUpEnterYouNameViewController")
              self.navigationController?.pushViewController(mainViewController, animated: true)
              break;
            case 1:
              switch(indexPath.row)
              {
              case 0:
                let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: "UserNameViewController") as! UserNameViewController
                mainViewController.userName = (self.userDataSource?.email)!
                mainViewController.isAfterLogin = true
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
              case 1:
                let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: kSegue_UpdatePassword) as! ResetPasswordViewController
                mainViewController.isAfterLogin = true
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
                
              default:
                break;
              }
              
            case 2:
              switch(indexPath.row){
              case 0:
                let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_emailVarification) as! LoginEmailVerificationViewController
                mainViewController.isAlreadyLogin = true
                
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
              case 1:
                let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
                mainViewController.isAfterLogin = true
                
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
              default:
                break;
              }
              break
            default: break
            }
     

        }
        else
        {
          showAuthenticationAlert {
            switch(indexPath.section){
            case 0:
              let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
              let mainViewController = storyboard.instantiateViewController( withIdentifier: "SignUpEnterYouNameViewController")
              self.navigationController?.pushViewController(mainViewController, animated: true)
              break;
            case 1:
              switch(indexPath.row){
              case 0:
                let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: "UserNameViewController") as! UserNameViewController
                mainViewController.userName = (self.userDataSource?.email)!
                mainViewController.isAfterLogin = true
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
              case 1:
                let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: kSegue_UpdatePassword) as! ResetPasswordViewController
                mainViewController.isAfterLogin = true
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
                
              default:
                break;
              }
              
            case 2:
              switch(indexPath.row){
              case 0:
                let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_emailVarification) as! LoginEmailVerificationViewController
                mainViewController.isAlreadyLogin = true
                
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
              case 1:
                let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
                let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
                mainViewController.isAfterLogin = true
                
                self.navigationController?.pushViewController(mainViewController, animated: true)
                break;
              default:
                break;
              }
              break
            default: break
            }
          }

        }
      }
      else if indexPath.section == 3
      {
        let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
        let termsAndConditionController = storyboard.instantiateViewController(withIdentifier: "TermAndCondition") as! TermAndConditonPopUpViewController
       
        callWebServiceAgain = false
        
        if indexPath.row == 0
        {
          termsAndConditionController.termAndCondition = false
        }
        else if indexPath.row == 1
        {
          termsAndConditionController.termAndCondition = true
        }
        
       let navController = UINavigationController.init(rootViewController: termsAndConditionController)
        self.navigationController?.present(navController, animated: true, completion: nil)
      }

    }
      }
}
