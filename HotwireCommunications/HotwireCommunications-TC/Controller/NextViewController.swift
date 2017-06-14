//
//  NextViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 08/09/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit
import SwiftyJSON

class NextViewController: BaseViewController
{
    var topic_id : String?
    var titleName : String?
    var arrSelectTopic : [DataModelForSelectTopic]?
    var dataForSelectTopic: DataModelForSelectTopic?
    var loader: LoaderView?
  
  @IBOutlet weak var tblViewFAQ: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewUpdateContentOnBasesOfLanguage()
        backButtonWithOutTitle()
        self.navigationItem.backBarButtonItem?.title = ""
        callWebServiceToGetTheTopic()
        currentViewSize = self.view.frame.size
       
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
  
  
  func callWebServiceToGetTheTopic()
  {
    let finalUrl = kBaseUrl + kFaqTopic
    
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrl, completion: {data,error in
      
      if data != nil
      {
        self.methodToHandelSelectTopicDataFromApi(data: data!)
      }
      else
      {
        print("Some error occured")
        self.methodToHandelAccountStatusfailure(error: error!)
      }
      self.loader?.removeFromSuperview()
      self.loader = nil
    })
  }
 func methodToHandelSelectTopicDataFromApi(data:SwiftyJSON.JSON)
 {
  let status = data["Success"].stringValue
  if status.lowercased() == "true"
  {
    arrSelectTopic = [DataModelForSelectTopic]()
    let jsonData = data["Data"].dictionaryValue
    let selectTopicData = jsonData["Faq"]?.arrayValue
    if selectTopicData != nil
    {
      for dictTopic in selectTopicData!
      {
        let topicName = dictTopic["code"].stringValue
        let display_order = dictTopic["display_order"].stringValue
        let article_count = dictTopic["article_count"].stringValue
        let topic_id = dictTopic["id"].stringValue
        dataForSelectTopic = DataModelForSelectTopic(topicName:topicName, topicId:topic_id, articleCount:article_count,displayOrder:display_order)
        arrSelectTopic?.append(dataForSelectTopic!)
        
      }
      tblViewFAQ.reloadData()
    }
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
  
  func methodToHandelSelectTopicFailure(error:NSError?)
  {
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }
  
func viewUpdateContentOnBasesOfLanguage()
{
  let languageIndex = UserDefaults.standard.integer(forKey: "language")
  LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
        languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
        
  self.title = "FAQ_selectTopic".localized(lang: languageCode, comment: "")
}
override func didReceiveMemoryWarning()
{
  super.didReceiveMemoryWarning()
}

  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == KTelevision
    {
       let controller = segue.destination as! TelevisionViewController
       controller.topic_id = topic_id
      controller.title = titleName
    }
   
  }
}
extension NextViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      if arrSelectTopic != nil
      {
        return (arrSelectTopic?.count)!
      }
      return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQ_Cell", for: indexPath) as! HomeBasicTableViewCell
        dataForSelectTopic = arrSelectTopic?[indexPath.row]
        cell.lblHeaderTitle.text = dataForSelectTopic?.topicName
        cell.lblDetailText?.text = dataForSelectTopic?.articleCount
        return cell
    }
    
}
extension NextViewController : UITableViewDelegate
{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    topic_id = (arrSelectTopic?[indexPath.row])?.topicId
    titleName = (arrSelectTopic?[indexPath.row])?.topicName
    self.performSegue(withIdentifier: KTelevision, sender: self)
  }
}

