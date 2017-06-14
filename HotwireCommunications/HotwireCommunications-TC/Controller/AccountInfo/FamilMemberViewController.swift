//
//  FamilMemberViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 11/01/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class FamilMemberViewController:  BaseViewController {
  var listArray:[BillingInfo]?{
    didSet {
      self.tableView.reloadData()
    }
  }
  var headerCellIdentier = "HeaderCell"
  // Iboutlet
  @IBOutlet var tableView: UITableView!
  //data variables
  
  //MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 09/01/17 </Date>
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
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    configureViewProperty()
    addNotificationObserver()
    viewUpdateContentOnBasesOfLanguage()
    // Do any additional setup after loading the view.
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
   <Date> 09/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    methodToCreateViewList()
    self.title = "Family Members"
  }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call to update view properties </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date> 09/01/17 </Date>
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
   <Date> 09/01/17 </Date>
   </History>
   ***********************************************************************************************************/
  func methodToCreateViewList(){
    
    let familyMember1 = BillingInfoCell.init(title: "William Nye", withSubTextOne: "Organizer", withSubTextTwo: "", cellIdentifier: cellIdentifier.ImageWithTwoDetailText)
    let familyMember2 = BillingInfoCell.init(title: "Blair Nye", withSubTextOne: "Administrator", withSubTextTwo: "invited", cellIdentifier: cellIdentifier.ImageWithTwoDetailText)
    let addFamilyMember = BillingInfoCell.init(title: "Add Family Member…", cellIdentifier:  cellIdentifier.BlueColorHeader)
    let addFamilyText =  BillingInfoCell.init(title:nil, withSubTextOne:"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum risus vitae sodales commodo. Pellentesque sed libero in erat iaculis ultricies. Maecenas varius dui velit, in tristique est imperdiet in. In sit amet congue erat. Vivamus fermentum vitae enim id aliquam. Maecenas ac tempor turpis, rhoncus vestibulum risus. Nullam egestas quam augue, lobortis facilisis arcu vehicula id. Pellentesque sodales eget justo at maximus.", cellIdentifier: cellIdentifier.PragraphCellIdentifier)
    let listSection1 = BillingInfo.init(sectionHeading: "CURRENTLY ENROLLED ", withList: [familyMember1!,familyMember2!,addFamilyMember!,addFamilyText!], iconList: nil)
  
    listArray = [BillingInfo]()
    listArray? = [listSection1!]
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
   <Date>  09/01/17 </Date>
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
extension FamilMemberViewController: UITableViewDelegate,UITableViewDataSource {
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
    case cellIdentifier.RegularWithTwoDetailText?,.ImageWithTwoDetailText?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      cell.lblTwoDetailText.text = sublistObject.cellDetailTitleTwo
      return cell
    case cellIdentifier.CellWithoutDetail?,.BlueColorHeader?,.HeaderWithRightButton?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      return cell
    case cellIdentifier.BlueTextWithDetail?,.HeaderWithDetailBotom?,.HeaderWithDetailsRight?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      return cell
    case cellIdentifier.PragraphCellIdentifier?:
      let cell = tableView.dequeueReusableCell(withIdentifier:  sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      return cell
    default:
      return UITableViewCell()
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let listObject:BillingInfo = listArray![indexPath.section]
    let sublistObject:BillingInfoCell = listObject.subList![indexPath.row]
    switch sublistObject.cellIdentifierType {
    case cellIdentifier.BlueColorHeader?,.HeaderWithRightButton?,.HeaderWithDetailsRight?,.CellWithoutDetail?,.BlueTextWithDetail?:
      return 46
    case cellIdentifier.RegularWithTwoDetailText?,.ImageWithTwoDetailText?:
      return 65
    case cellIdentifier.HeaderWithDetailBotom?,.PragraphCellIdentifier?:
       return UITableViewAutomaticDimension
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

