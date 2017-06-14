//
//  CommunityChannelPresentController.swift
//  HotwireCommunications
//
//  Created by Dev on 17/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class CommunityChannelPresentController: UIViewController {
    
    
    @IBOutlet var presentImage: UIImageView!
    @IBOutlet var rotateLabel: UILabel!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.presentImage.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: 210)
        self.rotateLabel.frame = CGRect(x: 0, y: screenSize.height - 40, width: screenSize.width, height: 40)

        let button1 = UIBarButtonItem(title: "Close", style: .plain, target: self, action:#selector(CommunityChannelPresentController.clickCloseButton))
        self.navigationItem.leftBarButtonItem  = button1
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = kColor_NavigationBarColor
        
       // let  naviimage : UIImage = UIImage(named: "test8")!
       // self.navigationController?.navigationBar.setBackgroundImage(naviimage,for: .default)
    }
    
    func clickCloseButton() {
        
        self.dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // when device is roated
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        print("screenWidth :\(screenSize.width)")
        print("screenHeight :\(screenSize.height)")
        
        if UIDevice.current.orientation.isLandscape {
            
            print("Landscape")
            self.presentImage.frame = CGRect(x: 0, y: 32, width: screenSize.height, height: screenSize.width - 32)
            self.rotateLabel.isHidden = true
            
            
        } else {

             print("Portrait")
            self.presentImage.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: 210)
            self.rotateLabel.frame = CGRect(x: 0, y: screenSize.height - 40, width: screenSize.width, height: 40)
             self.rotateLabel.isHidden = false
        }
        
        
    }

}
