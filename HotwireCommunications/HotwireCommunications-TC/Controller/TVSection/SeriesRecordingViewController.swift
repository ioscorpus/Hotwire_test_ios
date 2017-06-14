
//  SeriesRecordingViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 28/02/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class SeriesRecordingViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var dVRSpaceSeriesView: UIView!
    @IBOutlet weak var dVRSpaceSeriesLabel: UILabel!
    @IBOutlet weak var dVRSeriesProgressView: UIProgressView!
    @IBOutlet weak var dVRSpaceSeriesValueLabel: UILabel!
    
    @IBOutlet weak var seriesCollectionView: UICollectionView!
    @IBOutlet weak var addSeriesRecordingButton: UIButton!
    
    var seriesRecdArray  = NSArray()
    
    
    
    var loaderInSeries: LoaderView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
          self.title = "Series Recordings".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
          NotificationCenter.default.addObserver(self, selector: #selector(deviceRotatedInSeriesController), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func deviceRotatedInSeriesController()
    {
        if loaderInSeries != nil
        {
            loaderInSeries?.removeFromSuperview()
            loaderInSeries = LoaderView()
            loaderInSeries?.initLoader()
            if let loaderView = loaderInSeries
            {
                self.view.addSubview(loaderView)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
         self.startLoaderSeriesController()
        
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        getSeriesRecordingDataFromServer(urlString: Dvr_Base_URl + DVR_SERIES_REC_Url)
        getDVRSpaceFromServerSeries(urlString: Dvr_Base_URl + DVR_SPACE_Url)
        
        

        self.dVRSpaceSeriesView.backgroundColor = kColor_DVRSpacebackground
        self.dVRSeriesProgressView.transform = CGAffineTransform.init(scaleX: 1.0, y: 10.0)
        self.dVRSeriesProgressView.tintColor = kColor_TabBarSelected
        self.dVRSeriesProgressView.trackTintColor = kColor_NavigationBarColor
        
        self.addSeriesRecordingButton.backgroundColor = kColor_TabBarSelected
        
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("numberOfItemsInSection : \(self.seriesRecdArray.count)")
        return self.seriesRecdArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesRecordingCollectionCell", for: indexPath) as! SeriesRecordingCollectionCell
        cell.contentView.layer.borderWidth = 0.3
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        let tittleStr : NSString = (self.seriesRecdArray.value(forKey: "Title") as! NSArray).object(at:indexPath.row) as! NSString
        cell.seriesRecdProgNameLabel.text = tittleStr as String
        cell.seriesDeleteButton.tag = indexPath.row
        
       // let idStr : NSString = (self.seriesRecdArray.value(forKey: "Id") as! NSArray).object(at:indexPath.row) as! NSString
       // print("idStr  :\(idStr)")
        //let idInt = Int(idStr)
        //print("idInt  :\(idInt)")
        cell.seriesManageButton.tag = indexPath.row
        return cell
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            
            print("Landscape")
            
            
        } else {
            
            print("Portrait")
            
        }
        
        self.seriesCollectionView .reloadData();
    }
    
    
    
    @IBAction func clickSeriesAddRecordingButton(_ sender: UIButton) {
        
        
        if  HotwireCommunicationApi.rechability?.isReachable == true {
            
            
        }else
        {
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }


    @IBAction func clickSeriesDeleteButton(_ sender: UIButton) {
        
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
        
            print("Sender.tag : \(sender.tag)")
            
            for var i in 0..<self.seriesRecdArray.count
            {
                
                if i == sender.tag {
                    
                    let idString : String = (self.seriesRecdArray.value(forKey: "Id") as! NSArray).object(at:i) as! String
                    print("idString : \(idString)")
                    let titleName : String = ((self.seriesRecdArray.value(forKey: "Title") as! NSArray).object(at:i) as? String) ?? " "
                    
                    self.cancelAlertPopup(deleteID: idString, titleNameStr: titleName)
                    
                    break
                }
            }
            
        }else
        {
             self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
        
    }
    
    
    @IBAction func clickSeriesManageButton(_ sender: UIButton) {
        
        
       // print("\(sender.tag)")
        
         if HotwireCommunicationApi.rechability?.isReachable == true {
            
            
            for var i in 0..<self.seriesRecdArray.count
            {
                
                if i == sender.tag {
                    
                    let idString : String = ((self.seriesRecdArray.value(forKey: "Id") as! NSArray).object(at:i) as? String) ?? " "
                    print("idString : \(idString)")
                    
                    let seriesSettingController = self.storyboard?.instantiateViewController(withIdentifier: "SeriesSettingController") as! SeriesSettingController
                    self.navigationController?.pushViewController(seriesSettingController, animated: true)
                    
                    let titleText : String = ((self.seriesRecdArray.value(forKey: "Title") as! NSArray).object(at:i) as? String) ?? " "
                    let timeText : String = ((self.seriesRecdArray.value(forKey: "OriginalStartUtc") as! NSArray).object(at:i) as? String) ?? " "
                    
                     seriesSettingController.titleStr = titleText as String
                     seriesSettingController.timeStr = timeText as String
                     seriesSettingController.idStr = idString as String
                    
                    break
                }
            }
        
            
            
         }else{
            
             self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cancelAlertPopup(deleteID: String, titleNameStr: String)  {
        
        let editRadiusAlert = UIAlertController(title: "Series Recordings", message: "Are you sure you want to delete \"" + titleNameStr + "\" from your Series recordings?", preferredStyle: UIAlertControllerStyle.alert)

        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            
        }))
        
        editRadiusAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
            //let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
            //self.deleteSeriesRecordingDataFromServer(urlString: Dvr_Base_URl + DVR_SERIES_DELETE_URL + deleteID)
            
        }))
        
        self.present(editRadiusAlert, animated: true)
        
    }

    
    
    func getSeriesRecordingDataFromServer(urlString: String)
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
                        
                        print("Series Recording Data : \(dict)")
                        self.seriesRecdArray = dict["Items"] as! NSArray
                        
                        
                        self.stopLoaderSeriesController()
                        DispatchQueue.main.async {
                            self.seriesCollectionView.reloadData()
                        }
                        
                    }catch let error as NSError
                    {
                        self.stopLoaderSeriesController()
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        print(error.code)
                        
                    }
                }

                task.resume()
        }else{
            
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }
    
    
    func deleteSeriesRecordingDataFromServer(urlString: String)
    {
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
                self.startLoaderSeriesController()
            
                print("Series Delete urlString : \(urlString)")
                let url = NSURL(string: urlString)!
                
                let request = NSMutableURLRequest(url: url as URL)
                
                request.httpMethod = "DELETE"
                request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
                request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
                    
                    do {
                        
                        let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
                        
                        print("Series Recording Data : \(dict)")
                        
                        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
                        self.getSeriesRecordingDataFromServer(urlString: Dvr_Base_URl + DVR_SERIES_REC_Url)
                        
                        self.stopLoaderSeriesController()
                    
                    }catch let error as NSError
                    {
                        self.stopLoaderSeriesController()
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

    
    
    func getDVRSpaceFromServerSeries(urlString : String)
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
                            
                            self.dVRSpaceSeriesValueLabel.text = String(finalValue) + "%"
                            self.dVRSeriesProgressView.setProgress(Float(dvrSpaceValue / 100), animated:false)
                        }
                        
                        self.stopLoaderSeriesController()
                        
                        
                    }catch let error as NSError
                    {
                        self.stopLoaderSeriesController()
                        self.AlertPopUp(titleStr: SERVER_NOT_RESPOND_TITLE_STR, messageStr: SERVER_NOT_RESPOND_MESSAGE_STR)
                        print(error.code)
                        
                    }
                    
                }
                
                task.resume()
        }else{
            
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }
    }

    
    func startLoaderSeriesController() {
        
        loaderInSeries = LoaderView()
        loaderInSeries?.initLoader()
        loaderInSeries?.kLoaderLabelText = "Please wait..."
        self.view.addSubview(loaderInSeries!)
    }
    
    func stopLoaderSeriesController()  {
        
        DispatchQueue.main.async {
            self.loaderInSeries?.removeFromSuperview()
            self.loaderInSeries = nil
        }
    }
    
    func AlertPopUp(titleStr: String, messageStr: String)  {
        
        let alertPopupController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertPopupController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        
        self.present(alertPopupController, animated: true)
        
    }

}
