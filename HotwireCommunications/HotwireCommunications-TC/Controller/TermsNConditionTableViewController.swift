//
//  TermsNConditionTableViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 15/02/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class TermsNConditionTableViewController: UITableViewController,UITextViewDelegate {
  var languageCode:String!
  var signupDetails:SignUpDetails!
  @IBOutlet var continueBtn: UIButton!
  @IBOutlet var userName: UILabel!
  
  @IBOutlet var termsNConditionLink: UITextView!
  @IBOutlet var termsNConditionIntro: UILabel!
    override func viewDidLoad() {
      
        super.viewDidLoad()
      termsNConditionLink.delegate = self
     
    }
  override func viewWillAppear(_ animated: Bool) {
    viewUpdateContentOnBasesOfLanguage()
    addNotificationObserver()
  }
  //MARK:- Refresh view
  /***********************************************************************************************************
   <Name> viewUpdateContentOnBasesOfLanguage </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to update content on the bases of language</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  02/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    userName.text = "\("Hi".localized(lang: languageCode, comment: "")) John."
    termsNConditionIntro.text = "LoginTermsNConditionIntro".localized(lang: languageCode, comment: "")
    
    continueBtn.backgroundColor = kColor_continueSelected
    continueBtn.tintColor = .white
    continueBtn.setTitle("Continue".localized(lang: languageCode, comment: ""), for: .normal)
    let signUpTermAndCondition = NSMutableAttributedString(string: "WelcomeTermAndCondition".localized(lang: languageCode, comment: ""))
    signUpTermAndCondition.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIDisplay-Regular",size: 18.0)!, range: NSMakeRange(0, signUpTermAndCondition.length))
    //  signUpTermAndCondition.addAttributes( [NSParagraphStyleAttributeName: paragraphStyle], range: NSRange)
    signUpTermAndCondition.setAsLink(textToFind: "Privacy Policy", linkURL: "PrivacyPolicy")
    //setAsLink(textToFind: "Privacy Policy", linkURL: "PrivacyPolicy")
    signUpTermAndCondition.setAsLink(textToFind: "Terms of Use", linkURL: "TermOfUse")
     termsNConditionLink.attributedText = signUpTermAndCondition
    // textViewTermsInfo.textAlignment = NSTextAlignment.center
    
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  //MARK:-Textview delegate method
  /***********************************************************************************************************
   <Name> shouldInteractWithURL </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Textfield delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  30/08/16 </Date>
   </History>
   ***********************************************************************************************************/
  
  func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool{
   // var termAndCondition:Bool!
    let termsNPolicyActionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
    termsNPolicyActionSheet.addAction(UIAlertAction(title: "PrivacyPolicy".localized(lang: languageCode, comment: ""), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
      // self.performSegue(withIdentifier: kSegue_TermAndConditon, sender: self)
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let popUpView = storyboard.instantiateViewController(withIdentifier: "TermAndCondition") as! TermAndConditonPopUpViewController
      popUpView.termAndCondition = false
      let navController = UINavigationController.init(rootViewController: popUpView)
      self.navigationController?.present(navController, animated: true, completion: nil)
    }))
    termsNPolicyActionSheet.addAction(UIAlertAction(title: "TermOfUse".localized(lang: languageCode, comment: ""), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
      let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
      let popUpView = storyboard.instantiateViewController(withIdentifier: "TermAndCondition") as! TermAndConditonPopUpViewController
      popUpView.termAndCondition = true
      let navController = UINavigationController.init(rootViewController: popUpView)
      self.navigationController?.present(navController, animated: true, completion: nil)
      
    }))
    termsNPolicyActionSheet.addAction(UIAlertAction(title: "Cancel".localized(lang: languageCode, comment: ""), style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
      termsNPolicyActionSheet.dismiss(animated: true, completion: {
        
      })
      
    }))
    if UIDevice.current.userInterfaceIdiom == .pad{
    termsNPolicyActionSheet.popoverPresentationController?.sourceView = self.view
    termsNPolicyActionSheet.popoverPresentationController?.sourceRect = CGRect(0, self.view.bounds.size.height , self.view.bounds.size.width, 1.0) //CGRectMake
    }
    self.present(termsNPolicyActionSheet, animated: true) {
      
    }
   // print(termAndCondition)
    
    return true
  }

  //MARK:- ADD notification
  /***********************************************************************************************************
   <Name> addNotificationObserver </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication come to foreground and update selected languge </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  02/11/16 </Date>
   </History>
   ***********************************************************************************************************/
  func addNotificationObserver(){
    NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(application:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    
  }
  //notification method to update UI
  func applicationWillEnterForeground(application: UIApplication) {
    let languageIndex = UserDefaults.standard.integer(forKey: "language")
    LanguageManager.sharedInstance.GetSelectedlanguageFromApplicationSetting(LanguageIndex: languageIndex)
    print("applicationWillEnterForeground")
    viewUpdateContentOnBasesOfLanguage()
  }
  
  
  @IBAction func onContinuClick(_ sender: Any) {
    //SignUpEnterMobNoViewController
    if((UserDefaults.standard.object(forKey: kTOSAccepted) != nil) && (UserDefaults.standard.object(forKey: kPPAccepted) != nil)){
    
    }else{
    let localUserdefault = UserDefaults.standard
    localUserdefault.set(true, forKey: "isTermAccepted")
    localUserdefault.set("1", forKey: kTOSAccepted)
    localUserdefault.set("1", forKey: kPPAccepted)
    localUserdefault.synchronize()
    Utility.pushDesiredViewControllerOver(viewController: self)
    }
   /* let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
    let mainViewController = storyboard.instantiateViewController( withIdentifier: kStoryBoardID_PhoneNoVarification) as! SignUpEnterMobNoViewController
        mainViewController.isAfterLogin = true
    self.navigationController?.pushViewController(mainViewController, animated: true)*/
   
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
  
 

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
