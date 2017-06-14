//
//  AnnoucementsViewController.swift
//  HotwireCommunications
//
//  Created by Dev on 17/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class AnnoucementsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    @IBOutlet var annoucementTableView: UITableView!
    
    
    
    let arrayList:[String] = ["Hotwire Annoucements","Upgrade With HBO","Meet Your Account Manager"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Annoucements".localized(lang: LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String, comment: "")
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setUpRightImageOnNavigationBar()
        
        self.annoucementTableView.tableFooterView = UIView()

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"AnnoucementTableViewCell") as! AnnoucementTableViewCell
        cell.AnnoucementLabelName?.text = arrayList[indexPath.row]
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
