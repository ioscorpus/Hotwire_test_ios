//
//  CommunityViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 05/09/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit

class CommunityViewController: BaseViewController {
  
  @IBOutlet var lblCommunityName: UILabel!
    let listArray = ["AnnoucementsTitle", "CommunityChannelsTitle","CommunityInformationTitle","CalendarTitle","BulletinBoardTitle","MarketplaceTitle","ReservationsTitle","POA"]

  let iconArray = ["icCommunityPropertymessages","icCommunityChannels","icCommunityCommunityinfo","icCommunityCalender","icCommunityBulletinboard","icCommunityMarketplace","icCommunityReservations","icCommunityPoa"]
  @IBOutlet var topImageView: UIImageView!
  @IBOutlet var tableView: UITableView!
  var cellWithProfilePicture = "BrickellCity"
  var cellReuseIdentifier = "CommunityCell"
  
    override func viewDidLoad()
    {
      super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      setUpRightImageOnNavigationBar()
      lblCommunityName.text = UserDefaults.standard.object(forKey: kCommunityName) as! String?
        // Do any additional setup after loading the view.
        
       
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.title = "Community".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
// MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
 // MARK: - Tableview delegate and data source
extension CommunityViewController: UITableViewDelegate,UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
     return 1
  }
   // ios corpus
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            
            performSegue(withIdentifier: "AnnoucementsViewController", sender: self)
            
        }else if indexPath.row == 1 {
            
            performSegue(withIdentifier: "CommunityChannelsViewController", sender: self)
            
        }else if indexPath.row == 2 {
            
            performSegue(withIdentifier: "CommunityInformationViewController", sender: self)
            
        }else if indexPath.row == 3 {
            
            
        }else if indexPath.row == 4 {
            
            
        }else if indexPath.row == 5 {
            
            
        }else if indexPath.row == 6 {
            
            
        }else if indexPath.row == 7 {
            
            performSegue(withIdentifier: "POAViewController", sender: self)
            
        }
        
    }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listArray.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {

      let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeBasicTableViewCell
      cell.lblHeaderTitle.text = listArray[indexPath.row].localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
      cell.iconImageView.image = UIImage(named: iconArray[indexPath.row])
      return cell
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
}

func gggetMDSTokenFromServer(urlString : String)
{
    
    print("URL String : \(urlString)")
    //let url = NSURL(string: "http://8.19.233.211/remotedvrapi/api/Token/662883c0-7df5-4244-8598-b61484aa75ad")!
    
    let url = NSURL(string : urlString)!
    let request = NSMutableURLRequest(url: url as URL)
    print("request : \(request)")
    request.httpMethod = "GET"
    request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
        
        do {
            
            let dict  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves )
            
            //  let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves ) as! NSDictionary
            print("MDS TOKEN : \(dict)")
            // let MDSToken : NSString = dict["Token"] as! NSString
            // print("MSDToken after saving : \(MDSToken)")
            // UserDefaults.standard.setValue(MDSToken, forKey: "MDS_TOKEN_VALUE")
            // self.booksArray = dict["feed"]!["entry"] as! NSArray
            // getDVRSpaceFromServer()
            
        }catch let error as NSError
        {
            print(error)
            
        }
        
        
    }
    
    task.resume()
}

