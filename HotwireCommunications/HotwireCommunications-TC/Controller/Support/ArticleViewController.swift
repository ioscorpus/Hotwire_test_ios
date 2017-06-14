//
//  ArticleViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 06/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class ArticleViewController: BaseViewController
{

  @IBOutlet var txtViewDescription: UITextView!
  @IBOutlet var webArticle: UIWebView!
  var webURL : String?
  var strHtml : String?
  var loader: LoaderView?
  override func viewDidLoad()
  {
    super.viewDidLoad()
    txtViewDescription.isHidden = true
    webArticle.delegate = self
    webArticle.scalesPageToFit = true
    self.navigationController?.navigationBar.isHidden = false
    viewUpdateContentOnBasesOfLanguage()
    
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    backButtonWithOutTitle()
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

  override func viewWillAppear(_ animated: Bool)
  {
     NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    NotificationCenter.default.removeObserver(self)
  }
  func viewUpdateContentOnBasesOfLanguage()
  {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    setupNavigationBar()
    
  }

  func setupNavigationBar()
  {
    //Here we check the opened screen is for Article or file accordingly change the navigation bar
    guard let html = strHtml
    else
    {
      var strWebUrl = webURL!
      strWebUrl.remove(at: strWebUrl.startIndex)
      let urlString = kBaseUrl + strWebUrl
      let url =  URL(string:urlString)
      webArticle?.loadRequest(URLRequest(url: url!))
      let btnDone = UIBarButtonItem(title: "FAQ_Done".localized(lang: languageCode, comment: ""), style: .plain, target: self, action: #selector(ArticleViewController.leftButtonTapped) )
      self.navigationItem.leftBarButtonItem = btnDone;
      
      let btnSave = UIBarButtonItem(title: "FAQ_Share".localized(lang: languageCode, comment: ""), style: .plain, target: self, action: #selector(saveBtnTapped) )
      self.navigationItem.rightBarButtonItem = btnSave;
      
      self.title = ""
      return
    }
     txtViewDescription.isHidden = false
     txtViewDescription.attributedText = html.utf8Data?.attributedString
    
    self.title = "FAQ_Article".localized(lang: languageCode, comment: "")
    self.navigationItem.backBarButtonItem?.title = ""
  
  }
  override func leftButtonTapped()
  {
     _ = navigationController?.popViewController(animated: true)
  }
  func saveBtnTapped()
  {
    //_  = navigationController?.popViewController(animated: true)
  }
}
extension ArticleViewController : UIWebViewDelegate
{
  func webViewDidStartLoad(_ webView: UIWebView)
  {
    loader = LoaderView()
    loader?.initLoader()
    self.view.addSubview(loader!)
  }
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
  {
    print(error)
    self.loader?.removeFromSuperview()
    self.loader = nil
  }
  func webViewDidFinishLoad(_ webView: UIWebView)
  {
    self.loader?.removeFromSuperview()
    self.loader = nil
    
  }
}
