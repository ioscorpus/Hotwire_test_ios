//
//  POAViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 17/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class POAViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    

    @IBOutlet weak var poaTableView: UITableView!
    
    
    let poaList:[String] = ["Board Rooms","Home Owner Rules","Pay HOA Dues","Upcoming Meeting Agendas","Member Directory","Maintenance Request","Birthdays"]
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "POA".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpRightImageOnNavigationBar()
        self.poaTableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return poaList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"POATableViewCell") as! POATableViewCell
        cell.poaNameLabel?.text = poaList[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
