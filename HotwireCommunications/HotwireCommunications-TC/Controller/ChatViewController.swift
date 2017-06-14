//
//  ChatViewController.swift
//  SwiftLiveChat
//
//  Created by Łukasz Jerciński on 17/08/16.
//  Copyright © 2016 LiveChat Inc. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController : BaseViewController, UIWebViewDelegate {
    fileprivate var chatURLString : NSString?
    fileprivate let chatView = UIWebView()
    fileprivate let indicator = UIActivityIndicatorView()
    
    convenience init(chatURL: NSString) {
        self.init(nibName: nil, bundle: nil)
        
        self.chatURLString = chatURL
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
      
        
        let closeButtonItem = UIBarButtonItem(title: "Close",
                                              style: .done,
                                              target: self,
                                              action: #selector(close))
        navigationItem.setLeftBarButton(closeButtonItem, animated: false)
        
        chatView.frame = view.bounds
        chatView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        chatView.alpha = 0
        chatView.delegate = self
        view.addSubview(chatView)
        
        indicator.frame = view.bounds
        indicator.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        indicator.color = UIColor.black
        indicator.startAnimating()
        view.addSubview(indicator)
        
        guard let chatURLString = chatURLString else {
            print("Chat URL not provided")
            return
        }
      let urlStr : NSString = chatURLString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
      let chatURL : NSURL = NSURL(string: urlStr as String)!
      let request = URLRequest(url: chatURL as URL)
        chatView.loadRequest(request)
   
      
      let languageIndex = UserDefaults.standard.integer(forKey: "language")
      LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
      languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      title = "LivaChatTitle".localized(lang: languageCode, comment: "")
    }
    
    @objc func close() {
        _ = self.navigationController?.popViewController(animated: true)//trueDismissViewController(true, completion: nil)
      //  self.hidesBottomBarWhenPushed = true
    }
    
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        UIView.animate(withDuration: 1.0,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions(),
                                   animations: { 
                                    self.chatView.alpha = 1.0
                                    self.indicator.alpha = 0.0
            }) { (finished) in
                self.indicator.stopAnimating()
        }
    }
}
