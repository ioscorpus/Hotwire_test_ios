//
//  SingleRecordingController.swift
//  HotwireCommunications
//
//  Created by Dev on 13/06/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class SingleRecordingController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.separatorColor = UIColor.clear

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"SingleRecdFirstTableViewCell") as! SingleRecdFirstTableViewCell
            
            return cell
            
            
        }else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"SingleRecdSecondTableViewCell") as! SingleRecdSecondTableViewCell
            
            return cell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"SingleRecdThirdTableViewCell") as! SingleRecdThirdTableViewCell
            
            return cell
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         if indexPath.row == 0 {
            
             return 205
         }else  if indexPath.row == 1 {
            
             return 214
         }else{
            
             return 118
         }
       
    }
    
    
    

    @IBAction func clickStopRecdButton(_ sender: UIButton) {
        
    }
    
    @IBAction func clickDeleteRecdButton(_ sender: UIButton) {
        
    }

    @IBAction func clickSegmentController(_ sender: UISegmentedControl) {
        
    }
    
    
}
