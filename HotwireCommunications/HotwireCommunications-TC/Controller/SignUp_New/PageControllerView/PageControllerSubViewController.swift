//
//  PageControllerSubViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 12/10/16.
//  Copyright © 2016 chetu. All rights reserved.
//

import UIKit

class PageControllerSubViewController: UIViewController {
  @IBOutlet var viewWelcomeScreen: UIView!
  @IBOutlet var imageViewIcon: UIImageView!
  @IBOutlet var lblWelcomeText: UILabel!
  @IBOutlet var imageViewPicture: UIImageView!
  // landscape
  
  
  // potrate
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      lblWelcomeText.sizeToFit()
    
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
