//
//  PastRecordingDetailsController.swift
//  HotwireCommunications
//
//  Created by Dev on 15/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class PastRecordingDetailsController: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDataSource , UICollectionViewDelegate  {
    
    
    @IBOutlet weak var dVRSpacePastDetailView: UIView!
    @IBOutlet weak var dVRSpacePastDetailLabel: UILabel!
    @IBOutlet weak var dVRprogressPastDetailView: UIProgressView!
    @IBOutlet weak var dVRValuePastDetailLabel: UILabel!
    
    
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var rightArrowImage: UIImageView!
    
    @IBOutlet weak var pastRecdInnerCollectionView: UICollectionView!
    @IBOutlet weak var pastRecdInnerImage: UIImageView!
    
    @IBOutlet weak var pastDetailsTableView: UITableView!
    
    var cell = PastRecordingDetailsCell()
    var collectionIdentifier : String!
    var stringPassed: String!
    var naviTittle: String!
    var responseArray: NSArray!
    
    
    var EPGProgramID: Int!
    var epgResponseArray: NSDictionary!
    
    var TittleStr:String? = " "
    var EpisodeTitleStr:String? = " "
    var OriginalAirDateStr:String? = " "
    var DescriptionStr:String? = " "
    
    var loaderInPastDetails: LoaderView?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.title = naviTittle.localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotatedInPastDetailsController), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func deviceRotatedInPastDetailsController()
    {
        if loaderInPastDetails != nil
        {
            loaderInPastDetails?.removeFromSuperview()
            loaderInPastDetails = LoaderView()
            loaderInPastDetails?.initLoader()
            if let loaderView = loaderInPastDetails
            {
                self.view.addSubview(loaderView)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
       
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        getDVRSpaceFromServerPastDetails(urlString: Dvr_Base_URl + DVR_SPACE_Url)
        
        print("Get Tittle : \(self.title)")
        
        if naviTittle == "Scheduled Recordings" {
            
            
            
        }else if naviTittle == "Schedule a Recordings"
        {
            print("String URl : \(Dvr_Base_URl + DVR_EPG_PRO_TAP_Url + String(EPGProgramID))")
            getEPGInnerDataFromServer(urlstring: Dvr_Base_URl + DVR_EPG_PRO_TAP_Url + String(EPGProgramID))
        }
        
        
        
        self.dVRSpacePastDetailView.backgroundColor = kColor_DVRSpacebackground
        self.dVRprogressPastDetailView.transform = CGAffineTransform.init(scaleX: 1.0, y: 10.0)
        self.dVRprogressPastDetailView.tintColor = kColor_TabBarSelected
        self.dVRprogressPastDetailView.trackTintColor = kColor_NavigationBarColor
        
        self.pastDetailsTableView.separatorColor = UIColor.clear
        
        let cellnibArray = Bundle.main.loadNibNamed("PastRecordingDetailsCell", owner: self, options: nil)
        
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell = cellnibArray?[1] as! PastRecordingDetailsCell
        
            
        }else{
            cell = cellnibArray?[0] as! PastRecordingDetailsCell
            
        }
    
        cell.pastInnerCollectionView.register(UINib(nibName: "PastRecdInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PastRecdInnerCollectionViewCell")
        
        print("Loaded View")
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if naviTittle == "Scheduled Recordings" {
            
            
            for var i in 0..<self.responseArray.count
            {
                
                let idString : String = (self.responseArray.value(forKey: "Id") as! NSArray).object(at:i) as! String
                
                if stringPassed == idString {
                    
                    
                    cell.characterName.text = (self.responseArray.value(forKey: "Title") as! NSArray).object(at:i) as? String
                    
                    
                    let desStr : NSString = (self.responseArray.value(forKey: "Description") as! NSArray).object(at:i) as! NSString
                    cell.discriptionLabel.text = desStr as String
                    
                    let channelNoStr : Int = (self.responseArray.value(forKey: "ChannelNumber") as! NSArray).object(at:i) as! Int
                    cell.channelName.text = String(channelNoStr)
                    
                    
                    
                    let fullDateTime : NSString = (self.responseArray.value(forKey: "StartUtc") as! NSArray).object(at:i) as! NSString
                    let fullDate = fullDateTime.components(separatedBy: "T")
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    let date = dateFormatter.date(from: fullDate [0]) //according to date format your date string
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    let newDate = dateFormatter.string(from: date!)
                    
                    cell.recordedDate.text = newDate as String
                    
                    
                    let duration : Int = (self.responseArray.value(forKey: "Duration") as! NSArray).object(at:i) as! Int
                    let newDuration: Int = duration / 60
                    let finalDuration = String(newDuration) + " mins"
                    print("finalDuration :\(finalDuration)")
                    
                    cell.durationTime.text = finalDuration
                    
                    break
                }
            }

            
            
        }else if naviTittle == "Schedule a Recordings"
        {
            print("Else case Schedule a Recordings")
        
             cell.characterName?.text = self.TittleStr
             cell.subTittle?.text = self.EpisodeTitleStr
             cell.recordedDate?.text = self.OriginalAirDateStr
             cell.discriptionLabel?.text = self.DescriptionStr
            
             cell.RecordedLabel.text = "Air Date"
             cell.durationLabel.text = "Time"
           
        
            
//            let desStr : NSString = (self.responseArray.value(forKey: "Description") as! NSArray).object(at:i) as! NSString
//            cell.discriptionLabel.text = desStr as String
//            
//            let channelNoStr : Int = (self.responseArray.value(forKey: "ChannelNumber") as! NSArray).object(at:i) as! Int
//            cell.channelName.text = String(channelNoStr)
//            
//            
//            
//            let fullDateTime : NSString = (self.responseArray.value(forKey: "StartUtc") as! NSArray).object(at:i) as! NSString
//            let fullDate = fullDateTime.components(separatedBy: "T")
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
//            let date = dateFormatter.date(from: fullDate [0]) //according to date format your date string
//            dateFormatter.dateFormat = "MM-dd-yyyy"
//            let newDate = dateFormatter.string(from: date!)
//            
//            cell.recordedDate.text = newDate as String
//            
//            
//            let duration : Int = (self.responseArray.value(forKey: "Duration") as! NSArray).object(at:i) as! Int
//            let newDuration: Int = duration / 60
//            let finalDuration = String(newDuration) + " mins"
//            print("finalDuration :\(finalDuration)")
//            
//            cell.durationTime.text = finalDuration

            
        }
        
        
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
       

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
           return 800
        }else
        {
            return 480
            
        }
    }

    
    
    
    /*** Collection View ***/
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastRecdInnerCollectionViewCell", for: indexPath)
    
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }

    
    /*********************/ 
    
    

    func getDVRSpaceFromServerPastDetails(urlString : String)
    {
        if HotwireCommunicationApi.rechability?.isReachable == true {
            

                self.startLoaderPastDetailsController()
            
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
                            
                            self.dVRValuePastDetailLabel.text = String(finalValue) + "%"
                            self.dVRprogressPastDetailView.setProgress(Float(dvrSpaceValue / 100), animated:false)
                        }
                        
                        self.stopLoaderPastDetailsController()
                        
                        
                    }catch let error as NSError
                    {
                        self.stopLoaderPastDetailsController()
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
    
    
    
    func getEPGInnerDataFromServer(urlstring : String)
    {
        if HotwireCommunicationApi.rechability?.isReachable == true {
        
        
                print("getEPGInnerDataFromServer :\(urlstring)")
                let url : String = urlstring
                let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as String as NSString
                let searchURL : NSURL = NSURL(string: urlStr as String)!
               
                let request = NSMutableURLRequest(url: searchURL as URL)
                
                request.httpMethod = "GET"
                request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
                request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                    
                    do {
                        
                        let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                        //print("self.epgResponseArray :\(dict)")
                        self.epgResponseArray = dict
                        
                        //print(" self.epgResponseArray  ++++++++ :\( self.epgResponseArray)")
                        
                        self.TittleStr = (dict["Title"] as? String) ?? " "
                        self.EpisodeTitleStr = (dict["EpisodeTitle"] as? String) ?? " "
                        self.DescriptionStr = (dict["Description"] as? String) ?? " "
                        
                        let airDate: String = (dict["OriginalAirDate"] as? String) ?? " "
                       // print("AirDate : \(airDate)")
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        let date = dateFormatter.date(from: airDate)
                        print("date : \(date)")
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        self.OriginalAirDateStr = dateFormatter.string(from: date!)
                        
                        
                        //print("self.TittleStr :\(self.TittleStr)")
                        //print("self.EpisodeTitleStr :\( self.EpisodeTitleStr)")
                        //print("self.DescriptionStr :\(self.DescriptionStr)")
                        //print("self.OriginalAirDateStrr :\(self.OriginalAirDateStr)")
                        
                
                        DispatchQueue.main.async {
                            
                            self.pastDetailsTableView.reloadData()
                        }
                        self.stopLoaderPastDetailsController()
                        
                    }catch let error as NSError
                    {
                        self.stopLoaderPastDetailsController()
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        print(error.localizedDescription)
                        
                    }
                    
                }
                
                task.resume()
        }else
        {
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    func startLoaderPastDetailsController() {
        
        loaderInPastDetails = LoaderView()
        loaderInPastDetails?.initLoader()
        loaderInPastDetails?.kLoaderLabelText = "Please wait..."
        self.view.addSubview(loaderInPastDetails!)
    }
    
    
    func stopLoaderPastDetailsController()  {
        
        DispatchQueue.main.async {
            self.loaderInPastDetails?.removeFromSuperview()
            self.loaderInPastDetails = nil
        }
    }
    
    func AlertPopUp(titleStr: String, messageStr: String)  {
        
        let alertPopupController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertPopupController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        
        self.present(alertPopupController, animated: true)
        
    }





}
