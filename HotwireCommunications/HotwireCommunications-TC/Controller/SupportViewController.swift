//
//  HWHomeViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 05/09/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//   com.chetu.HotwireCommunicationsHockey

import UIKit

class SupportViewController: BaseViewController{
    let headerTitle = NSLocalizedString("Support_title", comment: "")
    fileprivate let urlString = "https://cdn.livechatinc.com/app/mobile/urls.json"
    fileprivate let license = "1032828"
    fileprivate let chatGroup = "4"
    fileprivate var chatURL : NSString?
    var isLifeChatSelected = false
    var isContactUsSelected = false
    var isScheduleVisitSelected = false
    //@IBOutlet var topImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    let headerList :[String] = ["Support_All_Clear","Self_Help","Support_Customer_Service",/*"Support_Appointment",*/"Support_Account_Manager"]
    let selfHelpIcon :[String] = ["icSupportTroubleshooting","icSupportFaq"]
    let customerServiceIcon :[String] = ["icSupportLivechat","icSupportContactus","icCommunityPropertymessages"]
    let appointmentIcon :[String] = ["icSupportSchedulehomevisit"]
    let accountManagerIcon :[String] = ["icSupportAccountmanagerinfo"]
    var supportField = ["":[""]]
    var headerReuseIdentifier = "HeaderCell"
    var cellReuseIdentifier = "RegularCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportField = [headerList[0]:["Support_All_Clear"],headerList[1]:["Support_Troubleshooting","Support_FAQ"],headerList[2]:["Support_Live_Chat","Support_Text_Chat","Support_Voice_Chat","Support_Video_Chat","Support_Call_Customer_Service","Support_Contact_Us"/*,"Support_Schedule_A_Call","Support_Call_Me_Now"*/,"Support_Email_Us"],/*headerList[3]:["Support_Schedule_Visit","Support_Visit_Scheduled","Support_Call_Scheduled","Support_Schedule_Appointment"],*/headerList[3]:["Support_Manager_Info"]]
        tableView.delegate = self
        tableView.dataSource = self
        let languageIndex = UserDefaults.standard.integer(forKey: "language")
        LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
        languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
        setUpRightImageOnNavigationBar()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Support".localized(lang: languageCode, comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if segue.identifier == KAccountManagerHelpSegue
      {
        let controller = segue.destination as! AccountManagerHelpViewController
        controller.listForContactOrAccountManager = "Contact_Us"
        controller.title = "Contact Us"
      }
    }
    
    
}
extension SupportViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier) as! HeaderTableViewCell
        let stringTitle = headerList[section]//NSLocalizedString(headerList[section], comment: "")
        headerCell.lblHeaderTitle.text = stringTitle.localized(lang: languageCode, comment: "").uppercased()
        headerCell.backgroundColor = UIColor.white
        return headerCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return supportField.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (supportField[headerList[section] as String])!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stringTitle = ((supportField[headerList[indexPath.section] as String])![indexPath.row]).localized(lang: languageCode, comment: "")
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTabHeaderCellTableView) as! TabHeaderCellTableViewCell
            
            cell.titleLable.text = stringTitle.localized(lang:languageCode, comment: "")
            //      (cell?.contentView.viewWithTag(1) as! UIButton).addTarget(self, action: //#selector(TVViewController.skipBarButtonTappedAction(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeBasicTableViewCell
            cell.lblHeaderTitle.text = stringTitle.localized(lang:languageCode, comment: "")
            cell.lblDetailText?.text = ""
            cell.iconImageView.isHidden = false
            switch indexPath.section {
            case 1:
                cell.iconImageView.image = UIImage(imageLiteralResourceName: selfHelpIcon[indexPath.row])
                break;
            case 2:
                if(indexPath.row <= 2){
                    cell.iconImageView.image = UIImage(imageLiteralResourceName: customerServiceIcon[0])
                }else if(indexPath.row == 4){
                    cell.iconImageView.image = UIImage(imageLiteralResourceName: customerServiceIcon[1])
                }else{
                    if(indexPath.row == 5)
                    {
                        cell.iconImageView.image = UIImage(imageLiteralResourceName: customerServiceIcon[2])
                    }else{
                        cell.iconImageView.isHidden = true
                    }
                }
                break;
            case 3:
                if(indexPath.row == 0){
                    cell.iconImageView.image = UIImage(imageLiteralResourceName: appointmentIcon[indexPath.row])
                }else{
                    cell.iconImageView.isHidden = true
                }
                break;
            case 4:
                cell.iconImageView.image = UIImage(imageLiteralResourceName: accountManagerIcon[indexPath.row])
                break;
            default:
                break;
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        return CGFloat(kSectionHeight)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return CGFloat(kHeaderHeight)
        }
        if(indexPath.section == 2){
            if(indexPath.row != 0 && indexPath.row != 4){
                if(!isLifeChatSelected){
                    if(indexPath.row >= 1 && indexPath.row <= 3){
                        return 0
                    }
                }
                if(!isContactUsSelected){
                    if(indexPath.row >= 6 && indexPath.row <= 8){
                        return 0
                    }
                }
            }
        }
        if(indexPath.section == 3){
            if(!isScheduleVisitSelected){
                if(indexPath.row >= 1 && indexPath.row <= 3){
                    return 0
                }
            }
        }
        return CGFloat(kRowHeight)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 2:
            if(indexPath.row == 0){
                /*  if(!isLifeChatSelected){
                 isLifeChatSelected = true
                 
                 }else{
                 isLifeChatSelected = false
                 }
                 tableView.beginUpdates()
                 tableView.reloadData()
                 tableView.endUpdates()*/
                requestUrl()
                return
            }
            if(indexPath.row == 1){
                //requestUrl()
            }
            if(indexPath.row == 4){
              
              dialPhone(withDialTitle: "(800)355-5668", contactNumber: "8003555668", languageCode: languageCode)
            }
            if indexPath.row == 5
            {
               performSegue(withIdentifier: KAccountManagerHelpSegue, sender: self)            }
            break
        case 3:
          performSegue(withIdentifier:KAccountManagerSegue, sender: self)
            break;
        default:
            performSegue(withIdentifier: "nextPage", sender: self)
        }
        
    }
    
  
    func startChat() {
        if let chatURL = self.chatURL {
            let chatViewController = ChatViewController(chatURL: chatURL)
            self.navigationController?.pushViewController(chatViewController, animated: true)
            //  self.hidesBottomBarWhenPushed = true
        }
    }
    
    fileprivate func requestUrl() {
        let session = URLSession.shared
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Request error: " + error.localizedDescription)
            } else {
                guard let data = data else {
                    print("Request data not present")
                    return
                }
                
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    guard JSON is NSDictionary else {
                        print("JSON is not dictionary!")
                        return
                    }
                    
                    let JSONDict = JSON as! NSDictionary
                    
                    if JSONDict.value(forKey: "chat_url") != nil {
                        self.chatURL = self.prepareURL(JSONDict["chat_url"] as! NSString)
                    print("ChatURL = \(self.chatURL)")
                     
                        DispatchQueue.main.async {
                            self.startChat()
                        }
                        
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }
        }) .resume()
        
    }
    
    fileprivate func prepareURL(_ URL: NSString) -> NSString {
        let string = NSMutableString(string: "https://\(URL)")
        
        string.replaceOccurrences(of: "{%license%}",
                                  with: license,
                                  options: .literal,
                                  range: NSMakeRange(0, string.length))
        
        string.replaceOccurrences(of: "{%group%}",
                                  with: chatGroup,
                                  options: .literal,
                                  range: NSMakeRange(0, string.length))
      if let f_Name = UserDefaults.standard.value(forKey: kFirstName)
      {
        if let l_Name = UserDefaults.standard.value(forKey: kLastName)
        {
          string.append("&name=\(f_Name as! String) \(l_Name as! String)")
        }
        else{
           string.append("&name=\(f_Name as! String)")
        }
      }
      if let email = UserDefaults.standard.value(forKey: kEmail)
       {
          string.append("&email=\(email as! String)")
       }
      return string
    }
    
}
