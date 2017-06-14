//
//  HelpPasswordViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-27 on 02/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class HelpPasswordViewController: BaseViewController {

  //  var languageCode:String!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUpdateContentOnBasesOfLanguage()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.title  = "PasswordHelp"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.allowsSelection = false
        setUpCancelButonOnRightWithAnimation()
        
    }

  override func setUpCancelButonOnRightWithAnimation(){
    let btn1 = UIButton(frame:KFrame_DoneBarbutton )
    btn1.setTitle("Done", for: UIControlState.normal)
    btn1.addTarget(self, action: #selector(HelpPasswordViewController.onDoneClicked), for: .touchUpInside)
    self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn1), animated: true);
  }
  
  func onDoneClicked()
  {
   //_ = self.navigationController?.popViewController(animated: true)
     self.dismiss(animated: true, completion: {});
  }
    /***********************************************************************************************************
     <Name> viewUpdateContentOnBasesOfLanguage </Name>
     <Input Type>    </Input Type>
     <Return> void </Return>
     <Purpose> method to update content on the bases of language</Purpose>
     <History>
     <Header> Version 1.0 </Header>
     <Date> 04/01/17 </Date>
     </History>
     ***********************************************************************************************************/
    func viewUpdateContentOnBasesOfLanguage(){
        languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}


extension HelpPasswordViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 300
        }
        else{
            return 0
        }
    }
}


extension HelpPasswordViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "helpPasswordTableViewCell")
        
        let passwordHeadingLabel = (cell?.contentView.viewWithTag(10) as! UILabel)
        passwordHeadingLabel.text = "PasswordHeading".localized(lang: languageCode, comment: "")
        
        let PasswordInstructionHeading = (cell?.contentView.viewWithTag(1) as! UILabel)
        PasswordInstructionHeading.text = "PasswordInstructionHeading".localized(lang: languageCode, comment: "")
        
        let PasswordInstruction1 = (cell?.contentView.viewWithTag(2) as! UILabel)
        PasswordInstruction1.text = "PasswordInstruction1".localized(lang: languageCode, comment: "")
        
        let PasswordInstruction2 = (cell?.contentView.viewWithTag(3) as! UILabel)
        PasswordInstruction2.text = "PasswordInstruction2".localized(lang: languageCode, comment: "")
        
        let PasswordInstruction3 = (cell?.contentView.viewWithTag(4) as! UILabel)
        PasswordInstruction3.text = "PasswordInstruction3".localized(lang: languageCode, comment: "")
        
        return cell!
        
    }
}
