//
//  SchedulARecordingViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 28/02/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class SchedulARecordingViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UIScrollViewDelegate , UISearchBarDelegate, UISearchDisplayDelegate , UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var dVRSpaceSchedulARecdView: UIView!
    @IBOutlet weak var dVRScheduleARecdLabel: UILabel!
    @IBOutlet weak var dVRScheduleARecdProgress: UIProgressView!
    @IBOutlet weak var dVRScheduleARecdValueLabel: UILabel!

    @IBOutlet weak var searchSchduleARecording: UISearchBar!
    @IBOutlet weak var segmentSchedulARecdView: UIView!
    @IBOutlet weak var segmentSchedulARecd: UISegmentedControl!
    
    @IBOutlet weak var scheduleARecdTable: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var postSearchTableView: UITableView!
    
    
    @IBOutlet var timeSloteView: UIView!
    @IBOutlet var calendarButton: UIButton!
    
    @IBOutlet var firstTimeButton: UIButton!
    @IBOutlet var secondTimeButton: UIButton!
    

     var arrayEPGRecd  = NSArray()
     var arrayEPGChannel  = NSArray()
     let date = Date()
    
    var ourStartTimeInterval = TimeInterval()
    var ourMidTimeInterval = TimeInterval()
    var ourEndTimeInterval = TimeInterval()
    var timeSlotArray : NSMutableArray = []
    
    var searchArrayMain : NSMutableArray = []
    var searchArrayNew = NSArray()
    var recentSearchArray : NSMutableArray = []
    var newRecentSearchArray : NSMutableArray = []
    
    
    var loaderInEPG: LoaderView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Schedule a Recording".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotatedInEPGController), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func deviceRotatedInEPGController()
    {
        if loaderInEPG != nil
        {
            loaderInEPG?.removeFromSuperview()
            loaderInEPG = LoaderView()
            loaderInEPG?.initLoader()
            if let loaderView = loaderInEPG
            {
                self.view.addSubview(loaderView)
            }
        }
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("This EPG Screen")
        
        self.startLoaderEPGController()
        
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        getEPGDataFromServer(urlstring: Dvr_Base_URl + DVR_EPG_URL)
        getDVRSpaceFromServerSchedulAEPG(urlString: Dvr_Base_URl + DVR_SPACE_Url)
       
        
        firstTimeButton.setTitleColor(kColor_TabBarSelected, for: .normal)
        firstTimeButton.backgroundColor = UIColor.white
        
        secondTimeButton.setTitleColor(kColor_TabBarSelected, for: .normal)
        secondTimeButton.backgroundColor = UIColor.white
        
        
        self.dVRSpaceSchedulARecdView.backgroundColor = kColor_DVRSpacebackground
        self.dVRScheduleARecdProgress.transform = CGAffineTransform.init(scaleX: 1.0, y: 10.0)
        self.dVRScheduleARecdProgress.tintColor = kColor_TabBarSelected
        self.dVRScheduleARecdProgress.trackTintColor = kColor_NavigationBarColor
        
        self.segmentSchedulARecdView.backgroundColor = UIColor.white
        self.segmentSchedulARecd.tintColor = kColor_TabBarSelected
        
        self.searchTableView.isHidden = true
        self.searchTableView.tableFooterView = UIView()
        
        self.postSearchTableView.isHidden = true
        self.postSearchTableView.tableFooterView = UIView()
        
        
        self.navigationItem.hidesBackButton = true
        
        
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SchedulARecordingViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        
    }
    
    
    func back(sender: UIBarButtonItem) {
        
        print("click Back Button")
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // ***** UITableView Method ***** //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchTableView {
            
            return self.recentSearchArray.count
            
        }else if tableView == postSearchTableView
        {
            return self.searchArrayNew.count
           
        }else
        {
            return self.timeSlotArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == searchTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"scheduleARecordingSearchTableViewCell") as! ScheduleARecordingSearchTableViewCell
            cell.searchNameLabel.text = (self.recentSearchArray[self.recentSearchArray.count - 1 - indexPath.row] as? String) ?? " "
            
            cell.selectionStyle = .none
            return cell
            
        }else if tableView == postSearchTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"postSearchTableViewCell") as! PostSearchTableViewCell
            cell.nameLabelPostSearch.text = (self.searchArrayNew[indexPath.row] as? String) ?? " "
            print(" Title : \((self.searchArrayNew[indexPath.row] as? String) ?? " ")")
        
//            if indexPath.row == 2 {
//                
//                cell.addDeleteRecdButton.setImage(UIImage(named:"dVR_Delete_Recording"), for: .normal)
//            }
            cell.addDeleteRecdButton.tag = indexPath.row
            
            
            cell.selectionStyle = .none
            return cell

        }else
        {
            
               let cell = tableView.dequeueReusableCell(withIdentifier:"schedulARecordingTableCell") as! SchedulARecordingTableCell
               cell.TittleLabel.text = ((self.arrayEPGRecd.value(forKey: "CallSign") as! NSArray).object(at: indexPath.row) as? String) ?? " "
               let channelNO: Int = ((self.arrayEPGRecd.value(forKey: "ChannelNumber") as! NSArray).object(at: indexPath.row) as? Int) ?? 0
               cell.channelNO.text = String(channelNO)
            
            
              let schdulesArrayLocal: NSArray = (self.arrayEPGChannel.value(forKey: "Schedules") as! NSArray).object(at: indexPath.row) as! NSArray
              print("schdulesArrayLocal : \(schdulesArrayLocal)")
            
        
                 let slotString: String = ((self.timeSlotArray as NSArray).object(at: indexPath.row) as AnyObject) as! String
                 let time_three = slotString.components(separatedBy: "-")
            
                 let time_three_Count : Int = Int(time_three [2])!
                 let time_two_Count : Int = Int(time_three [1])!
                 let time_one_Count : Int = Int(time_three [0])!
            
            
                let screenWidth: CGFloat = UIScreen.main.bounds.width
            
                let mainThirdView : UIView = UIView()
                let firstLabel : UILabel = UILabel()
                let secondLabel : UILabel = UILabel()
            
                let mainSecondView : UIView = UIView()
                let mainfirstView : UIView = UIView()
            
            
                
                mainSecondView.tag = 200
                cell.contentView.viewWithTag(200)?.removeFromSuperview()
                
                mainfirstView.tag = 100
                cell.contentView.viewWithTag(100)?.removeFromSuperview()
            
            
                mainThirdView.tag = 300
                cell.contentView.viewWithTag(300)?.removeFromSuperview()

            
            
                if time_three_Count > 0
                {
                     print("time_three_Count :\(time_three_Count) +++++++ indexPath.row :\(indexPath.row)")
                    
                    
            
                    mainThirdView.frame = CGRect(x: 60, y: 0, width: screenWidth-60, height:60)
                    mainThirdView.backgroundColor = UIColor.blue
                    
                
                    firstLabel.frame = CGRect(x: 5, y: 0, width: mainThirdView.frame.width-5, height:30)
                    firstLabel.backgroundColor = UIColor.white
                    mainThirdView.addSubview(firstLabel)
                    
                
                    secondLabel.frame = CGRect(x: 5, y: 30, width: mainThirdView.frame.width-5, height:30)
                    secondLabel.backgroundColor = UIColor.white
                    mainThirdView.addSubview(secondLabel)
                    
                    
                    for var j in 0..<schdulesArrayLocal.count
                    {
                        let titleStr: String = ((schdulesArrayLocal.value(forKey: "Title") as! NSArray).object(at: j) as? String) ?? " "
                        firstLabel.text = titleStr
                        
                        let episodeTitleStr: String = ((schdulesArrayLocal.value(forKey: "EpisodeTitle") as! NSArray).object(at: j) as? String) ?? " "
                        secondLabel.text = episodeTitleStr
                        
                        let ProgramIdInt: Int = Int(((schdulesArrayLocal.value(forKey: "ProgramId") as! NSArray).object(at: j) as! String))!
                        firstLabel.tag = ProgramIdInt
                        secondLabel.tag = ProgramIdInt
                        
                        break
                    }
                    
                    let firstLabelmainTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlingInnerScreenTapThird(_:)))
                    firstLabel.isUserInteractionEnabled = true
                    firstLabel.addGestureRecognizer(firstLabelmainTapGesture)
                    
                    let secondLabelmainTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlingInnerScreenTapThird(_:)))
                    secondLabel.isUserInteractionEnabled = true
                    secondLabel.addGestureRecognizer(secondLabelmainTapGesture)
                    
                    cell.contentView.addSubview(mainThirdView)
                    
                
               }else
               {
                   mainThirdView.backgroundColor = UIColor.white
                
                
                    mainfirstView.frame = CGRect(x: 60, y: 0, width: (screenWidth-60) / 2, height:60)
                    mainfirstView.backgroundColor = UIColor.blue
                    cell.contentView.addSubview(mainfirstView)
                    
                    mainSecondView.frame = CGRect(x: ((screenWidth-60) / 2 ) + 60 , y: 0, width: (screenWidth-60) / 2 , height:60)
                    mainSecondView.backgroundColor = UIColor.blue
                    cell.contentView.addSubview(mainSecondView)
                    
                    let firstViewWidth: CGFloat = (mainfirstView.frame.width / CGFloat(time_one_Count))
                    let secondViewWidth: CGFloat = (mainSecondView.frame.width / CGFloat(time_two_Count))
                
                
                    for var i in 0..<time_one_Count
                    {
        
                            let firstViewLabelName : UILabel = UILabel()
                            firstViewLabelName.frame = CGRect(x: 5 + i * Int(firstViewWidth) , y: 0, width: Int(firstViewWidth-5), height:30)
                            firstViewLabelName.backgroundColor = UIColor.white
                            mainfirstView.addSubview(firstViewLabelName)
                            
                            let firstViewLabelTittle : UILabel = UILabel()
                            firstViewLabelTittle.frame = CGRect(x: 5 + i * Int(firstViewWidth) , y: 30, width: Int(firstViewWidth-5), height:30)
                            firstViewLabelTittle.backgroundColor = UIColor.white
                            mainfirstView.addSubview(firstViewLabelTittle)
                        
                        
                       
                            let titleStr: String = ((schdulesArrayLocal.value(forKey: "Title") as! NSArray).object(at: i) as? String) ?? " "
                            firstViewLabelName.text = titleStr
                            
                            let episodeTitleStr: String = ((schdulesArrayLocal.value(forKey: "EpisodeTitle") as! NSArray).object(at: i) as? String) ?? " "
                            firstViewLabelTittle.text = episodeTitleStr
                        
                        
                            let ProgramIdInt: Int = Int(((schdulesArrayLocal.value(forKey: "ProgramId") as! NSArray).object(at: i) as! String))!
                            firstViewLabelName.tag = ProgramIdInt
                            firstViewLabelTittle.tag = ProgramIdInt
                        
                        
                            let firstViewLabelNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlingInnerScreenTapSecond(_:)))
                            firstViewLabelName.isUserInteractionEnabled = true
                            firstViewLabelName.addGestureRecognizer(firstViewLabelNameTapGesture)
                            
                            let firstViewLabelTittleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlingInnerScreenTapSecond(_:)))
                            firstViewLabelTittle.isUserInteractionEnabled = true
                            firstViewLabelTittle.addGestureRecognizer(firstViewLabelTittleTapGesture)
                    
                    }
                
               
                
                
                    for var j in 0..<time_two_Count
                    {
                            let secondViewLabelName : UILabel = UILabel()
                            secondViewLabelName.frame = CGRect(x: 5 + j * Int(secondViewWidth) , y: 0, width: Int(secondViewWidth-5), height:30)
                            secondViewLabelName.backgroundColor = UIColor.white
                            mainSecondView.addSubview(secondViewLabelName)
                            
                            let secondViewLabelTittle : UILabel = UILabel()
                            secondViewLabelTittle.frame = CGRect(x: 5 + j * Int(secondViewWidth) , y: 30, width: Int(secondViewWidth-5), height:30)
                            secondViewLabelTittle.backgroundColor = UIColor.white
                            mainSecondView.addSubview(secondViewLabelTittle)
                        
                        
                            let titleStr: String = ((schdulesArrayLocal.value(forKey: "Title") as! NSArray).object(at: j + time_one_Count) as? String) ?? " "
                            secondViewLabelName.text = titleStr
                            
                            let episodeTitleStr: String = ((schdulesArrayLocal.value(forKey: "EpisodeTitle") as! NSArray).object(at: j + time_one_Count) as? String) ?? " "
                            secondViewLabelTittle.text = episodeTitleStr
                        
                        
                            let ProgramIdInt: Int = Int(((schdulesArrayLocal.value(forKey: "ProgramId") as! NSArray).object(at: j + time_one_Count) as! String))!
                            secondViewLabelName.tag = ProgramIdInt
                            secondViewLabelTittle.tag = ProgramIdInt
                        
                        
                            let secondViewLabelNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlingInnerScreenTapFirst(_:)))
                            secondViewLabelName.isUserInteractionEnabled = true
                            secondViewLabelName.addGestureRecognizer(secondViewLabelNameTapGesture)
                            
                            let secondViewLabelTittleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlingInnerScreenTapFirst(_:)))
                            secondViewLabelTittle.isUserInteractionEnabled = true
                            secondViewLabelTittle.addGestureRecognizer(secondViewLabelTittleTapGesture)
                    }
            
                
                   if time_one_Count == 0
                   {
                       mainfirstView.backgroundColor = UIColor.white
                   }
                
                   if time_two_Count == 0
                   {
                        mainSecondView.backgroundColor = UIColor.white
                   }
                
                
            
               }
            
            cell.selectionStyle = .none
            return cell
        }
        
        
}
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        if tableView == searchTableView {
            
            
            
        }else if tableView == postSearchTableView
        {
            
            let selectSearchStr: String = (self.searchArrayNew[indexPath.row] as? String) ?? " "
            print("selectSearchStr : \(selectSearchStr)")
            searchSchduleARecording.text = selectSearchStr
            self.filterTableViewForEnterText(searchText: selectSearchStr)
          
            
        
            if UserDefaults.standard.array(forKey: "RECENT_SEARCH_ARRAY") != nil {
                
                self.recentSearchArray = NSMutableArray.init(array: UserDefaults.standard.array(forKey: "RECENT_SEARCH_ARRAY")!)
                
                if self.recentSearchArray.count == 5 {
                    
                    self.recentSearchArray.removeObject(at: 0)
                    self.recentSearchArray.insert(selectSearchStr, at:4)
                    UserDefaults.standard.set( self.recentSearchArray, forKey: "RECENT_SEARCH_ARRAY")
                    UserDefaults.standard.synchronize()
                    
                }else
                {
                    self.recentSearchArray.add(selectSearchStr)
                    UserDefaults.standard.set( self.recentSearchArray, forKey: "RECENT_SEARCH_ARRAY")
                    UserDefaults.standard.synchronize()
                }

                
            }else
            {
                self.recentSearchArray.add(selectSearchStr)
                UserDefaults.standard.set( self.recentSearchArray, forKey: "RECENT_SEARCH_ARRAY")
                UserDefaults.standard.synchronize()
            }
            
            
            print("self.recentSearchArray : \(self.recentSearchArray)")
            
            
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == searchTableView {
            
            return 44
            
        }else if tableView == postSearchTableView
        {
            return 60
            
        }else
        {
            return 65
        }
    
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            
            print("Landscape")
            
            
        } else {
            
            print("Portrait")
            
        }
        
        self.scheduleARecdTable .reloadData();
    }
    
    
    func convertStringToMiliseconds24(dateStr: String) -> TimeInterval {
        
        let dateFormatStartTime = DateFormatter()
        dateFormatStartTime.dateFormat = "HH:mm:ss.SSSS"
        let firstTime = dateFormatStartTime.date(from: dateStr)
        let firstTimeInerval : TimeInterval = ((firstTime?.timeIntervalSince1970)! * 1000)
        return firstTimeInerval
    }
    
    func convertStringToMiliseconds12(dateStr: String) -> TimeInterval {
        
        let dateFormatStartTime = DateFormatter()
        dateFormatStartTime.dateFormat = "hh:mm a"
        let firstTime = dateFormatStartTime.date(from: dateStr)
        let firstTimeInerval : TimeInterval = ((firstTime?.timeIntervalSince1970)! * 1000)
        return firstTimeInerval
    }
    
    
    
    func handlingInnerScreenTapThird(_ sender: UITapGestureRecognizer) {
        
        print("Tag Valuen Third == \(sender.view?.tag)")
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
        
                let DetailsController = self.storyboard?.instantiateViewController(withIdentifier: "PastRecordingDetailsController") as! PastRecordingDetailsController
                self.navigationController?.pushViewController(DetailsController, animated: true)
                DetailsController.EPGProgramID = sender.view?.tag
                DetailsController.naviTittle = "Schedule a Recordings"
        }else
        {
            AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
       
    }
    
    
    func handlingInnerScreenTapSecond(_ sender: UITapGestureRecognizer) {
        
    
        print("Tag Value Second == \(sender.view?.tag)")
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
        
            let DetailsController = self.storyboard?.instantiateViewController(withIdentifier: "PastRecordingDetailsController") as! PastRecordingDetailsController
            self.navigationController?.pushViewController(DetailsController, animated: true)
            DetailsController.EPGProgramID = sender.view?.tag
            DetailsController.naviTittle = "Schedule a Recordings"
            
        }else
        {
            AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    func handlingInnerScreenTapFirst(_ sender: UITapGestureRecognizer) {
        
        print("Tag Value First == \(sender.view?.tag)")
      if HotwireCommunicationApi.rechability?.isReachable == true {
        
            let DetailsController = self.storyboard?.instantiateViewController(withIdentifier: "PastRecordingDetailsController") as! PastRecordingDetailsController
            self.navigationController?.pushViewController(DetailsController, animated: true)
            DetailsController.EPGProgramID = sender.view?.tag
            DetailsController.naviTittle = "Schedule a Recordings"
        
        }else
        {
          AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }

    }

    

    // *********************************** //
    
    
    

    @IBAction func clickCalendarButton(_ sender: UIButton) {
        
       print("click on calendra button")
    }
    
    @IBAction func clickTimeButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func clickSearchAddDeleteRecdButton(_ sender: UIButton) {
        
        
        let imageName = sender.tag
        print("get Button Image : \(imageName)")
        
        if sender.tag == 2 {
            
            customAlertControllerRecordingDelete(alertTittle: "Delete Recording", alertMessage: "Are you sure you want to delete The Americans from your DVR recordings?")
            
        }else
        {
        
          customAlertController(alertTittle: "Add Recording", alertMessage: "America's Got Talent will air 05/03/2017 at 8 PM - 10 PM on NBC. Do you wish to add this to your Fision Home DVR?")
        }
    }
    
    
    // ***** UISearchBar Method ***** //
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
        print("searchBarTextDidBeginEditing")
        
        if UserDefaults.standard.array(forKey: "RECENT_SEARCH_ARRAY") != nil
        {
            self.recentSearchArray = NSMutableArray.init(array: UserDefaults.standard.array(forKey: "RECENT_SEARCH_ARRAY")!)
            
            if  self.recentSearchArray.count > 0 {
                
                
                self.searchTableView.isHidden = false
                self.searchTableView.reloadData()
                
            }else{
                
                
                self.postSearchTableView.isHidden = false
                self.postSearchTableView.reloadData()
            }
            
        }else
        {
            self.searchTableView.isHidden = true
            self.postSearchTableView.isHidden = false
            self.postSearchTableView.reloadData()
        }
        
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("searchBarSearchButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
       print("searchBar")
       self.segmentSchedulARecdView.isHidden = true
       self.scheduleARecdTable.isHidden = true
        
        print("searchDisplayController")
        
        if searchText.characters.count == 0 {
            
            self.searchTableView.isHidden = false
            self.postSearchTableView.isHidden = true
            self.searchTableView.reloadData()

        }else{
            
            self.searchTableView.isHidden = true
            self.postSearchTableView.isHidden = false
            self.filterTableViewForEnterText(searchText: searchText)
        }
        
    }
    
    
    func filterTableViewForEnterText(searchText: String) {
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchText)
        //let array = (self.arrayEPGRecd.value(forKey: "Name") as! NSArray).filtered(using: <#T##NSPredicate#>)
        let array = (self.searchArrayMain as NSArray).filtered(using: searchPredicate)
        print("array : \(array)");
        self.searchArrayNew = array as! [String] as NSArray
        self.postSearchTableView.reloadData()
    }
    
    
    
    // *********************************** //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func customAlertController(alertTittle: NSString, alertMessage: NSString)  {
        
        
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height:40)
        
        let otherButton : UIButton = UIButton()
        otherButton.frame = CGRect(x: 0, y: 0, width: 250, height:30)
        otherButton.setTitle("View Other Showtimes", for: .normal)
        otherButton.setTitleColor(UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0), for: .normal)
        vc.view.addSubview(otherButton)
        
        let actionSheetController: UIAlertController = UIAlertController(title: alertTittle as String, message: alertMessage as String, preferredStyle: .alert)
            actionSheetController.setValue(vc, forKey: "contentViewController")
        
        
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            //Just dismiss the action sheet
            
            self.customAlertControllerRecordingAdded(alertTittle: "Recording Added", alertMessage: "America's Got Talent  has been added in your Fision Home DVR. For more information , please visit the Scheduled Recordings tab.")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
     
        actionSheetController.addAction(yesAction)
        actionSheetController.addAction(cancelAction)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func customAlertControllerRecordingAdded(alertTittle: NSString, alertMessage: NSString)  {
        
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: alertTittle as String, message: alertMessage as String, preferredStyle: .alert)
        
        
        
        let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            
           self.navigationController?.popViewController(animated:true)
            
        }
        
    
        actionSheetController.addAction(yesAction)
   
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    
    func customAlertControllerRecordingDelete(alertTittle: NSString, alertMessage: NSString)  {
        
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: alertTittle as String, message: alertMessage as String, preferredStyle: .actionSheet)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
            
            self.customAlertControllerRecordingDeleteConfermation(alertTittle: "Recording Deleted", alertMessage: "The Americans was successfully deleted from your fision Home DVR.")
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            
        }
        
        
        actionSheetController.addAction(deleteAction)
        actionSheetController.addAction(cancelAction)
        
        
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func customAlertControllerRecordingDeleteConfermation(alertTittle: NSString, alertMessage: NSString)  {
        
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: alertTittle as String, message: alertMessage as String, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .destructive) { action -> Void in
            
            self.postSearchTableView.isHidden = true
            self.searchTableView.isHidden = false
        }
        
    
        actionSheetController.addAction(okAction)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func getDVRSpaceFromServerSchedulAEPG(urlString : String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
           // self.startLoaderEPGController()
            
            let url = NSURL(string: urlString)!
             print("DVR Space URl :\(url)")
            
            let request = NSMutableURLRequest(url: url as URL)
            
            request.httpMethod = "GET"
            request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                
                do {
                    
                    let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                    
                    let freeBytes : Double = dict["FreeBytes"] as! Double
                    let totalBytes : Double = dict["TotalBytes"] as! Double
                    let dvrSpaceValue : Double = 100 - ( (freeBytes / totalBytes) * 100)
                    let finalValue : Int = Int(round(dvrSpaceValue))
                    
                    
                    DispatchQueue.main.async {
                        
                        self.dVRScheduleARecdValueLabel.text = String(finalValue) + "%"
                        self.dVRScheduleARecdProgress.setProgress(Float(dvrSpaceValue / 100), animated:false)
                    }
                    
                    
                }catch let error as NSError
                {
                    self.stopLoaderEPGController()
                    self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                    print(error.code)
                    
                }
                
            }
            
            task.resume()
        }else
        {
           AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    func getEPGDataFromServer(urlstring : String)
    {
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
     
                //self.startLoaderEPGController()
            
                let url : String = urlstring
                let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as String as NSString
                let searchURL : NSURL = NSURL(string: urlStr as String)!
            
                print("EPG URl :\(urlstring)")
                
                let request = NSMutableURLRequest(url: searchURL as URL)
                
                request.httpMethod = "GET"
                request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
                request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                    
                    do {
                        
                        let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                       
                        //print("Dict : \(dict)")
                        self.arrayEPGRecd = dict["Items"] as! NSArray
                        
                        print("self.arrayEPGRecd :\(self.arrayEPGRecd)")
                        
                       
                        var totalStationID : String = ""
                        for var i in 0..<self.arrayEPGRecd.count
                        {
                            totalStationID += "sid=" + "\((self.arrayEPGRecd.value(forKey: "StationId") as! NSArray).object(at: i) as! String)" + "&"
                        }
                        
                       // print("Total ID:\(totalStationID)")
                        
                       
                        
                       let roundMin: Int = self.roundedTime()
                       //print("roundMin : \(roundMin)")
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        
                        let dateFormatter12 = DateFormatter()
                        dateFormatter12.dateFormat = "hh:mm a"
                        
                        let finalTime1 = Calendar.current.date(byAdding: .minute, value: -roundMin, to: Date())
                        let finalStartTime: String = dateFormatter.string(from: finalTime1!)
                        let finalStartTime12: String = dateFormatter12.string(from: finalTime1!)
                        self.ourStartTimeInterval = self.convertStringToMiliseconds12(dateStr: finalStartTime12)
                        print("self.ourStartTimeInterval \(self.ourStartTimeInterval)")
                        
                        
                        let finalTime2 = Calendar.current.date(byAdding: .minute, value: -roundMin + 30, to: Date())
                        //let finalMidTime: String = dateFormatter.string(from: finalTime2!)
                        let finalMidTime12: String = dateFormatter12.string(from: finalTime2!)
                        self.ourMidTimeInterval = self.convertStringToMiliseconds12(dateStr: finalMidTime12)
                        print("self.ourMidTimeInterval \(self.ourMidTimeInterval)")

                        

                        let finalTime3 = Calendar.current.date(byAdding: .minute, value: -roundMin + 60, to: Date())
                        let finalEndTime: String = dateFormatter.string(from: finalTime3!)
                        let finalEndTime12: String = dateFormatter12.string(from: finalTime3!)
                        self.ourEndTimeInterval = self.convertStringToMiliseconds12(dateStr: finalEndTime12)
                        print("self.ourEndTimeInterval \(self.ourEndTimeInterval)")
                        
                        
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let cDate = Calendar.current.date(byAdding: .minute, value: 0, to: Date())
                        let currentDate: String = dateFormatter.string(from: cDate!)
                        //print("currentDate : \(currentDate)")
                        
                    
                        let firstUrlStr : String = "startUtc=" + "\(currentDate)" + "T" + "\(finalStartTime)" + ":00Z&endUtc=" + "\(currentDate)" + "T" + "\(finalEndTime)" + ":00Z"
                        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
                        self.getEPGTimeDataFromServer(urlstring: Dvr_Base_URl + DVR_EPG_TIME_Url_1 + totalStationID + firstUrlStr)
                        
                        
                        
                         DispatchQueue.main.async {
                            
                             self.firstTimeButton.setTitle(finalStartTime12, for: .normal)
                             self.secondTimeButton.setTitle(finalMidTime12, for: .normal)
                         }
                        
                    
                    }catch let error as NSError
                    {
                        self.stopLoaderEPGController()
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        print(error.code)
                        
                    }
                    
                }
                
                task.resume()
        }else
        {
           AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    
    func getEPGTimeDataFromServer(urlstring : String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
        
                let url : String = urlstring
                let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as String as NSString
                let searchURL : NSURL = NSURL(string: urlStr as String)!
                //print(searchURL)
                
                print("EPG URl :\(urlstring)")
                
                let request = NSMutableURLRequest(url: searchURL as URL)
                
                request.httpMethod = "GET"
                request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
                request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                    
                    do {
                        
                        let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                        
                        print("EPG Time Dict: \(dict)")
                        self.arrayEPGChannel = dict["Stations"] as! NSArray
                        print("self.arrayEPGChannel: \(self.arrayEPGChannel.count)")
                        
                        
                        self.loadTimeSlot(array: self.arrayEPGChannel)
                        
                        self.stopLoaderEPGController()
                        
                        DispatchQueue.main.async {
                            
                            self.scheduleARecdTable.reloadData()
                        }
                        
                        
                        
                    }catch let error as NSError
                    {
                        
                        self.stopLoaderEPGController()
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        print(error.code)
                        
                    }
                    
                }
                
                task.resume()
        }else
        {
           AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }


    func roundedTime() -> Int
    {
        let calendar = Calendar.current
        let currentMinutes = calendar.component(.minute, from: date)
        print("minutes = :\(currentMinutes)")
        
        if currentMinutes > 0 && currentMinutes < 30 {
            
            return currentMinutes - 00
        }else if currentMinutes > 30 && currentMinutes < 60
        {
             return currentMinutes - 30
            
        }else
        {
            return 00
        }
        
    }
    
    
    func loadTimeSlot(array: NSArray) {
        
        
         for var i in 0..<array.count
         {
        
                    let schdulesArray: NSArray = (array.value(forKey: "Schedules") as! NSArray).object(at: i) as! NSArray
                    
                    var time_one_Count: Int = 0
                    var time_two_Count: Int = 0
                    var time_three_Count: Int = 0
                    
            
                    for var j in 0..<schdulesArray.count
                    {
                            let fullStartTime: String = (schdulesArray.value(forKey: "StartUtc") as! NSArray).object(at: j) as! String
                            let fullStart  = fullStartTime.components(separatedBy: "T")
                            let res_Start_Time : TimeInterval = convertStringToMiliseconds24(dateStr: fullStart [1])
                            // print("req_Start_Time : \(res_Start_Time)")
                            
                            
                            let fullEndTime: String = (schdulesArray.value(forKey: "EndUtc") as! NSArray).object(at: j) as! String
                            let fullEnd  = fullEndTime.components(separatedBy: "T")
                            let res_End_Time: TimeInterval = convertStringToMiliseconds24(dateStr: fullEnd [1])
                            //print("req_End_Time : \(res_End_Time)")
                            
                            
                            
                            if res_Start_Time >= self.ourStartTimeInterval && res_End_Time <= self.ourMidTimeInterval
                            {
                                time_one_Count += 1
                                
                            }else if res_Start_Time >= self.ourMidTimeInterval && res_End_Time <= self.ourEndTimeInterval
                            {
                                time_two_Count += 1
                                
                            }else if res_Start_Time <= self.ourStartTimeInterval && res_End_Time <= self.ourMidTimeInterval
                            {
                                time_one_Count += 1
                                
                            }else if res_Start_Time >= self.ourMidTimeInterval && res_End_Time >= self.ourEndTimeInterval
                            {
                                time_two_Count += 1
                                
                            }else if res_Start_Time <= self.ourStartTimeInterval && res_End_Time >= self.ourEndTimeInterval
                            {
                                time_three_Count += 1
                            }
                        
                            self.searchArrayMain.add((schdulesArray.value(forKey: "Title") as! NSArray).object(at: j))
                    
                    }
            
                 let localStr: String = "\(String(time_one_Count))" + "-" + "\(String(time_two_Count))" + "-" + "\(String(time_three_Count))"
            
                 self.timeSlotArray.add(localStr)
            
            
    
          }
        
        print("self.timeSlotArray \(self.timeSlotArray)")
        print("self.searchArrayMain \(self.searchArrayMain)")
        
        
         self.searchArrayNew = self.searchArrayMain
         print("First Time Fill self.searchArrayMain :\(self.searchArrayMain.count)")
      }
    
    
    func startLoaderEPGController() {
        
        loaderInEPG = LoaderView()
        loaderInEPG?.initLoader()
        loaderInEPG?.kLoaderLabelText = "Please wait..."
        self.view.addSubview(loaderInEPG!)
    }
    
    
    func stopLoaderEPGController()  {
        
        DispatchQueue.main.async {
            self.loaderInEPG?.removeFromSuperview()
            self.loaderInEPG = nil
        }
    }
    
    func AlertPopUp(titleStr: String, messageStr: String)  {
        
        let alertPopupController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertPopupController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        
        self.present(alertPopupController, animated: true)
        
    }
    
}
