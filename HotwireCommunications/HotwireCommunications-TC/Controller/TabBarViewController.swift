//
//  TabBarViewController.swift
//  HotwireCommunications-TC
//
//  Created by Chetu-macmini-26 on 09/06/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate{
  var languageCode:String!
    override func viewDidLoad() {
        super.viewDidLoad()
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
        // Do any additional setup after loading the view.
    }
  override func viewWillAppear(_ animated: Bool) {
    self.viewControllers?[0].tabBarItem.title = "Account".localized(lang: languageCode, comment: "")
    self.viewControllers?[1].tabBarItem.title = "Upgrade".localized(lang: languageCode, comment: "")
    self.viewControllers?[2].tabBarItem.title = "TV".localized(lang: languageCode, comment: "")
    self.viewControllers?[3].tabBarItem.title = "Community".localized(lang: languageCode, comment: "")
    self.viewControllers?[4].tabBarItem.title = "Support".localized(lang: languageCode, comment: "")
    UITabBar.appearance().tintColor = UIColor.black//kColor_TabBarSelected
    UITabBar.appearance().barTintColor = UIColor.white
    self.tabBar.isTranslucent = false
    self.tabBar.itemPositioning = UITabBarItemPositioning.fill
    super.viewWillAppear(animated)
    

  }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
    
    return true
  }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }
