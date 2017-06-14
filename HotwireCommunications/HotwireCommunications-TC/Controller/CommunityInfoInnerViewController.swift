//
//  CommunityInfoInnerViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 18/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class CommunityInfoInnerViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var communityInfoInnerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.communityInfoInnerTableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
            let cell = tableView.dequeueReusableCell(withIdentifier:"CommunityInfoInnerTableCell") as! CommunityInfoInnerTableCell
            return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 172
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }

   

}
