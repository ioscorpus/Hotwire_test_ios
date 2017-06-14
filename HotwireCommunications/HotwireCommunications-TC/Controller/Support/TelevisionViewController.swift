//
//  TelevisionViewController.swift
//  HotwireCommunications
//
//  Created by admin on 3/28/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class TelevisionViewController: BaseViewController
{
  
    @IBOutlet weak var tblViewTelevision: UITableView!
    var topic_id : String?
    var arrTelevesionSection : [String]!
    var arrTelevesionSectionData : [[String]]!
    var arrArticle : [DataModelForSpecificTopic]?
    var arrFiles : [DataModelForSpecificTopic]?
    var strUrl: String?
    var selectedSection : Int?
    var dataModelForSpecificTopic : DataModelForSpecificTopic?
    var headerReuseIdentifier = "TelevisionHeaderCell"
    var cellReuseIdentifier = "Television_Cell"
    var loader: LoaderView?
    var userGuideLinesAreAvailable = true
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        arrTelevesionSection = ["Tel_SectionZero","Tel_SectionOne"]
        arrTelevesionSectionData = [["Tel_SectionZero_RowZero","Tel_SectionZero_RowOne","Tel_SectionZero_RowTwo","Tel_SectionZero_RowThree","Tel_SectionZero_RowFour"],["Tel_SectionOne_RowZero","Tel_SectionOne_RowOne","Tel_SectionOne_RowTwo","Tel_SectionOne_RowThree"]]
        tblViewTelevision.isHidden = true
        viewUpdateContentOnBasesOfLanguage()
         self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :kFontStyleSemiBold18!, NSForegroundColorAttributeName : UIColor.white]
        tblViewTelevision.estimatedRowHeight = 46
        tblViewTelevision.rowHeight = UITableViewAutomaticDimension
        callWebServiceToGetTheSpecificTopic()
     
  }
  override func viewWillAppear(_ animated: Bool)
  {
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  override func viewWillDisappear(_ animated: Bool)
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
        
        //self.title = "Tel_television".localized(lang: languageCode, comment: "")
    }
  func callWebServiceToGetTheSpecificTopic()
  {
    var finalUrl = kBaseUrl
    finalUrl = finalUrl.appending(kFaqTopicDetail)
    finalUrl += topic_id!
    finalUrl = finalUrl.appending("/")
    finalUrl = finalUrl.appending( UserDefaults.standard.object(forKey: kUserNameKey)
      as! String)
  
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrl, completion: {data,error in
      
      if data != nil{
        self.methodToHandelSelectSpecificTopicDataFromApi(data: data!)
      }else{
        self.methodToHandelSelectSpecificTopicFailure(error: error)
      }
      self.loader?.removeFromSuperview()
      self.loader = nil
    })
    
  }
  func methodToHandelSelectSpecificTopicDataFromApi(data:SwiftyJSON.JSON)
  {
    let status = data["Success"].stringValue
    if status.lowercased() == "true"
    {
       if data["Data"]["Article"]["faq_article"] != nil
       {
        let arrArticleData = data["Data"]["Article"]["faq_article"].arrayValue
        arrArticle = [DataModelForSpecificTopic]()
        for dict in arrArticleData
        {
          let id = dict["id"].stringValue
          let article_title = dict["article_title"].stringValue
          let article_content = dict["article_content"].stringValue
          dataModelForSpecificTopic = DataModelForSpecificTopic(article_title: article_title, article_content: article_content, id: id)
          arrArticle?.append(dataModelForSpecificTopic!)
        
        }
      }
      if data["Data"]["Article"]["files"] != nil
      {
        let arrFile = data["Data"]["Article"]["files"].arrayValue
        arrFiles = [DataModelForSpecificTopic]()
        for dict in arrFile
        {
          let id = dict["id"].stringValue
          let file_title = dict["file_title"].stringValue
          let file_path = dict["file_path"].stringValue
          dataModelForSpecificTopic = DataModelForSpecificTopic(file_title: file_title, file_path: file_path, id: id)
          arrFiles?.append(dataModelForSpecificTopic!)
          
        }
        userGuideLinesAreAvailable = true
      }
      else{
         userGuideLinesAreAvailable = false
      }
      tblViewTelevision.delegate = self
      tblViewTelevision.dataSource = self
      tblViewTelevision.isHidden = false
      tblViewTelevision.reloadData()
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
  func methodToHandelSelectSpecificTopicFailure(error:NSError?)
  {
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "ArticleVC"
    {
      let viewController = segue.destination as! ArticleViewController
      if selectedSection! == 0
      {
        viewController.strHtml = strUrl
      }
      else
      {
        viewController.webURL = strUrl
      }
      
    }
    
  }

}

extension TelevisionViewController : UITableViewDataSource , UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      switch section
      {
        case 0:
        guard let arrArticleData = arrArticle
          else{
            return 0
        }
        return arrArticleData.count
        
         case 1:
         guard let arrFilesData = arrFiles
            else{
              return 0
          }
          return arrFilesData.count
        
         default:
            return 0
        
      }
     
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
      switch section
      {
      case 0:
        return 38
        
      case 1:
        if userGuideLinesAreAvailable == true
        {
           return 38
        }
        else
        {
          return 0
        }
        
      default:
        return 38
      }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier) as! HeaderTableViewCell
        headerCell.lblHeaderTitle.text = arrTelevesionSection[section].localized(lang: languageCode, comment: "")
        headerCell.isUserInteractionEnabled = false
        return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! HomeBasicTableViewCell
        let imgRightArrow = cell.viewWithTag(10) as! UIImageView
        if indexPath.section == 0
        {
            imgRightArrow.isHidden = false
            dataModelForSpecificTopic = arrArticle?[indexPath.row]
            cell.lblHeaderTitle.text = dataModelForSpecificTopic?.article_title
        }
        else if indexPath.section == 1
        {
            cell.lblHeaderTitle.textColor = kColor_LinkBlue
            imgRightArrow.isHidden = true
            dataModelForSpecificTopic = arrFiles?[indexPath.row]
            cell.lblHeaderTitle.text = dataModelForSpecificTopic?.file_title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      switch indexPath.section
      {
        case 0:
          strUrl = (arrArticle?[indexPath.row])?.article_content
          selectedSection = indexPath.section
        
        case 1:
          strUrl = (arrFiles?[indexPath.row])?.file_path
          selectedSection = indexPath.section

        default:
          strUrl = ""
      }
        self.performSegue(withIdentifier: "ArticleVC", sender: self)
    }
}




