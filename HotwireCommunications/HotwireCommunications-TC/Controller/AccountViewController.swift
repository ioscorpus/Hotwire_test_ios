//
//  WhatNewViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 16/11/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import PKCCrop
import PKCCheck
import SwiftyJSON
// import SynacorCloudId
protocol UserDetailsViewControllerDelegate: class {
  func userDetailsViewControllerDidRequestLogout(viewController: AccountViewController)
}
class AccountViewController: BaseViewController {
  var listArray:[listSection]?{
    didSet {
      self.tableView.reloadData()
    }
  }
  var loader: LoaderView?
  let pkcCrop = PKCCrop()
  @IBOutlet var tableView: UITableView!
  var profilePicImageView:UIImageView! = nil
  // cell identifier
  var headerReuseIdentifier = "HeaderCell"
  var cellReuseIdentifier = "RegularCell"
  var cellwithStringReuseIdentifier = "stringWithRegularCell"
  var cellWithMessageNotification = "BillNotification"
  var cellWithProfilePicture =  "ProfilePicture"
  // user credential
  var userName:String = "William Nye"
  var userAddress:String = "BRICKELL CITY CENTRE"
  var userProfilePicture:UIImage = UIImage(named:"Placeholder")!
  weak var delegate: UserDetailsViewControllerDelegate?
  
  // picker controller
  let picker = UIImagePickerController()
  var profilePicture:UIImage?
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 17/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = false
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    setUpImageOnNavigationBarCenterTitle()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableViewAutomaticDimension
    picker.delegate = self
    pkcCrop.delegate = self
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
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureViewProperty()
    addNotificationObserver()
    viewUpdateContentOnBasesOfLanguage()
    if(UserDefaults.standard.object(forKey: kProfilePicName) != nil){
    AlamoFireConnectivity.loadImageUsingAlamofireWith(url: UserDefaults.standard.object(forKey: kProfilePicName) as! String, completion: { (response) in
      if let image = response.result.value {
        print("image downloaded: \(image)")
        self.profilePicture = image
        self.tableView.reloadData()
      }
    })
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
   <Date>  17/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    methodToCreateViewList()
    //     lblTitle.text = "Account".localized(lang: languageCode, comment: "")
    
  }
  
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  17/11/16 </Date>
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
   <Date> 16/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func methodToCreateViewList(){
    //  let userAccountList = ["Log In & Security","Contact Info","Family Members"]
    //  let serviceAccount = ["News & Messages","Pay Bill","Bill Details & History","Billing Preferences"]
    //  let serviceLocationSubHeading = "Pelican Landing"
    //  let serviceLocationDetail = " 1267 Blue Jay Way \n Naples, Fl 12345 \n Account #1765432"
    //  let appSetting  = ["Language", "Notifications"]
    //  let legalInfo = ["Privacy Policy", "Terms of Use","Log Out"]
    //
    
    
    
    let localizedProfileTitle = "ProfilePictureTitle".localized(lang: languageCode, comment: "")
    let profile = [localizedProfileTitle]
    
    let localizedPayBill = "PayBillTitle".localized(lang: languageCode, comment: "")
    let localizedMessages = "MessagesTitle".localized(lang: languageCode, comment: "")
    
    let billNotificatin = [localizedPayBill,localizedMessages]
    
    let localizedbillManagement = "BillingInfoTitle".localized(lang: languageCode, comment: "")
    let billManagement = [localizedbillManagement]
    
    
    let localizedServiceAccount = "ServiceAccountTitle".localized(lang: languageCode, comment: "")
    let localizedUserAccount = "UserAccountTitle".localized(lang: languageCode, comment: "")
    let accountManagement = [localizedServiceAccount,localizedUserAccount] // ["Account Info","Sign In & Security","Contact Info","Family Members"] will not used in phase 1
    
    let localizedLanguage = "LanguageTitle".localized(lang: languageCode, comment: "")
    let localizedNotifications = "NotificationsTitle".localized(lang: languageCode, comment: "")
    let localizedSignOut = "SignOutTitle".localized(lang: languageCode, comment: "")
    
    
    
    let appSettingContent = [localizedLanguage,localizedNotifications,localizedSignOut]
    
    let billManagementIcons = ["billingInfoIcon"]
    let accountManagementIcons = ["Service","acctNumIcon"]//["acctNumIcon", "securityIcon", "infoIcon", "familyIcon"] will not used in phase 1
    let appSettingContentIcons = ["languageIcon", "notificationsIcon", "signOutIcon"]
    
    
    let localizedlistSection1 = "USERPROFILETitle".localized(lang: languageCode, comment: "")
    let listSection1 = listSection.init(sectionHeading:localizedlistSection1 , withList: profile, detailText:nil)
    
   // let localizedlistSection2 = "billNotificatinTitle".localized(lang: languageCode, comment: "")
    let listSection2 = listSection.init(sectionHeading:"billNotificatin", detailText:(billNotificatin[0],billNotificatin[1]))
    
    let localizedlistSection3 = "BILLMANAGEMENTTitle".localized(lang: languageCode, comment: "")
    let listSection3 = listSection.init(sectionHeading: localizedlistSection3, withList: billManagement, iconList: billManagementIcons)
    
    let localizedlistSection4 = "ACCOUNTMANAGEMENTTitle".localized(lang: languageCode, comment: "")
    let listSection4 = listSection.init(sectionHeading: localizedlistSection4, withList: accountManagement, iconList: accountManagementIcons)
    
    let localizedlistSection5 = "APPSETTINGSTitle".localized(lang: languageCode, comment: "")
    let listSection5 = listSection.init(sectionHeading: localizedlistSection5, withList: appSettingContent, iconList: appSettingContentIcons)
    listArray = [listSection]()
    listArray? = [listSection1, listSection2 ,listSection3, listSection4,listSection5]
  }
  
  // MARK: - Navigation
  /***********************************************************************************************************
   <Name> prepareForSegue </Name>
   <Input Type> UIStoryboardSegue,AnyObject </Input Type>
   <Return> void </Return>
   <Purpose> method call when segue called  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  16/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }
  //MARK:- ADD notification
  /***********************************************************************************************************
   <Name> addNotificationObserver </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication come to foreground and update selected languge </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>   16/11/16 </Date>
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
extension AccountViewController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier) as! HeaderTableViewCell
    let listObject:listSection = listArray![section]
    headerCell.lblHeaderTitle.text = listObject.header
    //headerTitle.localized(lang: languageCode, comment: "")
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
      let listObject:listSection = listArray![section]
      if listObject.subList != nil{
        return (listObject.subList?.count)!
      }}
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let listObject:listSection = listArray![indexPath.section]
    if indexPath.section == 0{
      let cell = tableView.dequeueReusableCell(withIdentifier: cellWithProfilePicture) as! ProfilePictureTableViewCell
      if(UserDefaults.standard.object(forKey: kUserId) != nil){
        
        
       
        cell.lblUserName.text = UserDefaults.standard.object(forKey: kFirstName) as! String+" "+(UserDefaults.standard.object(forKey: kLastName) as! String)
        //cell.lblUserAddress.text = UserDefaults.standard.object(forKey: kAddress1) as! String+" "+(UserDefaults.standard.object(forKey: kAddress2) as! String)
        cell.lblUserAddress.text = UserDefaults.standard.object(forKey: kCommunityName) as! String
      }else{
      cell.lblUserName.text = userName
      cell.lblUserAddress.text = userAddress
      }
      cell.delegate = self
      if profilePicture != nil{
        cell.profilePicImgview.image = profilePicture
      }
      profilePicImageView = cell.profilePicImgview
      cell.selectionStyle = .none
      return cell
    }else if listObject.subList == nil{
      let cell = tableView.dequeueReusableCell(withIdentifier: cellWithMessageNotification) as! BillNotificationTableViewCell
      cell.lblIndexOneTitle.text = listObject.subStringHeaderOne
      cell.lblIndexTwoTitle.text = listObject.subStringHeaderTwo
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeBasicTableViewCell
      if indexPath.section == 4 && indexPath.row == 2{
        cell.lblHeaderTitle.textColor = kColor_LogoutButton
        cell.accessoryType = .none
      }else{
        cell.lblHeaderTitle.textColor = kColor_GrayColor
        cell.accessoryType = .disclosureIndicator
      }
      cell.lblHeaderTitle.text = listObject.subList![indexPath.row]
      cell.iconImageView.image = UIImage(named:listObject.subIconList![indexPath.row])!
      cell.lblDetailText?.text = ""
      return cell
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section > 1{
      return 38
    }
    return 0
  }
  
  /***********************************************************************************************************
   <Name>  tableView heightForRowAt  </Name>
   <Input Type>  tableView,indexPath   </Input Type>
   <Return> CGFloat </Return>
   <Purpose> Calculate the height of tableView Cell , edited part is to return 0 when sublist is nil as it is not required in phase 1</Purpose>
   <History>
   <Header> Version 2.0 </Header>
   <Date> 03/03/17 </Date>
   <Author>Nirbhay Singh<Author/>
   </History>
   ***********************************************************************************************************/
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let listObject:listSection = listArray![indexPath.section]
    
    if indexPath.section == 4{
      if indexPath.row == 1{
        return 0
      }
    }
    
    if indexPath.section == 0{
      return 200
    }else if listObject.subList == nil{
      if indexPath.row == 0 {
        return 0
      }
      return 113
    }
    return 52
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("No action on \(indexPath.section) section and \(indexPath.row) row")
    switch indexPath.section {
    case 2:
      self.performSegue(withIdentifier: kSegue_BillingInfo, sender: self)
    case 3:
      switch indexPath.row {
      case 0:
        self.performSegue(withIdentifier: kSegue_AccountInfoScreen, sender: self)
      case 1:
        self.performSegue(withIdentifier: kSegue_ContactInfo, sender: self)
     /* case 2:
        self.performSegue(withIdentifier: kSegue_ContactInfo, sender: self)
      case 3:
        self.performSegue(withIdentifier: kSegue_FamilyMember, sender: self)
        */
      default:
        print("No action on \(indexPath.section) section and \(indexPath.row) row")
      }
    case 4:
      switch indexPath.row {
      case 0:
        self.performSegue(withIdentifier: kSegue_LanguageScreen, sender: self)
      case 2:
        let signOutAlert = UIAlertController(title: "SignOutTitleForLogOut".localized(lang: languageCode, comment: ""), message: "SignOutContent".localized(lang: languageCode, comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized(lang: languageCode, comment: ""), style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
          signOutAlert.dismiss(animated: true, completion: {
            
          })
        })
        signOutAlert.addAction(cancelAction)
        let signOutAction = UIAlertAction(title: "SignOutButtonTitle".localized(lang: languageCode, comment: ""), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
          self.signOutApp()
        })
        signOutAlert.addAction(signOutAction)
        self.navigationController?.present(signOutAlert, animated: true, completion: {
          
        })
      default:
        print("No action on \(indexPath.section) section and \(indexPath.row) row")
      }
    default:
      print("No action on \(indexPath.section) section and \(indexPath.row) row")
    }
  }
  
  func signOutApp() {
   // HotwireCommunicationApi.sharedInstance.cloudId?.clearKeychain()
    for key in UserDefaults.standard.dictionaryRepresentation().keys {
      UserDefaults.standard.removeObject(forKey: key.description)
    }
    UserDefaults.standard.removeObject(forKey: "loginTime")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storyboard = UIStoryboard(name:kStoryBoardMain, bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_LoginPage) as! LoginSynacoreViewController
    //  mainViewController.transitioningDelegate = self
    DispatchQueue.main.async() {
      self.delegate = mainViewController
      self.delegate?.userDetailsViewControllerDidRequestLogout(viewController: self)
      
      let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
      appDelegate.window?.rootViewController = nav
    }
  }
}
extension AccountViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  
  private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
  {
  //  let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
   // pkcCrop.otherCrop(chosenImage)
    //profilePicture = chosenImage //4
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
    dismiss(animated:true, completion: nil) //5
    
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
extension AccountViewController:EditProfilePicture{
  func openActiveSheetChooseProfilePicture(){
    
    // Profile Picture Select option to edit profile
    let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    //Create and add the Cancel action
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
      //Just dismiss the action sheet
    }
    actionSheetController.addAction(cancelAction)
    //Create and add first option action
    let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
      //Code for launching the camera goes here
      self.clickImageFromCamera()
    }
    actionSheetController.addAction(takePictureAction)
    //Create and add a second option action
    let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Library", style: .default) { action -> Void in
      //Code for picking from Gallery  goes herece
      self.selectImagefromGallery()
    }
    actionSheetController.addAction(choosePictureAction)
    //Present the AlertController
    if UIDevice.current.userInterfaceIdiom == .pad{
      actionSheetController.popoverPresentationController?.sourceView = self.view
      actionSheetController.popoverPresentationController?.sourceRect = CGRect(0, self.view.bounds.size.height , self.view.bounds.size.width, 1.0)
    }
    self.present(actionSheetController, animated: true, completion: nil)
  }
  func selectImagefromGallery(){
   /* picker.allowsEditing = false
    picker.sourceType = .photoLibrary
    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    present(picker, animated: true, completion: nil)
 */
    pkcCrop.photoCrop()
  }
  func clickImageFromCamera(){
   /* picker.allowsEditing = false
    picker.sourceType = UIImagePickerControllerSourceType.camera
    picker.cameraCaptureMode = .photo
    picker.modalPresentationStyle = .fullScreen
    present(picker,animated: true,completion: nil)
 */
    pkcCrop.cameraCrop()
  }
  
  
}

extension AccountViewController:PKCCropDelegate{
  //You must put in the ViewController at this time.
 
  func pkcCropController() -> UIViewController {
    return self
  }
  
  //The delegate to which the image is passed since the crop.
  
  func pkcCropImage(_ image: UIImage) {
    //self.profilePicture = image
    
    let strBase64 = UIImagePNGRepresentation(image)?.base64EncodedString()
    webServiceToUploadProfileImage(parameters: ["username": UserDefaults.standard.object(forKey: kUserNameKey) as! String,"image":strBase64!])
  }
  
  func webServiceToUploadProfileImage(parameters:[String:String]){
    let finalUrlToHit = kBaseUrl+kUpdateProfilePic
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofirePostRequest(param: parameters as [String : AnyObject], withUrlString: finalUrlToHit) { (data, error) in
      self.loader?.removeFromSuperview()
      self.loader = nil
      if data != nil{
        UserDefaults.standard.set(data!["Data"]["Profile"]["image_url"].stringValue, forKey: kProfilePicName)
        UserDefaults.standard.synchronize()
        AlamoFireConnectivity.loadImageUsingAlamofireWith(url: data!["Data"]["Profile"]["image_url"].stringValue, completion: { (imageResponse) in
          
          if let image = imageResponse.result.value {
            print("image downloaded: \(image)")
            self.profilePicture = image
            self.tableView.reloadData()
          }
          
        })
      }else{
        self.methodToHandelPushNotificationStatusfailure(error: error)
      }
    }
//    AlamoFireConnectivity.uploadImageToServerWith(parameters: parameters, image: withImage, url: finalUrlToHit) { (data, error) in
//      
//    }
    /*AlamoFireConnectivity.alamofirePostRequest(param: parameters, withUrlString: finalUrlToHit){ (data, error) in
      loaderView.removeFromSuperview()
      if data != nil{
        self.methodToHandelPushNotificationStatusSuccess(data: data!)
        
      }else{
        self.methodToHandelPushNotificationStatusfailure(error: error)
      }
      
    }*/
  }
  
 
  func methodToHandelPushNotificationStatusfailure(error:NSError?)
  {
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }

}
