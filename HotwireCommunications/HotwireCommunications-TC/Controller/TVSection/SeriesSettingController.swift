//
//  SeriesSettingController.swift
//  HotwireCommunications
//
//  Created by Dev on 22/05/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class SeriesSettingController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var detailsView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scheduledLabel: UILabel!
    @IBOutlet var scheduledValueLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var startTimeValueLabel: UILabel!
    @IBOutlet var channelLabel: UILabel!
    @IBOutlet var channelValueLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var manageTableView: UITableView!
    
    var titleStr: String!
    var timeStr: String!
    var idStr: String!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Series Settings".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.manageTableView.tableFooterView = UIView()
        self.detailsView.backgroundColor = UIColor.white
        
        print("titleStr : \(titleStr)")
        print("timeStr : \(timeStr)")

        if titleStr != nil
        {
            self.titleLabel?.text = titleStr
            
        }else
        {
          titleStr = ""
          self.titleLabel?.text = " "
        }
            
        
        if timeStr != nil
        {
            let fullTime = timeStr.components(separatedBy: "T")
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
            let date = dateFormatter.date(from: fullTime [0]) //according to date format your date string
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let newDate = dateFormatter.string(from: date!)
            let newDay = getCurrentDateName(dateStr: fullTime [0] as String)
            
            self.scheduledValueLabel?.text = newDay + " " + newDate
            
            
            let dateFormattertime = DateFormatter()
            dateFormattertime.dateFormat = "HH:mm:ss.SSSS"
            let time = dateFormattertime.date(from: fullTime [1])
            dateFormatter.dateFormat = "hh:mm a"
            let date12 = dateFormatter.string(from: time!)
            
            self.startTimeValueLabel?.text = date12 as String
            
            
        }else
        {
             self.scheduledValueLabel?.text = " "
             self.startTimeValueLabel?.text = " "
        }
        

        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 5
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SeriesSettingSecondCell") as! SeriesSettingSecondCell
            
            cell.saveChangesButton.backgroundColor = kColor_TabBarSelected
            cell.cancelChangesButton.backgroundColor = UIColor.white
            cell.cancelChangesButton.layer.borderColor = kColor_TabBarSelected.cgColor
            cell.cancelChangesButton.setTitleColor(kColor_TabBarSelected, for: .normal)
            
            cell.selectionStyle = .none
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"SeriesSettingCell") as! SeriesSettingCell
            
            if  indexPath.row == 0 {
                
                cell.firstLabel.text = "Start Time"
                cell.secondLabel.text = "Any day, around 03:00 PM"
                
            }else if indexPath.row == 1
            {
                cell.firstLabel.text = "Show Type"
                cell.secondLabel.text = "First run & return"
                
            }else if indexPath.row == 2
            {
                cell.firstLabel.text = "Stop Recording"
                cell.secondLabel.text = "At scheduled end time"
                
            }else if indexPath.row == 3
            {
                cell.firstLabel.text = "Keep"
                cell.secondLabel.text = "All episodes until space is needed"
                
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 4
        {
            return 120
            
        }else{
            
            return 60
        }
    }

    

    @IBAction func deleteSeriesSettingsButton(_ sender: UIButton) {
        
        
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
            if idStr != nil {
                 self.cancelAlertPopup(deleteID: idStr, tittleNameStr: titleStr)
            }
    
        }else
        {
            self.AlertPopUp(titleStr: INTERNT_TITLE_POPUP_STR, messageStr: INTERNET_MESSAGE_POPUP_STR)
        }

        
    }
    
    @IBAction func saveChangesSeriesSettingsButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func cancelChangesSeriesSettingsButton(_ sender: UIButton) {
        
    }
    
    
    func cancelAlertPopup(deleteID: String, tittleNameStr: String)  {
        
        let editRadiusAlert = UIAlertController(title: "Series Recordings", message: "Are you sure you want to delete \"" + tittleNameStr + "\" from your Series recordings?", preferredStyle: UIAlertControllerStyle.alert)
        
        
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            
        }))
        
        editRadiusAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
            //let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
            //self.deleteSeriesRecordingDataFromServerSeriesSettingController(urlString: Dvr_Base_URl + DVR_SERIES_DELETE_URL + deleteID)
            
        }))
        
        self.present(editRadiusAlert, animated: true)
        
    }
    
    
    func deleteSeriesRecordingDataFromServerSeriesSettingController(urlString: String)
    {
        if HotwireCommunicationApi.rechability?.isReachable == true {
            
           
            
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
                    self.navigationController?.popViewController(animated: true)
                    
                
                }catch let error as NSError
                {
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
    


    
    
    func getCurrentDateName (dateStr: String) -> String  {
        
        var Day: String = ""
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: dateStr)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        
        if weekDay == 1
        {
            Day = "SUN"
            
        }else if weekDay == 2
        {
            Day = "MON"
        }else if weekDay == 3
        {
            Day = "TUE"
        }else if weekDay == 4
        {
            Day = "WED"
        }else if weekDay == 5
        {
            Day = "THU"
        }else if weekDay == 6
        {
            Day = "FRI"
        }else if weekDay == 7
        {
            Day = "SAT"
        }
        
        return Day
    }
    
    
    func AlertPopUp(titleStr: String, messageStr: String)  {
        
        let alertPopupController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertPopupController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        
        self.present(alertPopupController, animated: true)
        
    }


}
