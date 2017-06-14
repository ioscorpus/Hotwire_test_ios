//
//  UnderstandingYourBillViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-27 on 03/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class UnderstandingYourBillViewController: BaseViewController,UIWebViewDelegate {

  var webUrl = "https://www.gethotwired.com/pdf/BillExplained.pdf"
  var loader: LoaderView?
    @IBOutlet weak var billWebView: UIWebView!
    //var languageCode:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        viewUpdateContentOnBasesOfLanguage()
        setRightButtonWithImageName(name: "btnSave")
        setUpCancelButonOnLeft()
     
      let doneBtn = UIBarButtonItem(title: "FAQ_Done".localized(lang: languageCode, comment: ""), style: .plain, target: self, action: #selector(UnderstandingYourBillViewController.leftButtonTapped))
      self.navigationItem.leftBarButtonItem = doneBtn;

     
  }
  
  //MARK:- DeviceOrientation changed method
  
  func deviceRotated()
  {
    if loader != nil
    {
      loader?.removeFromSuperview()
      loader = LoaderView()
      loader?.initLoader()
      if let loaderView = loader
      {
        self.view.addSubview(loaderView)
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let url =  URL(string:webUrl)
    billWebView.delegate = self
    billWebView.scalesPageToFit = true
    billWebView?.loadRequest(URLRequest(url: url!))
  //  billWebView.reload()

     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
  }
    func viewUpdateContentOnBasesOfLanguage(){
      let languageIndex = UserDefaults.standard.integer(forKey: "language")
      LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
        languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
        self.title = "BillingInfoTitle".localized(lang: languageCode, comment: "")
    }

  
    override func leftButtonTapped(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func dismissMe() {
        //_=self.navigationController?.popViewController(animated: true)
      let myWebsite = NSURL(string: webUrl)
      guard let url = myWebsite else {
        print("nothing found")
        return
      }
      
      let shareItems:Array = [url]
      let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
//      activityViewController.excludedActivityTypes = [UIActivityType.postToTwitter, UIActivityType.postToFacebook, UIActivityType.postToWeibo, UIActivityType.message, UIActivityType.mail,UIActivityType.print, UIActivityType.copyToPasteboard,UIActivityType.saveToCameraRoll, UIActivityType.assignToContact,UIActivityType.addToReadingList, UIActivityType.postToFlickr,UIActivityType.postToVimeo,UIActivityType.postToTencentWeibo]
      if UIDevice.current.userInterfaceIdiom == .pad{
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(0, self.view.bounds.size.height , self.view.bounds.size.width, 1.0)
      }
      self.present(activityViewController, animated: true, completion: nil)

    }
    
  func webViewDidStartLoad(_ webView: UIWebView) {
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
  {
    self.loader?.removeFromSuperview()
    self.loader = nil

  }
  func webViewDidFinishLoad(_ webView: UIWebView) {
    self.loader?.removeFromSuperview()
    self.loader = nil
  }

}
