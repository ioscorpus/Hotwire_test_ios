//
//  PageControllerSecondViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 12/10/16.
//  Copyright © 2016 chetu. All rights reserved.
//

import UIKit

class PageControllerSecondViewController: UIViewController {
  @IBOutlet var viewDescriptionScreen: UIView!
  @IBOutlet var lblTitleText: UILabel!
  @IBOutlet var lblpageInfoText: UILabel!
  @IBOutlet var imageViewPicture: UIImageView!
  
  @IBOutlet var labelWidthPotrate: NSLayoutConstraint!
  @IBOutlet var labelYPotrate: NSLayoutConstraint!
  var labelLeadingLandScape: NSLayoutConstraint!
  var labelCenterXPotrate: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
      DispatchQueue.main.async {
         if UIDevice.current.userInterfaceIdiom == .pad{
        self.labelCenterXPotrate = NSLayoutConstraint(item: self.lblTitleText, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal
          , toItem: self.viewDescriptionScreen, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        self.labelLeadingLandScape = NSLayoutConstraint(item: self.lblpageInfoText, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal
          , toItem: self.viewDescriptionScreen, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 20)
         NSLayoutConstraint.activate([self.labelLeadingLandScape,self.labelCenterXPotrate])
        }
        self.methodToSetConstantprogramaticallyForIpadSizeClass()
      }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func methodToSetConstantprogramaticallyForIpadSizeClass(){
    if UIDevice.current.userInterfaceIdiom == .pad{
      if UIDevice.current.orientation.isLandscape  {
        print("Landscape")
        labelLeadingLandScape.isActive = true
        labelCenterXPotrate .isActive = false
        let labelY = self.labelYPotrate.constraintWithMultiplier(multiplier: 0.8)
        self.view!.removeConstraint(self.labelYPotrate)
        self.labelYPotrate = labelY
        self.view!.addConstraint(self.labelYPotrate)
    
        let labelWidth = self.labelWidthPotrate.constraintWithMultiplier(multiplier: 0.5)
        self.view!.removeConstraint(self.labelWidthPotrate)
        self.labelWidthPotrate = labelWidth
        self.view!.addConstraint(self.labelWidthPotrate)
        self.view!.layoutIfNeeded()
    
      } else {
        print("Portrait")
        labelLeadingLandScape.isActive = false
        labelCenterXPotrate .isActive = true
        let labelY = self.labelYPotrate.constraintWithMultiplier(multiplier: 1.0)
        self.view!.removeConstraint(self.labelYPotrate)
        self.labelYPotrate = labelY
        self.view!.addConstraint(self.labelYPotrate)
  
        let labelWidth = self.labelWidthPotrate.constraintWithMultiplier(multiplier: 0.8)
        self.view!.removeConstraint(self.labelWidthPotrate)
        self.labelWidthPotrate = labelWidth
        self.view!.addConstraint(self.labelWidthPotrate)
        self.view!.layoutIfNeeded()
     
      }
    }
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
extension NSLayoutConstraint {
  func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
  }
}
