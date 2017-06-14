


import UIKit

class PastRecordingsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
   
    @IBOutlet var segmentView: UIView!
    @IBOutlet var pastSegmentController: UISegmentedControl!
    
    @IBOutlet weak var pastRecordingTableView: UITableView!
    
    
    @IBOutlet weak var dVRSpaceDetailView: UIView!
    @IBOutlet weak var dVRSpaceLabel: UILabel!
    @IBOutlet weak var dVRprogressView: UIProgressView!
    @IBOutlet weak var dVRValueLabel: UILabel!
    
    var pastRecdArray  = NSArray()
    var dateArray = [TimeInterval]()
    var titleArray = NSMutableArray()
    
    var pastRecordingsMainArray = NSMutableArray()

    
    
    var loaderInPast: LoaderView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Recorded (10)".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotatedInPastController), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func deviceRotatedInPastController()
    {
        
        if loaderInPast != nil
        {
            print("deviceRotatedInPastController")
            loaderInPast?.removeFromSuperview()
            loaderInPast = LoaderView()
            loaderInPast?.initLoader()
            if let loaderView = loaderInPast
            {
                self.view.addSubview(loaderView)
            }
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        getDVRSpaceFromServerPast(urlString: Dvr_Base_URl + DVR_SPACE_Url)
        getPastRecordingDataFromServer(urlString: Dvr_Base_URl + DVR_PAST_REC_Url)
        
        self.dVRSpaceDetailView.backgroundColor = kColor_NavigationBarColor
        self.dVRprogressView.transform = CGAffineTransform.init(scaleX: 1.0, y: 10.0)
        self.dVRprogressView.tintColor = kColor_TabBarSelected
        self.dVRprogressView.trackTintColor = UIColor.white
        
        self.pastSegmentController.backgroundColor = UIColor.white
        self.pastSegmentController.tintColor = kColor_TabBarSelected
    
       //self.pastRecordingTableView.separatorColor = UIColor.clear
       
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // cell date formatter
    func returnDate(withDate date: String) -> String {
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        
        let todayDate = Date()
        let todayDateFormate = dateFormatter.string(from:todayDate)
        
        if date == todayDateFormate {
            
            return "Today"
        }
        else {
            
            let dateObj = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "M/dd"
            let newDate = dateFormatter.string(from: dateObj!)
            

            return newDate
        }
        
        
        
        
    }
    
    // convert time interval
    func convertStringToMiliseconds24(dateStr: String) -> TimeInterval {
        
        let dateFormatStartTime = DateFormatter()
        dateFormatStartTime.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        let firstTime = dateFormatStartTime.date(from: dateStr)
        let firstTimeInerval : TimeInterval = ((firstTime?.timeIntervalSince1970)! * 1000)
        return firstTimeInerval
    }
    
    func filterDataWithTimeIntervel() {
        
        if self.pastRecdArray.count > 0 {
            
            
            for i in 0..<self.pastRecdArray.count {
                
                let keyDateTime = (self.pastRecdArray.value(forKey: "ActualStartUtc") as! NSArray).object(at: i) as! NSString
                
                let newString = keyDateTime.replacingOccurrences(of: "T", with: " ")
                
                let timeIntevel = convertStringToMiliseconds24(dateStr: newString)
                
                self.dateArray.append(timeIntevel)
                
                
            }
            self.dateArray.sort { $0 > $1 }
           // print("SortedArray : \(self.dateArray)")
            
            for i in 0..<self.dateArray.count {
                //let date = Date(timeIntervalSince1970: (self.dateArray[i] / 1000.0))
                //print("date - \(date)")
                
                for (index, value) in self.pastRecdArray.enumerated() {
                    
                    let keyDateTime = (self.pastRecdArray.value(forKey: "ActualStartUtc") as! NSArray).object(at: index) as! NSString
                    
                    let newString = keyDateTime.replacingOccurrences(of: "T", with: " ")
                    
                    let timeIntevel = convertStringToMiliseconds24(dateStr: newString)
                    
                    if self.dateArray[i] == timeIntevel {
                        
                        print("value \(value) == \(self.pastRecdArray[index])")
                        
                        self.pastRecordingsMainArray.add(self.pastRecdArray[index])
                        break
                    }
                }
            }
            
            //            print(" final array \(self.pastRecordingsMainArray.count)")
            //            print("pastRecordingsMainArray 3 == \(self.pastRecordingsMainArray)")
            //
            
            
        }
        
        // print("Self Data Array :\(self.dateArray)")
        DispatchQueue.main.async {
            self.pastRecordingTableView.reloadData()
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.pastRecordingsMainArray.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier:"PastRecdTableViewCell") as! PastRecdTableViewCell
        
        // title
        let title : NSString = (self.pastRecordingsMainArray.value(forKey: "Title") as! NSArray).object(at: indexPath.row ) as! NSString
        cell.tittleLabel.text = title as String
        
        // hd icon
        let hdType = (self.pastRecordingsMainArray.value(forKey: "IsHD") as! NSArray).object(at: indexPath.row ) as? Bool
  
        if hdType != nil {
            
            cell.hdImgView.isHidden = true

        }
        else {
            cell.hdImgView.isHidden = false
        }
        
        // no. of recordings
        let recording = (self.pastRecordingsMainArray.value(forKey: "IsCurrentlyRecording") as! NSArray).object(at: indexPath.row ) as! Bool
        let itemCount = (self.pastRecordingsMainArray.value(forKey: "ItemCount") as! NSArray).object(at: indexPath.row ) as! Int

        cell.noOfRecordingLabel.text = (itemCount > 1) ? "\(itemCount) Recordings" : "\(itemCount) Recording"
        
        if recording == true {

            if itemCount > 1 {
                
                cell.recdImgView.image = UIImage(named: "Single_Recd")
            }
            else {
                cell.recdImgView.image = UIImage(named: "Multi_Recd")
            }
        }else {
            
            cell.recdImgView.isHidden = true
            cell.recordingLabel.isHidden = true

        }
        
        // date label
        let fullDateTime = (self.pastRecordingsMainArray.value(forKey: "ActualStartUtc") as! NSArray).object(at: indexPath.row ) as! NSString
        let fullDate = fullDateTime.components(separatedBy: "T")
        cell.dateLabel.text = returnDate(withDate: fullDate[0])
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77
    }

  
    
    // API response
    func getPastRecordingDataFromServer(urlString: String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
            NetworkAPIModel.shared.dvr_postRecordingsAPICall(withCompletionHadler: { data, response, error in
                
                do {
                    
                    let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                    self.pastRecdArray = dict["Items"] as! NSArray
                    
                    self.filterDataWithTimeIntervel()
                    self.stopLoaderPastController()
                    
                }
                catch let error as NSError
                {
                    self.stopLoaderPastController()
                    print(error.code)
                    self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                    
                }
            })
        } else {
            self.stopLoaderPastController()
            AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
       
    }
    
    func getDVRSpaceFromServerPast(urlString : String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
            self.startLoaderPastController()
            
            NetworkAPIModel.shared.dvr_spaceAPICall(withCompletionHadler: { data, response, error in
                
                do {
                    
                    let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                    
                    let freeBytes : Double = dict["FreeBytes"] as! Double
                    let totalBytes : Double = dict["TotalBytes"] as! Double
                    let dvrSpaceValue : Double = 100 - ( (freeBytes / totalBytes) * 100)
                    let finalValue : Int = Int(round(dvrSpaceValue))
                    
                    DispatchQueue.main.async {
                        
                        self.dVRValueLabel.text = String(finalValue) + "%"
                        self.dVRprogressView.setProgress(Float(dvrSpaceValue / 100), animated:false)
                    }
                }
                catch let error as NSError
                {
                    self.stopLoaderPastController()
                    print(error.code)
                    self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                }
            })
        } else {
            self.stopLoaderPastController()
            AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    func startLoaderPastController() {
        
        loaderInPast = LoaderView()
        loaderInPast?.initLoader()
        loaderInPast?.kLoaderLabelText = "Please wait..."
        self.view.addSubview(loaderInPast!)
    }
    
    func stopLoaderPastController()  {
        
        DispatchQueue.main.async {
            self.loaderInPast?.removeFromSuperview()
            self.loaderInPast = nil
        }
    }
    
    func AlertPopUp(titleStr: String, messageStr: String)  {
        
        let alertPopupController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertPopupController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        
        self.present(alertPopupController, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DetailsController = self.storyboard?.instantiateViewController(withIdentifier: "SingleRecordingController") as! SingleRecordingController
        self.navigationController?.pushViewController(DetailsController, animated: true)
        
    }
    
}



