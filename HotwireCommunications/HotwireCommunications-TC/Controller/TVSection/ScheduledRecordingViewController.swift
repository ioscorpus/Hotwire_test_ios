//
//  ScheduledRecordingViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 27/02/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class ScheduledRecordingViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var dVRSpaceView: UIView!
    @IBOutlet weak var dVRSpaceSchedulLabel: UILabel!
    @IBOutlet weak var dVRSchedulProgressView: UIProgressView!
    @IBOutlet weak var dVRSchedulValueLabel: UILabel!
    
    @IBOutlet weak var schedulTableView: UITableView!
    @IBOutlet weak var schedulAddRecdButton: UIButton!
    
    
    
    
     var scheduledRecdArray  = NSArray()
     var scheduledRecdArrayMain = [Date]()
     var scheduledRecdArrayMainSecond : NSMutableArray = []
     var scheduledRecdArrayMaincountArray : NSMutableArray = []
    
     var counttable : Int = -1
    
    var loaderInScheduled: LoaderView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.title = "Scheduled Recordings".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotatedInScheduledController), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func deviceRotatedInScheduledController()
    {
        if loaderInScheduled != nil
        {
            loaderInScheduled?.removeFromSuperview()
            loaderInScheduled = LoaderView()
            loaderInScheduled?.initLoader()
            if let loaderView = loaderInScheduled
            {
                self.view.addSubview(loaderView)
            }
        }
    }

    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        getDVRSpaceFromServerSchedul(urlString: Dvr_Base_URl + DVR_SPACE_Url)
        getScheduledRecordingDataFromServer(urlString: Dvr_Base_URl + DVR_SCHEDUEL_REC_Url)

        
        self.dVRSpaceView.backgroundColor = kColor_DVRSpacebackground
        self.dVRSchedulProgressView.transform = CGAffineTransform.init(scaleX: 1.0, y: 10.0)
        self.dVRSchedulProgressView.tintColor = kColor_TabBarSelected
        self.dVRSchedulProgressView.trackTintColor = kColor_NavigationBarColor
        self.schedulAddRecdButton.backgroundColor = kColor_TabBarSelected
        
    }
    
    func getCurrentDateName (dateStr: String) -> String  {
        
        var Day: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = Date()
        let date = dateFormatter.string(from: currentDate)
    
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let yesterdayDate = dateFormatter.string(from: yesterday!)
    
        let tomomrrow = Calendar.current.date(byAdding: .day, value: +1, to: Date())
        let tomomrrowDate = dateFormatter.string(from: tomomrrow!)
       
        
        if dateStr == date
        {
            Day = "TODAY"
            
        }else if (dateStr == yesterdayDate)
        {
            Day = "YESTEDAY"
            
        }else if (dateStr == tomomrrowDate)
        {
            Day = "TOMORROW"
            
        }else
        {
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todayDate = formatter.date(from: dateStr)!
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
            let date = dateFormatter.date(from: dateStr) //according to date format your date string
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let newDate = dateFormatter.string(from: date!)
           
        
            if weekDay == 1
            {
                Day = "Sunday "+newDate
                
            }else if weekDay == 2
            {
                Day = "Monday "+newDate
            }else if weekDay == 3
            {
                Day = "Tuesday "+newDate
            }else if weekDay == 4
            {
                Day = "Wednesday "+newDate
            }else if weekDay == 5
            {
                Day = "Thursday "+newDate
            }else if weekDay == 6
            {
                Day = "Friday "+newDate
            }else if weekDay == 7
            {
                Day = "Saturday "+newDate
            }
            
           
        }
    
        return Day

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.scheduledRecdArrayMainSecond.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier:"scheduledrecordTableCell") as! ScheduledrecordTableCell
        
        
    
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "yyyy-MM-dd"
        
        let fullDateTime : NSString = (self.scheduledRecdArrayMainSecond.value(forKey: "StartUtc") as! NSArray).object(at:indexPath.row) as! NSString
        let fullDate = fullDateTime.components(separatedBy: "T")
        
        cell.sectionDateLabel.text = getCurrentDateName(dateStr: fullDate [0] as String)
        
        if indexPath.row == 0 {
            
            cell.sectionView.isHidden = false
           
            
          }else
          {
        
    
             let fullDateTimePre : NSString = (self.scheduledRecdArrayMainSecond.value(forKey: "StartUtc") as! NSArray).object(at:indexPath.row-1) as! NSString
             let fullDatePre = fullDateTimePre.components(separatedBy: "T")
            
        
              if fullDatePre [0] == fullDate [0] {
                
                 cell.sectionView.isHidden = true
              }else
              {
                cell.sectionView.isHidden = false
              }
            
        }
        

        let tittleStr : NSString = (self.scheduledRecdArrayMainSecond.value(forKey: "Title") as! NSArray).object(at:indexPath.row) as! NSString
        cell.schedProgNameLabel.text = tittleStr as String
        
        let desStr : NSString = (self.scheduledRecdArrayMainSecond.value(forKey: "Description") as! NSArray).object(at:indexPath.row) as! NSString
        cell.schedSynopsisLabel.text = desStr as String

        let channelNoStr : Int = (self.scheduledRecdArrayMainSecond.value(forKey: "ChannelNumber") as! NSArray).object(at:indexPath.row) as! Int
        cell.schedChannelNameLabel.text = String(channelNoStr)
        
        
        
      

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        let date = dateFormatter.date(from: fullDate [0]) //according to date format your date string
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let newDate = dateFormatter.string(from: date!)
        
        cell.schedDateLabel.text = newDate as String
        
        
        

        let dateFormattertime = DateFormatter()
        dateFormattertime.dateFormat = "HH:mm:ss.SSSS"
        let time = dateFormattertime.date(from: fullDate [1])
        dateFormatter.dateFormat = "hh:mm a"
        let date24 = dateFormatter.string(from: time!)
        
        cell.schedTimeValLabel.text = date24 as String
        
      
        cell.schedOptionButton.tag = indexPath.row
        cell.schedDeleteButton.tag = indexPath.row
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 155
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func clickSchedulAddRecdButton(_ sender: UIButton) {
        
        print("clickSchedulAddRecdButton")
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
        
           let scheduledRecordingController = self.storyboard?.instantiateViewController(withIdentifier: "schedulARecordingViewController") as! SchedulARecordingViewController
           self.navigationController?.pushViewController(scheduledRecordingController, animated: true)
            
        }else
        {
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
        
    }
    
    @IBAction func clickSchedulDeleteButton(_ sender: UIButton) {
        
        print("clickSchedulDeleteButton")
       
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
            for var i in 0..<self.scheduledRecdArrayMainSecond.count
            {
                
                if i == sender.tag {
                    
                    let idString : NSString = ((self.scheduledRecdArrayMainSecond.value(forKey: "Id") as! NSArray).object(at:i) as? NSString) ?? " "
                    let titleNameStr : NSString = ((self.scheduledRecdArrayMainSecond.value(forKey: "Title") as! NSArray).object(at:i) as? NSString) ?? " "
                    customAlertController(idString: idString, titleName: titleNameStr)
                    
                    break
                }
            }
            
        }else{
            
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }

        
    }
   
    
    @IBAction func clickSchedulOptionButton(_ sender: UIButton) {
        
        print("clickSchedulOptionButton \(sender.tag)")
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
        
            for var i in 0..<self.scheduledRecdArrayMainSecond.count
            {
                
                if i == sender.tag {
                    
                    let idString : NSString = (self.scheduledRecdArrayMainSecond.value(forKey: "Id") as! NSArray).object(at:i) as! NSString
                    print("idString : \(idString)")
                    
                    
                    let DetailsController = self.storyboard?.instantiateViewController(withIdentifier: "PastRecordingDetailsController") as! PastRecordingDetailsController
                    self.navigationController?.pushViewController(DetailsController, animated: true)
                    DetailsController.stringPassed = idString as String!
                    DetailsController.naviTittle = "Scheduled Recordings"
                    DetailsController.responseArray = self.scheduledRecdArrayMainSecond
                    
                    break
                }
            }
            
        }else{
            
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    
    // *** UIAlertController *** //
    
    func customAlertController(idString: NSString, titleName: NSString)  {
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete Recording" as String, message: "Are you sure you want to delete \"" + (titleName as String) + "\" from your Schedule recordings?", preferredStyle: .alert)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            //Just dismiss the action sheet
            
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionSheetController.addAction(yesAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    
    func getScheduledRecordingDataFromServer(urlString: String)
    {
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
    
            self.startLoaderScheduledController()
            
            let url = NSURL(string: urlString)!
           
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                
                do {
                    
                    let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                    
                    // let localDict : NSDictionary = dict["Items"]  as! NSDictionary
                    
                    self.scheduledRecdArray = dict["Items"] as! NSArray
                    print("Scheduled Recording Data : \(self.scheduledRecdArray)")
                    self.dataArrangeAccordingToDate()
                    
                    
                }catch let error as NSError
                {
                    self.stopLoaderScheduledController()
                    self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                    print(error.code)
                    
                }
            }
        
            task.resume()
            
        }else
        {
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    func dataArrangeAccordingToDate()
    {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<self.scheduledRecdArray.count
        {
            
            let fullDateTime : NSString = (self.scheduledRecdArray.value(forKey: "StartUtc") as! NSArray).object(at:i) as! NSString
            let fullDate = fullDateTime.components(separatedBy: "T")
            self.scheduledRecdArrayMain.append(dateFormatter.date(from:fullDate [0])!)
        }
        
    
        
        self.scheduledRecdArrayMain =  Array(Set(self.scheduledRecdArrayMain))
        
        
        self.scheduledRecdArrayMain.sort { (date1, date2) -> Bool in
            return date1.compare(date2) == ComparisonResult.orderedDescending
        }
        
        
        for i in 0..<self.scheduledRecdArrayMain.count
        {
            
            var count : Int = 0
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newDate = dateFormatter.string(from: self.scheduledRecdArrayMain [i])
         
            
            for j in 0..<self.scheduledRecdArray.count
            {
                
                let fullDateTime : NSString = (self.scheduledRecdArray.value(forKey: "StartUtc") as! NSArray).object(at:j) as! NSString
                let fullDate = fullDateTime.components(separatedBy: "T")
               
                
                if newDate as String == fullDate [0]  {
                    
                    self.scheduledRecdArrayMainSecond.add(self.scheduledRecdArray [j])
                    count += 1
                }
                
            }
            
            self.scheduledRecdArrayMaincountArray.add(count)
        
        }
    
        self.stopLoaderScheduledController()
        
        DispatchQueue.main.async {
            self.schedulTableView.reloadData()
        }
        
    }

    
    
    
    
    func getDVRSpaceFromServerSchedul(urlString : String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
        
            
                let url = NSURL(string: urlString)!
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
                            
                            self.dVRSchedulValueLabel.text = String(finalValue) + "%"
                            self.dVRSchedulProgressView.setProgress(Float(dvrSpaceValue / 100), animated:false)
                        }
                        
                        self.stopLoaderScheduledController()
                        
                        
                    }catch let error as NSError
                    {
                        self.stopLoaderScheduledController()
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        print(error.code)
                        
                    }
                    
                }
                
                task.resume()
        }else
        {
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    
    func startLoaderScheduledController() {
        
        loaderInScheduled = LoaderView()
        loaderInScheduled?.initLoader()
        loaderInScheduled?.kLoaderLabelText = "Please wait..."
        self.view.addSubview(loaderInScheduled!)
    }
    
    
    func stopLoaderScheduledController()  {
        
        DispatchQueue.main.async {
            self.loaderInScheduled?.removeFromSuperview()
            self.loaderInScheduled = nil
        }
    }
    
    func AlertPopUp(titleStr: String, messageStr: String)  {
        
        let alertPopupController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertPopupController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        
        self.present(alertPopupController, animated: true)
        
    }



}
