//
//  HotWireFirstViewController.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 22/09/16.
//  Copyright © 2016 chetu. All rights reserved.
//

import UIKit
import SynacorCloudId
import Branch

class HotWireFirstViewController: BaseViewController,UIScrollViewDelegate {
  //var languageCode:String!
  @IBOutlet var btnSignUp: UIButton!
  @IBOutlet var btnLogin: UIButton!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var pageControl: UIPageControl!
  @IBOutlet var scrollViewBaseView: UIView!
  @IBOutlet var buttonBaseVIew: UIView!

  var loggedInUser: User?
  var curentPage:Int = 0
  private var cloudId:CloudId? {
    didSet {
      guard let cloudId = self.cloudId else {
        return
      }
       self.cloudIdWasSet(cloudId: cloudId)
    }
  }
  let mainStoryboard = "Main"
  // landscape
  @IBOutlet var buttonBaseViewLeading: NSLayoutConstraint!
  @IBOutlet var buttonBaseViewHeight: NSLayoutConstraint!
  @IBOutlet var buttonBaseViewWidth: NSLayoutConstraint!
  @IBOutlet var buttonBaseViewCenter2Y: NSLayoutConstraint!
  @IBOutlet var pageControllerTop: NSLayoutConstraint!
  @IBOutlet var pageControlerCenterX: NSLayoutConstraint!
  // potrate
  @IBOutlet var buttonBaseViewHeightPotrate: NSLayoutConstraint!
  @IBOutlet var buttonBaseViewCenterX: NSLayoutConstraint!
  @IBOutlet var buttonBaseViewWidthPotrate: NSLayoutConstraint!
  @IBOutlet var ButtonBaseViewTop: NSLayoutConstraint!
  @IBOutlet var pageControllerCenterXPotrate: NSLayoutConstraint!
  @IBOutlet var buttonBaseViewBottom: NSLayoutConstraint!
  // sub view for first screen
  // potrate
  @IBOutlet var LabelCenterY: NSLayoutConstraint!
  @IBOutlet var lableCenterX: NSLayoutConstraint!
  // landscape
  @IBOutlet var labelLeadingLandScape: NSLayoutConstraint!
  @IBOutlet var lableCenterYLandScape: NSLayoutConstraint!
  
  
//MARK:- controller lyfecycle
  /***********************************************************************************************************
   <Name> viewDidLoad,viewWillAppear </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> Uiview controller delegate methods</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/16 </Date>
   </History>
   ***********************************************************************************************************/
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black
    methodToSetConstantprogramaticallyForIpadSizeClass()
   // Branch.getInstance().registerDeepLinkController(ViewControllerViewController forKey:"my-key")
    Branch.getInstance().registerDeepLinkController(self, forKey: "page")
      CloudId.newInstanceWithConfigAtUrl(Bundle.main.url(forResource: "cloudid-config-hotwirecommunications", withExtension: "json")!) {
        [weak self]
        (cloudId, error) in
        self?.cloudId = cloudId
        HotwireCommunicationApi.sharedInstance.cloudId = cloudId
      }
   //  configureViewProperty()
        // Do any additional setup after loading the view.
  //  createDeeplinkMethod()
    }
  override func viewWillAppear(_ animated: Bool) {
     self.navigationController?.navigationBar.isHidden = true
    viewUpdateContentOnBasesOfLanguage()
    addNotificationObserver()
    

  }
  /***********************************************************************************************************
   <Name> willRotateToInterfaceOrientation </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method call when Orientation changed</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
   </History>
   ***********************************************************************************************************/

  override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    methodToSetConstantprogramaticallyForIpadSizeClass()
    DispatchQueue.main.async {
      self.configureViewProperty()
    }
  }
  // 
  func methodToSetConstantprogramaticallyForIpadSizeClass(){
    if UIDevice.current.userInterfaceIdiom == .pad{
      if UIDevice.current.orientation.isLandscape  {
        print("Landscape")
        buttonBaseViewHeightPotrate.isActive = false
        buttonBaseViewCenterX.isActive = false
        buttonBaseViewWidthPotrate.isActive = false
        ButtonBaseViewTop.isActive = false
        pageControllerCenterXPotrate.isActive = false
        buttonBaseViewBottom.isActive = false
        LabelCenterY.constant = scrollView.bounds.height * 0.8
        lableCenterX.constant = scrollView.bounds.width * 0.5
        
        buttonBaseViewLeading.isActive = true
        buttonBaseViewHeight.isActive = true
        buttonBaseViewWidth.isActive = true
        buttonBaseViewCenter2Y.isActive = true
        pageControllerTop.isActive = true
        pageControlerCenterX.isActive = true
//        labelLeadingLandScape.isActive = true
//        lableCenterYLandScape.isActive = true
        
      } else {
        print("Portrait")
        buttonBaseViewLeading.isActive = false
        buttonBaseViewHeight.isActive = false
        buttonBaseViewWidth.isActive = false
        buttonBaseViewCenter2Y.isActive = false
        pageControllerTop.isActive = false
        pageControlerCenterX.isActive = false
      //  labelLeadingLandScape.isActive = false
      //  lableCenterYLandScape.isActive = false
        
        buttonBaseViewHeightPotrate.isActive = true
        buttonBaseViewCenterX.isActive = true
        buttonBaseViewWidthPotrate.isActive = true
        ButtonBaseViewTop.isActive = true
        pageControllerCenterXPotrate.isActive = true
        buttonBaseViewBottom.isActive = true
        LabelCenterY.constant = scrollView.bounds.height * 1
        lableCenterX.constant = scrollView.bounds.width * 0.8
      }
    }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //MARK:- Refresh view
  /***********************************************************************************************************
   <Name> viewUpdateContentOnBasesOfLanguage </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to update content on the bases of language</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
   </History>
   ***********************************************************************************************************/
  func viewUpdateContentOnBasesOfLanguage(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    btnSignUp.setTitle("SignUp".localized(lang: languageCode, comment: ""), for: .normal)
    btnLogin.setTitle("LogIn".localized(lang: languageCode, comment: ""), for: .normal)
   DispatchQueue.main.async {
      self.configureViewProperty()
    }
    }
  
  func isIPhone()->Bool{
   return UIDevice.current.userInterfaceIdiom == .phone
  }
  /***********************************************************************************************************
   <Name> configureViewProperty </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to set the view property</Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
   </History>
   ***********************************************************************************************************/
  func configureViewProperty(){
    languageCode = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    self.scrollViewBaseView.setNeedsLayout()
    self.scrollViewBaseView.layoutIfNeeded()
    let subviews = self.scrollView.subviews
    for subview in subviews{
      subview.removeFromSuperview()
    }
    btnLogin.layer.masksToBounds = true
  //  btnLogin.layer.borderColor = kColor_SignUpbutton.cgColor
 //   btnLogin.layer.borderWidth = 1.0
    pageControl.numberOfPages = kImageArrayPotrait.count
    let scrollViewWidth:CGFloat = self.view.frame.width
    let scrollViewHeight:CGFloat = self.scrollViewBaseView.frame.height
    let homeScreenImage = isIPhone() ? kImageArrayPotraitIPhone : kImageArrayPotrait
    for (Index,object) in homeScreenImage.enumerated(){
      if Index == 0 {
        let storyboard = UIStoryboard(name:mainStoryboard, bundle: nil)
        let pageControllerFirstScreen = storyboard.instantiateViewController(withIdentifier: "pageViewControlleFirst") as! PageControllerSubViewController
        let firstScreen:UIView = pageControllerFirstScreen.view
        firstScreen.frame = CGRect.init(0, 0, scrollViewWidth, scrollViewHeight)
        firstScreen.backgroundColor = UIColor.black
        pageControllerFirstScreen.lblWelcomeText.text = "WelcomeHotwire".localized(lang: languageCode, comment: "")
        if UIDevice.current.orientation.isLandscape {
          print("Landscape")
          if(isIPhone()){
           pageControllerFirstScreen.imageViewPicture.image = UIImage(named: kImageArrayLandScapeIPhone[Index])
          }else{
          pageControllerFirstScreen.imageViewPicture.image = UIImage(named: kImageArrayLandScape[Index])
          }
        } else {
          print("Portrait")
          pageControllerFirstScreen.imageViewPicture.image = UIImage(named:object)
        }
        self.scrollView.addSubview(firstScreen)
//      let imgOne = UIImageView(frame: CGRect(x:0 , y:0,width:scrollViewWidth, height:scrollViewHeight))
//      imgOne.image = UIImage(named:object)
//      self.scrollView.addSubview(imgOne)
        
      }
      else{
        let storyboard = UIStoryboard(name:mainStoryboard, bundle: nil)
        let pageControllerFirstScreen = storyboard.instantiateViewController(withIdentifier: "pageViewControlleSecond") as! PageControllerSecondViewController
        let firstScreen:UIView = pageControllerFirstScreen.view
        firstScreen.frame = CGRect(x: scrollViewWidth * CGFloat(Index), y:0,width:scrollViewWidth, height:scrollViewHeight)
        switch Index {
        case 1:
          firstScreen.backgroundColor = UIColor.black
          let heder = "BillingPayment".localized(lang: languageCode, comment: "")
          let body = "BillingPaymentInfo".localized(lang: languageCode, comment: "")
          print(heder)
          print(body)
          pageControllerFirstScreen.lblTitleText.text = "BillingPayment".localized(lang: languageCode, comment: "")
          pageControllerFirstScreen.lblpageInfoText.text = "BillingPaymentInfo".localized(lang: languageCode, comment: "")
        case 2:
          firstScreen.backgroundColor = UIColor.black
          pageControllerFirstScreen.lblTitleText.text = "Appointments".localized(lang: languageCode, comment: "")
          pageControllerFirstScreen.lblpageInfoText.text = "AppointmentsInfo".localized(lang: languageCode, comment: "")
         case 3:
          firstScreen.backgroundColor = UIColor.black
          pageControllerFirstScreen.lblTitleText.text = "TVServices".localized(lang: languageCode, comment: "")
          pageControllerFirstScreen.lblpageInfoText.text = "TVServicesInfo".localized(lang: languageCode, comment: "")
        case 4:
          firstScreen.backgroundColor = UIColor.black
          pageControllerFirstScreen.lblTitleText.text = "TroubleShooting".localized(lang: languageCode, comment: "")
          pageControllerFirstScreen.lblpageInfoText.text = "TroubleShootingInfo".localized(lang: languageCode, comment: "")
        default:
          firstScreen.backgroundColor = UIColor.black
          pageControllerFirstScreen.lblTitleText.text = "PushNotifications".localized(lang: languageCode, comment: "")
          pageControllerFirstScreen.lblpageInfoText.text = "PushNotificationsInfo".localized(lang: languageCode, comment: "")
        }
        if UIDevice.current.orientation.isLandscape {
          print("Landscape")
          if(isIPhone()){
            pageControllerFirstScreen.imageViewPicture.image = UIImage(named: kImageArrayLandScapeIPhone[Index])
          }else{
           pageControllerFirstScreen.imageViewPicture.image = UIImage(named: kImageArrayLandScape[Index])
          }
        } else {
          print("Portrait")
          if(isIPhone()){
          pageControllerFirstScreen.imageViewPicture.image = UIImage(named: kImageArrayPotraitIPhone[Index])
          }else{
           pageControllerFirstScreen.imageViewPicture.image = UIImage(named: kImageArrayPotrait[Index])
          }
        }
      
        self.scrollView.addSubview(firstScreen)
//      let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth * CGFloat(Index), y:0,width:scrollViewWidth, height:scrollViewHeight))
//        imgTwo.image = UIImage(named:object)
//        self.scrollView.addSubview(imgTwo)
      }
    }
    self.scrollView.contentSize = CGSize(width:scrollViewWidth * CGFloat(kImageArrayPotrait.count) , height:scrollViewHeight)
    self.scrollView.delegate = self
    self.scrollView.setContentOffset(CGPoint(x: scrollViewWidth * CGFloat(curentPage), y: 0), animated: true)
    self.pageControl.currentPage = curentPage
    self.pageControl.bringSubview(toFront: self.scrollViewBaseView)
  }
  
  //MARK:- ADD notification
  /***********************************************************************************************************
   <Name> addNotificationObserver </Name>
   <Input Type>    </Input Type>
   <Return> void </Return>
   <Purpose> method to call when aplication come to foreground and update selected languge </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
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
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }
// MARK: - ScrollView Deligate method
  /***********************************************************************************************************
   <Name> scrollViewDidEndDecelerating </Name>
   <Input Type> UIScrollView   </Input Type>
   <Return> void </Return>
   <Purpose> method to update the scrollview  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
   </History>
   ***********************************************************************************************************/
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
    let pageWidth:CGFloat = scrollView.frame.width
    let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
    // Change the indicator
    self.pageControl.currentPage = Int(currentPage);
    if Int(currentPage) != curentPage{
      curentPage = Int(currentPage)
    }else{
      curentPage = Int(currentPage)
    }
  }
  func scrollViewDidScroll(_ scrollView: UIScrollView){
    print("scrollViewDidScroll")
  }
//   func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
//    let pageWidth:CGFloat = scrollView.frame.width
//    let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
//    // Change the indicator
//    self.pageControl.currentPage = Int(currentPage);
//    if Int(currentPage) != curentPage{
//    curentPage = Int(currentPage)
//    }else{
//    curentPage = Int(currentPage)
//    }
//  }
  
   // MARK: - IB Action View controller
  /***********************************************************************************************************
   <Name> signUpButtonTappedAction </Name>
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method call when Sign up button tapped  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
   </History>
   ***********************************************************************************************************/
  
  @IBAction func signUpButtonTappedAction(_ sender: Any) {
    let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: kStoryBoardID_SignUpTermCondition)
    self.navigationController?.pushViewController(mainViewController, animated: true)
  }

    ////// root a navigation view controller
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
//    let navcontroller = storyboard.instantiateViewControllerWithIdentifier("signUpNavigation")
//    appDelegate.window?.rootViewController = navcontroller
 ////////// root a view controller
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let storyboard = UIStoryboard(name:kStoryBoardSignUp, bundle: nil)
//    let mainViewController = storyboard.instantiateViewControllerWithIdentifier(kSegue_SignUpTermCondition)
//    let nav:UINavigationController = UINavigationController(rootViewController:mainViewController)
//    appDelegate.window?.rootViewController = nav
  /***********************************************************************************************************
   <Name> logInButtonTappedAction </Name>
   <Input Type> AnyObject   </Input Type>
   <Return> void </Return>
   <Purpose> method call when Login button tapped  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
   </History>
   ***********************************************************************************************************/
  
  @IBAction func logInButtonTappedAction(_ sender: Any) {
    self.navigationController?.navigationBar.isHidden = true
    self.performSegue(withIdentifier: kSegue_LoginScreen, sender: self)
//    if loggedInUser != nil {
//      self.performSegue(withIdentifier: kSegue_TabBarController, sender: self)
//      return
//    }else{
//      self.performSegue(withIdentifier: kSegue_LoginScreen, sender: self)
//    }
    
  }
  private func cloudIdWasSet(cloudId: CloudId) {
    cloudId.delegate = self
    cloudId.checkKeychainWithCallback {
      (user, provider, error) in
       self.loggedInUser = user
     // self.refreshState()
    }
  }

    // MARK: - Navigation
  /***********************************************************************************************************
   <Name> prepareForSegue </Name>
   <Input Type> UIStoryboardSegue,AnyObject </Input Type>
   <Return> void </Return>
   <Purpose> method call when segue called  </Purpose>
   <History>
   <Header> Version 1.0 </Header>
   <Date>  22/09/15 </Date>
   </History>
   ***********************************************************************************************************/
    // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == kSegue_TabBarController,
        let destinationViewController = segue.destination as? TabBarViewController {
        destinationViewController.transitioningDelegate = self
        swipeInteractionController.wireToViewController(viewController: destinationViewController)
      }
    }
  ///// deep linking sample methods
  func createDeeplinkMethod(){
    let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
    branchUniversalObject.title = "My Content Title"
    branchUniversalObject.contentDescription = "My Content Description"
    branchUniversalObject.imageUrl = "https://example.com/mycontent-12345.png"
    branchUniversalObject.addMetadataKey("property1", value: "blue")
    branchUniversalObject.addMetadataKey("property2", value: "red")
   
    let linkProperties: BranchLinkProperties = BranchLinkProperties()
    linkProperties.feature = "sharing"
    linkProperties.channel = "facebook"
    linkProperties.addControlParam("$desktop_url", withValue: "http://example.com/home")
    linkProperties.addControlParam("$ios_url", withValue: "http://example.com/ios")
    
    branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
      if error == nil {
        print("got my Branch link to share: \(url)")
      }
    }

    branchUniversalObject.automaticallyListOnSpotlight = true
    branchUniversalObject.userCompletedAction(BNCRegisterViewEvent)
  }
}
extension HotWireFirstViewController: CloudIdDelegate {
  
  func cloudId(_ cloudId: CloudId, didLogInUser user: User, forProvider provider: Provider) {
    print("cloudId: \(cloudId), didLoginUser: \(user), forProvider: \(provider)")
  self.loggedInUser = user
  }
  
  func cloudId(_ cloudId: CloudId, keychainShouldSaveUser user: User, forProvider provider: Provider) -> Bool {
    return true
  }
  
  func cloudId(_ cloudId: CloudId, didEncounterError error: NSError) {
    print("error! :\(error)")
  }
}
