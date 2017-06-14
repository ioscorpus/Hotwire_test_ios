//
//  TV_AdditionalChannelListViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 21/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit
import SwiftyJSON

class TV_AdditionalChannelListViewController: BaseViewController
{

  @IBOutlet var searchBarTV: UISearchBar!
  @IBOutlet var segmentCntrl: UISegmentedControl!
  
  @IBOutlet var lblAllMovies: UILabel!
  @IBOutlet var tblViewTV: UITableView!
  
  var strChannelName = ""
  var loader : LoaderView?
  var strPkgID : String?
  var strProperty_Code : String?
  var arrSearchResult : [DataModelForChannel_UnderPackage] = []
  var searchActive : Bool = false
  
  fileprivate var dataModelForChannel_UnderPackage : DataModelForChannel_UnderPackage?
  fileprivate var arrAllChannelList : [DataModelForChannel_UnderPackage] = []
  fileprivate var arrHDChannelList : [DataModelForChannel_UnderPackage] = []

  enum ChannelType
  {
    case AllChannel
    case HDChannel
  }
  var selectedChannelType = ChannelType.AllChannel

  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :kFontStyleSemiBold18!, NSForegroundColorAttributeName : UIColor.white]
    setUpRightImageOnNavigationBar()
    tblViewTV.estimatedRowHeight = 52
    tblViewTV.rowHeight = UITableViewAutomaticDimension
    tblViewTV.isHidden = true
    callWebServiceToGetChannelListCorrespondingToPackageID()
    viewUpdateContentOnBasesOfLanguage()
    hideKeyboard()

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
  
  override func viewDidDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
  }
  
  func viewUpdateContentOnBasesOfLanguage()
  {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    lblAllMovies.text = "TV_AllMovies".localized(lang: languageCode, comment: "")+self.title!
  }
  
  private func callWebServiceToGetChannelListCorrespondingToPackageID()
  {
    let finalUrl = kBaseUrl+KGetChannelList+"/"+strProperty_Code!+"/"+strPkgID!
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
    
    AlamoFireConnectivity.alamofireGetRequest(urlString: finalUrl, completion: {data,error in
      
      if data != nil
      {
        self.methodToHandelResponseOfChannelLineUpChannelList(data: data!)
      }
      else
      {
        print("Some error occured")
        self.methodToHandelResponseOfChannelLineUpChannelListFailure(error: error!)
      }
      self.loader?.removeFromSuperview()
      self.loader = nil
    })
    
  }
  
  //MARK: Handle WebService Success Response
  func methodToHandelResponseOfChannelLineUpChannelList(data:SwiftyJSON.JSON)
  {
    let status = data["Success"].stringValue
    if status.lowercased() == "true"
    {
      let jsonData = data["Data"].dictionaryValue
      let dictChnlList = jsonData["channels"]?.arrayValue
      guard let dictChnlListDetail = dictChnlList
        else
      {
        return
      }
      for dictValue in dictChnlListDetail
      {
        dataModelForChannel_UnderPackage = DataModelForChannel_UnderPackage(dictChnlDetail: dictValue.dictionaryValue)
        
        if dataModelForChannel_UnderPackage?.chnl_Is_HD == "1"
        {
          arrHDChannelList.append(dataModelForChannel_UnderPackage!)
        }
        arrAllChannelList.append(dataModelForChannel_UnderPackage!)
        
      }
      sortTheChannelListCorrespondingToChannelNumber()
      
      tblViewTV.isHidden = false
      tblViewTV.reloadData()
      
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
  //MARK: Sorting In an asscending order
  func sortTheChannelListCorrespondingToChannelNumber()
  {
    arrAllChannelList.sort
      { Int(($0 as DataModelForChannel_UnderPackage).chnl_Number)! < Int(($1 as DataModelForChannel_UnderPackage).chnl_Number )!}
    arrHDChannelList.sort
      { ($0 as DataModelForChannel_UnderPackage).chnl_Number < ($1 as DataModelForChannel_UnderPackage).chnl_Number }
   
  }
  
  //MARK: Handle WebService Failure Response
  func methodToHandelResponseOfChannelLineUpChannelListFailure(error:NSError?)
  {
    if error != nil{
      if error?.code != 123{
        self.showTheAlertViewWith(title: "Alert".localized(lang: languageCode, comment: ""), withMessage:error!.description, languageCode: languageCode)
      }else{
        self.showTheAlertViewWith(title: (error?.localizedDescription)!, withMessage:(error?.localizedFailureReason)!, languageCode: languageCode)
      }
      
    }
  }



  @IBAction func segmentControllTapped(_ sender: Any)
  {
    switch segmentCntrl.selectedSegmentIndex
    {
    case 0:
      selectedChannelType = .AllChannel
//      searchBarTV.text = nil
//      searchActive = false
        arrSearchResult = []
        searchBar(searchBarTV, textDidChange: searchBarTV.text!)
    
      self.tblViewTV.reloadData()
      
    case 1:
      selectedChannelType = .HDChannel
//      searchBarTV.text = nil
//      searchActive = false
        arrSearchResult = []
       searchBar(searchBarTV, textDidChange: searchBarTV.text!)
      self.tblViewTV.reloadData()
      
    default:
      selectedChannelType = .AllChannel
//      searchBarTV.text = nil
//      searchActive = false
      arrSearchResult = []
      searchBar(searchBarTV, textDidChange: searchBarTV.text!)
      self.tblViewTV.reloadData()
    }

  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: TableViewDataSource
extension TV_AdditionalChannelListViewController : UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if(searchActive)
    {
      return arrSearchResult.count
    }
    else
    {
      switch selectedChannelType
      {
        case .AllChannel:
          return arrAllChannelList.count
        
        case .HDChannel:
          return arrHDChannelList.count
        
      }
    }

  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalChannelLine_Cell", for: indexPath) as! HomeBasicTableViewCell
    let strChnlName : String
    let isStrHd : String
    
    let imgHD = cell.viewWithTag(1) as! UIImageView
    
    if(searchActive)
    {
      cell.lblHeaderTitle.text = (arrSearchResult[indexPath.row]).chnl_Name
      isStrHd = (arrSearchResult[indexPath.row]).chnl_Is_HD
    }
    else
    {
      
      switch selectedChannelType
      {
      case .AllChannel:
        strChnlName = (arrAllChannelList[indexPath.row]).chnl_Name
        isStrHd = (arrAllChannelList[indexPath.row]).chnl_Is_HD
        
      case .HDChannel:
        strChnlName = (arrHDChannelList[indexPath.row]).chnl_Name
        isStrHd = (arrHDChannelList[indexPath.row]).chnl_Is_HD
      
      }
      cell.lblHeaderTitle.text = strChnlName
    }
    
    if isStrHd == "0"
    {
      imgHD.isHidden = true
    }
    else {
      imgHD.isHidden = false
    }
    
    return cell
  }
  
}

//MARK: TableViewDelegate
extension TV_AdditionalChannelListViewController : UITableViewDelegate
{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    
  }
}


//MARK: UISearchBarDelegate

extension TV_AdditionalChannelListViewController: UISearchBarDelegate
{
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
  {
    //searchActive = true;
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
  {
    searchActive = false;
    arrSearchResult = []
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
  {
    searchActive = false;
    arrSearchResult = []
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
  {
    searchActive = false;
    arrSearchResult = []
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
  {
    if searchText == ""
    {
      searchActive = false
      arrSearchResult = []
    }
    else
    {
      searchActive = true;
      switch selectedChannelType
      {
      case .AllChannel:
        arrSearchResult = arrAllChannelList.filter()
          {
            if let chnlName = ($0 as DataModelForChannel_UnderPackage).chnl_Name as String!
            {
              return chnlName.range(of: searchText, options: .caseInsensitive) != nil
            }
            else
            {
              return false
            }
        }
        
      case .HDChannel:
        arrSearchResult = arrHDChannelList.filter()
          {
            if let chnlName = ($0 as DataModelForChannel_UnderPackage).chnl_Name as String!
            {
            
              return chnlName.range(of: searchText, options: .caseInsensitive) != nil
            }
            else {
              return false
            }
        }
      }
    }
    self.tblViewTV.reloadData()
  }
  
}

