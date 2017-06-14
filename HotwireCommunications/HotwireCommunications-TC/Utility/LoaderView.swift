//
//  LoaderView.swift
//  Pods
//
//  Created by Chetu-macmini-27 on 26/12/16.
//
//

import UIKit

class LoaderView: UIView {
  
    let kLoaderType = 0
    let loaderBlackViewHeight:CGFloat = 60
    let loaderBlackViewWidth:CGFloat = 200
    let radians:(CGFloat)->CGFloat =  {(degree:CGFloat)->CGFloat in ((degree * 3.14) / 180.0)}
    let Activity_Indicator_Height:CGFloat = 20
    let Activity_Indicator_Width:CGFloat = 20
    let Loader_Label_Height = 25
    let kLoaderLabelYPos = 0
    var kLoaderLabelText = "PleaseWaitTitle".localized(lang: "en", comment: "")
  
    let kMarginBetweenLabelAndActivityIndicator:CGFloat = 10
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initLoader(){
     
      DispatchQueue.main.async {
        
     
      if(UserDefaults.standard.object(forKey: kiSOCode) != nil){
        self.kLoaderLabelText = "PleaseWaitTitle".localized(lang: (UserDefaults.standard.object(forKey: kiSOCode) as! String).lowercased(), comment: "")
      }
        var windowHeight:CGFloat;
        var windowWidth:CGFloat;
        var activityIndicatorFrame:CGRect;
        var loaderLabelText = "";
        print("Current Size in loader\(currentViewSize)")
        windowHeight = UIScreen.main.bounds.size.height
        windowWidth = UIScreen.main.bounds.size.width

      
      self.frame = CGRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
      activityIndicatorFrame = CGRect(x: (self.loaderBlackViewWidth-self.Activity_Indicator_Width)/2, y: (self.loaderBlackViewHeight-self.Activity_Indicator_Height)/2+self.kMarginBetweenLabelAndActivityIndicator, width: self.Activity_Indicator_Width, height: self.Activity_Indicator_Height)
        loaderLabelText=self.kLoaderLabelText;
        self.backgroundColor = UIColor.clear
        self.alpha = 0.8;
        let blankView = UIView(frame: self.frame)//)
        blankView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 3)
        //blankView.layer.cornerRadius = 10;
        let reloadingLabel =  UILabel(frame: CGRect(x: (windowWidth-self.loaderBlackViewWidth)/2, y: (windowHeight-self.loaderBlackViewHeight)/2, width: self.loaderBlackViewWidth, height: self.loaderBlackViewHeight))//CGRect(x: 0, y: CGFloat(kLoaderLabelYPos), width: CGFloat(loaderBlackViewWidth), height: CGFloat(Loader_Label_Height)))
        reloadingLabel.text = loaderLabelText;
        reloadingLabel.textAlignment = NSTextAlignment.center
        reloadingLabel.textColor = UIColor(red: 196/255, green: 0/255, blue: 18/255, alpha: 1.0)
        reloadingLabel.font = UIFont (name: "Arial-BoldMT", size: 16);
        reloadingLabel.backgroundColor = UIColor.clear
        blankView.addSubview(reloadingLabel)
        let indicatorView =  UIActivityIndicatorView(frame: CGRect(x: (windowWidth-self.loaderBlackViewWidth)/2, y: (windowHeight-self.loaderBlackViewHeight)/2 - 40, width: self.loaderBlackViewWidth, height: self.loaderBlackViewHeight))
        
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicatorView.color = UIColor(red: 196/255, green: 0/255, blue: 18/255, alpha: 1.0)
        indicatorView.startAnimating()
        blankView.addSubview(indicatorView)
        self.addSubview(blankView)
      
    }
    
}
  
  
  
  
}
