//
//  CommunityInformationViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 17/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class CommunityInformationViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    @IBOutlet var communityInfoTableView: UITableView!
    
    let infoList:[String] = ["Restaurant Menus","Community Rules","Golf","Tennis","Fitness and Massage"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Community Info".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setUpRightImageOnNavigationBar()

        self.communityInfoTableView.tableFooterView = UIView()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return infoList.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CommunityInfoFirstTableViewCell") as! CommunityInfoFirstTableViewCell
            return cell

        }else 
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CommunityInfoSecondTableViewCell") as! CommunityInfoSecondTableViewCell
            cell.CommunityInfoNameLabel?.text = infoList[indexPath.row - 1]
            return cell

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            
            performSegue(withIdentifier: "CommunityInfoInnerViewController", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 38
        }else
        {
            return 44 
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
