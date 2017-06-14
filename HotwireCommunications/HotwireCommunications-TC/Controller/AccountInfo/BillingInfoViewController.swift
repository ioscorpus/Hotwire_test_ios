//
//  BillingInfoViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 09/01/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class BillingInfoViewController: BaseViewController {
  var listArray:[BillingInfo]?{
    didSet {
      self.tableView.reloadData()
    }
  }
  var headerCellIdentier = "HeaderCell"
  // Iboutlet
  @IBOutlet var tableView: UITableView!
  //data variables
  
  
  let temportyBillingInfoColorForPhase1 = UIColor.gray
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
    configureViewProperty()
    addNotificationObserver()
    viewUpdateContentOnBasesOfLanguage()
    setUpRightImageOnNavigationBar()
    // Do any additional setup after loading the view.
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
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
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    methodToCreateViewList()
    self.title = "BillingInfoTitle".localized(lang: languageCode, comment: "")
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
    
    let localizedTotalAmountDue = "TotalAmountDue".localized(lang: languageCode, comment: "")
    let amountDue = BillingInfoCell.init(title: localizedTotalAmountDue, withSubTextOne: "IncluingPastDueAmount", withSubTextTwo: "$29.38", cellIdentifier: cellIdentifier.RegularWithTwoDetailText)
    
    let localizedTpaymentDueOn = "PaymentDueOn".localized(lang: languageCode, comment: "")
    let paymentDueOn = BillingInfoCell.init(title: localizedTpaymentDueOn, withSubTextOne: "11/11/16", cellIdentifier: cellIdentifier.HeaderWithDetailsRight)
    
    let localizedpayBill = "PayBill".localized(lang: languageCode, comment: "")
    let payBill = BillingInfoCell.init(title: localizedpayBill, cellIdentifier:  cellIdentifier.BlueColorHeader)
    
    let localizedPayDifferentAmount = "PayDifferentAmount".localized(lang: languageCode, comment: "")
    let payDifferentAmount = BillingInfoCell.init(title: localizedPayDifferentAmount, cellIdentifier:  cellIdentifier.BlueColorHeader)
    
    let localizedSetupAutoPayment = "SetupAutoPayment".localized(lang: languageCode, comment: "")
    let setupAutoPayment = BillingInfoCell.init(title:localizedSetupAutoPayment, cellIdentifier:  cellIdentifier.BlueColorHeader)
    
    let localizedpaperlessBilling = "PaperlessBilling".localized(lang: languageCode, comment: "")
    let paperlessBilling = BillingInfoCell.init(title: localizedpaperlessBilling, withSubTextOne: "Not Enrolled", cellIdentifier: cellIdentifier.BlueTextWithDetail)
    
    
    let localizedBillHistory = "BillStatementHistory".localized(lang: languageCode, comment: "")
    let BillHistory = BillingInfoCell.init(title: localizedBillHistory,cellIdentifier:cellIdentifier.CellWithoutDetail)
    
    let localizedUnderstandingYourBill = "UnderstandingYourBill".localized(lang: languageCode, comment: "")
    let understandingYourBill = BillingInfoCell.init(title:localizedUnderstandingYourBill, cellIdentifier:  cellIdentifier.CellWithoutDetail)
    
    let localizedlistSection1 = "BALANCESUMMARY".localized(lang: languageCode, comment: "")
    let listSection1 = BillingInfo.init(sectionHeading: localizedlistSection1, withList: [amountDue!,paymentDueOn!], iconList: nil)
    
    let localizedlistSection2 = "PAYMENTOPTIONS".localized(lang: languageCode, comment: "")
    let listSection2 = BillingInfo.init(sectionHeading: localizedlistSection2, withList: [payBill!,payDifferentAmount!,setupAutoPayment!], iconList: nil)
    
    let localizedlistSection3 = "BILLINGOPTIONS".localized(lang: languageCode, comment: "")
    let listSection3 = BillingInfo.init(sectionHeading: localizedlistSection3, withList: [paperlessBilling!,BillHistory! ,understandingYourBill!], iconList: nil)
    
    listArray = [BillingInfo]()
    listArray? = [listSection1!, listSection2! ,listSection3!]
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
extension BillingInfoViewController: UITableViewDelegate,UITableViewDataSource {
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
    case cellIdentifier.CellWithoutDetail?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      return cell
    case cellIdentifier.BlueColorHeader?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblHeaderTitle.textColor = temportyBillingInfoColorForPhase1
      return cell
    case cellIdentifier.BlueTextWithDetail?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      cell.lblHeaderTitle.textColor = temportyBillingInfoColorForPhase1
      return cell
    case cellIdentifier.HeaderWithDetailBotom?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      return cell
    case cellIdentifier.HeaderWithRightButton?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      return cell
    case cellIdentifier.HeaderWithDetailsRight?:
      let cell = tableView.dequeueReusableCell(withIdentifier: sublistObject.cellIdentifierType!.rawValue) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = sublistObject.cellTitle
      cell.lblDetailText.text = sublistObject.cellDetailTitleOne
      return cell
    default:
      return UITableViewCell()
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 || section == 1 || section == 2 {
      return 0
    }
    return 38
  }
  
  
  
  /***********************************************************************************************************
   <Name>  tableView heightForRowAt  </Name>
   <Input Type>  tableView,indexPath   </Input Type>
   <Return> CGFloat </Return>
   <Purpose> Calculate the height of tableView Cell , edited part is to return 0 when section is either 0 or 1 or 2(for row 0 and 1) as it is not required in phase 1</Purpose>
   <History>
   <Header> Version 2.0 </Header>
   <Date> 03/03/17 </Date>
   <Author>Nirbhay Singh<Author/>
   </History>
   ***********************************************************************************************************/
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.section == 0 || indexPath.section == 1 {
      return 0
    }
    
    if indexPath.section == 2{
      if indexPath.row == 0 || indexPath.row == 1 {
        return 0
      }
    }
    
    let listObject:BillingInfo = listArray![indexPath.section]
    let sublistObject:BillingInfoCell = listObject.subList![indexPath.row]
    switch sublistObject.cellIdentifierType {
    case cellIdentifier.BlueColorHeader?,.HeaderWithRightButton?,.HeaderWithDetailsRight?,.CellWithoutDetail?,.BlueTextWithDetail?:
      return 52
    case cellIdentifier.HeaderWithDetailBotom?:
      return UITableViewAutomaticDimension
    case cellIdentifier.RegularWithTwoDetailText?:
      return 65
    default:
      return 0
    }
  }
  
  /***********************************************************************************************************
   <Name>  tableView didSelectRowAt  </Name>
   <Input Type>  tableView,didSelectRowAt   </Input Type>
   <Return> void </Return>
   <Purpose> Determine the selected index, Edited for case 2 for opening the webview.</Purpose>
   <History>
   <Header> Version 2.0 </Header>
   <Date> 03/03/17 </Date>
   <Author>Nirbhay Singh<Author/>
   </History>
   ***********************************************************************************************************/
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      if indexPath.row == 0{
        self.performSegue(withIdentifier: kSegue_CurrentBalance, sender: self)
      }else{
        
      }
    case 1:
      if indexPath.row == 0{
        self.performSegue(withIdentifier: kSegue_PayBill, sender: self)
      }else if indexPath.row == 1{
        self.performSegue(withIdentifier: kSegue_PayDiffrent, sender: self)
      }else{
        
      }
      
    case 2:
      if indexPath.row == 2{
        // open the webView here.....
        self.performSegue(withIdentifier: kSegue_UnderStandingBill, sender: self)
      }
      
    default:
      print("No action on \(indexPath.section) section and \(indexPath.row) row")
    }
  }
}

