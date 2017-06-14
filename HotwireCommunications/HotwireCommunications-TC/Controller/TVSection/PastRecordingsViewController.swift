


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
    var dateArray = [Date]()
    
    
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
       


        self.startLoaderPastController()
        
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        getDVRSpaceFromServerPast(urlString: Dvr_Base_URl + DVR_SPACE_Url)
        getPastRecordingDataFromServer(urlString: Dvr_Base_URl + DVR_PAST_REC_Url)
        
        self.dVRSpaceDetailView.backgroundColor = kColor_NavigationBarColor
        self.dVRprogressView.transform = CGAffineTransform.init(scaleX: 1.0, y: 10.0)
        self.dVRprogressView.tintColor = kColor_TabBarSelected
        self.dVRprogressView.trackTintColor = UIColor.white
        
        self.pastSegmentController.backgroundColor = UIColor.white
        self.pastSegmentController.tintColor = kColor_TabBarSelected
    
      
    
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.pastRecdArray.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier:"PastRecdTableViewCell") as! PastRecdTableViewCell
        
        let tittleStr : NSString = (self.pastRecdArray.value(forKey: "Title") as! NSArray).object(at:indexPath.row) as! NSString
        cell.tittleLabel.text = tittleStr as String
        print("Indexpath :\(indexPath.row)")
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DetailsController = self.storyboard?.instantiateViewController(withIdentifier: "SingleRecordingController") as! SingleRecordingController
        self.navigationController?.pushViewController(DetailsController, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77
    }


    func getPastRecordingDataFromServer(urlString: String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
            
              // self.startLoaderPastController()
        
                let url = NSURL(string: urlString)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
                request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                    
                    do {
                        
                        let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                        self.pastRecdArray = dict["Items"] as! NSArray
                       
                       
                        DispatchQueue.main.async {
                            self.pastRecordingTableView.reloadData()
                        }
                         self.stopLoaderPastController()
                        // self.filterDataByDateAndTime()
                        
                    }catch let error as NSError
                    {
                        self.stopLoaderPastController()
                        print(error.code)
                       self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        
                    }
                }
                
                task.resume()
        }else
        {
            AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    
    
    

    

    
    
    func getDVRSpaceFromServerPast(urlString : String)
    {
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
               // self.startLoaderPastController()
        
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
                    
                            self.dVRValueLabel.text = String(finalValue) + "%"
                            self.dVRprogressView.setProgress(Float(dvrSpaceValue / 100), animated:false)
                         }
                        
                         self.stopLoaderPastController()
                        
                        
                    }catch let error as NSError
                    {
                        self.stopLoaderPastController()
                        print(error.code)
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        
                    }
                    
                }
                
                task.resume()
        }else{
            
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
    
}



