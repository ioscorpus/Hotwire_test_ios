//
//  AccountViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 05/09/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit

class ServicesViewController: BaseViewController
{
  let headerTitle = "UP_ADD/UPGRADE"
  
  let listArray = ["UP_FissionTv","UP_FissionInternet","UP_FissionVoice","UP_FissionSecurity","UP_FissionEquipment","UP_FissionBundles"]
  
  let arrUpgradeCellImages = ["icServicesTv","icServicesInternet","icServicesVoice","icServicesSecurity","icServicesEquipment","icServicesBundles"]
  
  @IBOutlet var topImageView: UIImageView!
  @IBOutlet var tableView: UITableView!
  var headerReuseIdentifier = "HeaderCell"
  var cellReuseIdentifier = "UpgradeCell"
 
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setUpRightImageOnNavigationBar()
    tableView.delegate = self
    tableView.dataSource = self
    viewUpdateContentOnBasesOfLanguage()
  }
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    self.title = "Upgrade".localized(lang: languageCode, comment: "")
  }
  
  func viewUpdateContentOnBasesOfLanguage()
  {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
}
// MARK: - Tableview delegate and data source
extension ServicesViewController: UITableViewDelegate,UITableViewDataSource
{
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier) as! HeaderTableViewCell
    headerCell.lblHeaderTitle.text = headerTitle.localized(lang: languageCode, comment: "")
    return headerCell
  }
 
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }
 
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return listArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeBasicTableViewCell
    cell.lblHeaderTitle.text = (listArray[indexPath.row]).localized(lang: languageCode, comment: "")
    cell.iconImageView.image = UIImage(named: arrUpgradeCellImages[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return 38
  }
 
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 52
  }
}
