//
//  HelpViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 05/09/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit

class TVViewController: BaseViewController {
  let headerList :[String] = ["TV_FISION_STREAMING","TV_FISION_DVR"]
    
  let tvList:[String] = ["FISION_HIGHLIGHT","FISION_TV","FISION_ON_DEMAND","FISION_GUIDE","FISION_RECORDING"]
  let tvListIcon:[String] = ["icTvFisiongohighlights","icTvFisiongotv","icTvFisiongoondemand","icTvFisiongoguide","icTvFisiongocloudrecordings"]
    
  let dvrList:[String] = ["DVR_Selected","FISION_PAST_RECORDING","FISION_SCHEDULE_RECORDING","FISION_SERIES_RECORDING","FISION_SCHEDULE_A_RECORDING"]
  let dvrListIcon:[String] = ["icTvPastrecordings","icTvPastrecordings","icTvScheduledrecordings","icTvSeriesrecordings","icTvScheduledrecordings"]
    
  var cellWithProfilePicture =  "ProfilePicture"
    
  var counttable : Int = 0
  var flag : Bool = false
    

  let dVRBoxList:[String] = ["Dad's DVR","Family Room DVR","Living Room DVR"]
  var dvrPopupTableView : UITableView = UITableView()
  var listArray:[[String]]!
  @IBOutlet var topImageView: UIImageView!
  @IBOutlet var tableView1: UITableView!
    
    var loaderInTV: LoaderView?
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "TV".localized(lang: languageCode, comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotatedInTVController), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func deviceRotatedInTVController()
    {
        print("deviceRotatedInTVController")
        if loaderInTV != nil
        {
            loaderInTV?.removeFromSuperview()
            loaderInTV = LoaderView()
            loaderInTV?.initLoader()
            if let loaderView = loaderInTV
            {
                self.view.addSubview(loaderView)
            }
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getMDSTokenFromServer(urlString: DAD_DVR_Base_Url+EXT_DAD_DVR_URL)
        let localDad_DVR : String = DAD_DVR_Base_Url
        UserDefaults.standard.setValue(localDad_DVR, forKey: "GET_DVR_VALUE")
            

      //Commented by Rahul Gupta 
      //Date: 09 Feb 2017
      //Reason: UI changed
       //setUpLeftImageOnNavigationBar()
      setUpRightImageOnNavigationBar()
      listArray = [tvList,dvrList]//,remoteControllList,channelLineupList]
      tableView1.delegate = self
      tableView1.dataSource = self
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
        // Do any additional setup after loading the view.
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if segue.identifier == KTV_ChannelLineUpSegue
      {
        _ = segue.destination as! TV_ChannelLineUpViewController
      }
    }
  func chnlBtnClicked(button : UIButton)
  {
    print("buttClicked")
    self.performSegue(withIdentifier: KTV_ChannelLineUpSegue, sender: nil)
  }
    
    
    
    func getMDSTokenFromServer(urlString : String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true
        {
            
                self.startLoaderTVController()
                
                let url = NSURL(string : urlString)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
                let session = URLSession.shared
                let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                    
                    do {
                        
                        let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                        print("MDS TOKEN : \(dict)")
                        let MDSToken : NSString = dict["Token"] as! NSString
                        UserDefaults.standard.setValue(MDSToken, forKey: "MDS_TOKEN_VALUE")
                        
                        self.stopLoaderTVController()
                        
                        
                    }catch let error as NSError
                    {
                        print("Error Code In server response : \(error.code)")
                        
                        self.stopLoaderTVController()
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        
                    }
                    
                    
                }
                
                task.resume()

            
        }else{
            
            AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
        
       
    }
    
    
    func AlertPopUp(titleStr: String, messageStr: String)  {
        
        let alertPopupController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertPopupController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        
        }))
        
        self.present(alertPopupController, animated: true)

    }
    
    func startLoaderTVController() {
        
        loaderInTV = LoaderView()
        loaderInTV?.initLoader()
        loaderInTV?.kLoaderLabelText = "Please wait..."
        self.view.addSubview(loaderInTV!)
    }
    
    func stopLoaderTVController()  {
        
        DispatchQueue.main.async {
            self.loaderInTV?.removeFromSuperview()
            self.loaderInTV = nil
        }
    }
    

}
// MARK: - Tableview delegate and data source
extension TVViewController: UITableViewDelegate,UITableViewDataSource {
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier) as! HeaderTableViewCell
    if(section != 0){
    headerCell.lblHeaderTitle.text = headerList[section-1].localized(lang: languageCode, comment: "")
    }else{
    headerCell.lblHeaderTitle.text = ""
    }
    return headerCell
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    
    if tableView == dvrPopupTableView
    {
        return 1
    }else
    {
        return headerList.count+1
    }
    
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if tableView == dvrPopupTableView
    {
        return dVRBoxList.count
        
    }else
    {
        if(section == 0){
            return 1
        }else{
            return listArray[section-1].count
        }
    }
    
  }
    
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == dvrPopupTableView
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"dVRPopUPTableViewCell") as! DVRPopUPTableViewCell
        cell.dvrPopUPNameLabel?.text = dVRBoxList[indexPath.row]
        
       
            if indexPath.row == counttable {
            
                cell.dvrPopUPRadioImage?.image = UIImage(named:"SelectedRound")
            }else{
                cell.dvrPopUPRadioImage?.image = UIImage(named:"UnselectedRound")
            }
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
        // ***** //
    else
    {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTabHeaderCellTableView) as! TabHeaderCellTableViewCell
            cell.titleLable.text = NSLocalizedString("Channel Lineup", comment: "")
            //      (cell?.contentView.viewWithTag(1) as! UIButton).addTarget(self, action: //#selector(TVViewController.skipBarButtonTappedAction(_:)), for: .touchUpInside)
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeBasicTableViewCell
            cell.lblHeaderTitle.text = listArray[indexPath.section-1][indexPath.row].localized(lang: languageCode, comment: "")
           // print("dvr list \(listArray[indexPath.section-1][indexPath.row].localized(lang: languageCode, comment: ""))")
            
            
            if indexPath.section == 2
            {
                if indexPath.row == 0 {
                    
                    if counttable == 0
                    {
                        cell.lblHeaderTitle.text = "DVR Selected" + " " + dVRBoxList [counttable]
                        
                    }else if counttable == 1
                    {
                        cell.lblHeaderTitle.text = "DVR Selected" + " " + dVRBoxList [counttable]
                        
                    }else{
                        
                        cell.lblHeaderTitle.text = "DVR Selected" + " " + dVRBoxList [counttable]
                    }
                    
                }
                
            }
            
            
            
            if(indexPath.section == 1){
                cell.iconImageView.image = UIImage(imageLiteralResourceName: tvListIcon[indexPath.row])
            }else{
                cell.iconImageView.image = UIImage(imageLiteralResourceName: dvrListIcon[indexPath.row])
            }
            cell.lblDetailText?.text = ""
            return cell
        }
    }
  }
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if tableView == dvrPopupTableView {
        
        return 0
    }else{
        
        if(section == 0){
            return 0
        }
        
    }
    return CGFloat(kSectionHeight)
  }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
       
        
            if tableView == dvrPopupTableView {
                
                let cell:DVRPopUPTableViewCell? = tableView.cellForRow(at: indexPath) as! DVRPopUPTableViewCell?
                
                if cell?.dvrPopUPRadioImage.image == UIImage(named:"SelectedRound") {
                    
                    cell?.dvrPopUPRadioImage.image = UIImage(named:"UnselectedRound")
                    counttable = indexPath.row
                    
                }else
                {
                    cell?.dvrPopUPRadioImage.image = UIImage(named:"SelectedRound")
                    counttable = indexPath.row
                    
                }
                
                
                
                dvrPopupTableView.reloadData()
                //tableView1.reloadData()
        
            }else
            {
                
                print("indexPath.section : \(indexPath.section) +++++++++++ indexPath.row : \(indexPath.row) ")
                if indexPath.section == 2{
                    
                    
                    dvrPopupTableView.reloadData()

                    if indexPath.row == 0 {
                        
                        customAlertController(alertIndex: 0)
                        
                    }else if indexPath.row == 1
                    {
                        
                        let mdsTokenStr: String = (UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE") as? String) ?? ""
                        if mdsTokenStr.characters.count > 0 {
                            
                            performSegue(withIdentifier: "PastRecordingSegue", sender: self)
                        }else{
                            AlertPopUp(titleStr: "MDS Token", messageStr: "MDS Token is not genrated because server is not responding, please try after some time.")
                        }
                       
                    }else if indexPath.row == 2
                    {
                        
                        let mdsTokenStr: String = (UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE") as? String) ?? ""
                        
                        if mdsTokenStr.characters.count > 0 {
                           performSegue(withIdentifier: "SchedulRecordingSegue", sender: self)
                        }else{
                            AlertPopUp(titleStr: "MDS Token", messageStr: "MDS Token is not genrated because server is not responding, please try after some time.")
                        }
                       
                    }else if indexPath.row == 3
                    {
                        
                        let mdsTokenStr: String = (UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE") as? String) ?? ""
                      
                        if mdsTokenStr.characters.count > 0 {
                           performSegue(withIdentifier: "SeriesRecordingSegue", sender: self)
                        }else{
                            AlertPopUp(titleStr: "MDS Token", messageStr: "MDS Token is not genrated because server is not responding, please try after some time.")
                        }
                        
                    }else
                    {
                        
                        let mdsTokenStr: String = (UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE") as? String) ?? ""
                    
                        if mdsTokenStr.characters.count > 0 {
                           performSegue(withIdentifier: "SchedulARecordingSegue", sender: self)
                        }else{
                            AlertPopUp(titleStr: "MDS Token", messageStr: "MDS Token is not genrated because server is not responding, please try after some time.")
                        }
                        
                    }
                    
                }
            }
            
            
        }else
        {
            AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
   
        // ios Corpus //
        if tableView == dvrPopupTableView {
            return 50
        }else
        {
            if(indexPath.section == 0){
                return CGFloat(kHeaderHeight)
            }
        }
          return CGFloat(kRowHeight)
  }
    
    
    
    
    
    
    func customAlertController(alertIndex: Int)  {
        
        let vc = UIViewController()
        
        let localHeight:CGFloat = CGFloat(50 * dVRBoxList.count)
        
        if localHeight > 250 {
            
            vc.preferredContentSize = CGSize(width: 250,height:200)
            dvrPopupTableView.frame = CGRect(x: 0, y: 0, width: 250, height:200)
            
        }else
        {
            vc.preferredContentSize = CGSize(width: 250,height:localHeight)
            dvrPopupTableView.frame = CGRect(x: 0, y: 0, width: 250, height:localHeight)
        }
        
        dvrPopupTableView.delegate = self
        dvrPopupTableView.dataSource = self
        dvrPopupTableView.bounces = false
        dvrPopupTableView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: "DVRPopUPTableViewCell", bundle: nil)
        dvrPopupTableView.register(nib, forCellReuseIdentifier: "dVRPopUPTableViewCell")
        vc.view.addSubview(dvrPopupTableView)
        
        let editRadiusAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            
        }))
        
        editRadiusAlert.addAction(UIAlertAction(title: "Select", style: .cancel, handler: { action in
            
            print("Pressed Alert Index : \(alertIndex)")
            
            
            
            if self.counttable == 0 {
                
                print("Dad DVR Indexpath === 0")
                
                self.getMDSTokenFromServer(urlString: DAD_DVR_Base_Url+EXT_DAD_DVR_URL)
                
                let localDad_DVR : String = DAD_DVR_Base_Url
                UserDefaults.standard.setValue(localDad_DVR, forKey: "GET_DVR_VALUE")
                
            }else if self.counttable == 1
            {
                print("Family Room DVR Indexpath === 1")
                self.getMDSTokenFromServer(urlString: FAMILY_DVR_Base_Url+EXT_FAMILY_DVR_URL)
                
                let localFamily_DVR : String = FAMILY_DVR_Base_Url
                UserDefaults.standard.setValue(localFamily_DVR, forKey: "GET_DVR_VALUE")
                
            }else
            {
                print("Living Room DVR Indexpath === 2")
                self.getMDSTokenFromServer(urlString: LIVING_DVR_Base_Url+EXT_LIVING_DVR_URL)
                
                let localLiving_DVR : String = LIVING_DVR_Base_Url
                UserDefaults.standard.setValue(localLiving_DVR, forKey: "GET_DVR_VALUE")
            }
            
            
            if alertIndex == 0
            {
               self.tableView1.reloadData()
            }
            
            
        }))
    
        self.present(editRadiusAlert, animated: true)
        
    }
}




