//
//  CommunityChannelsViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 17/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class CommunityChannelsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var communityChannelTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Channels".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpRightImageOnNavigationBar()
        
       self.communityChannelTableView.separatorColor = UIColor.clear

    }
    
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CommunityChannelsFirstTableViewCell") as! CommunityChannelsFirstTableViewCell
            return cell
            
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CommunityChannelsSecondTableViewCell") as! CommunityChannelsSecondTableViewCell
            return cell
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       // let vc = CommunityChannelPresentController()
       // self.present(vc, animated: true, completion: nil)
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "CommunityChannelPresentController") as! CommunityChannelPresentController
        let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 38
        }else
        {
            return 172
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
