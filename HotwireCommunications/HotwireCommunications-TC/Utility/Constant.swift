//
//  Costant.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 09/09/16.
//  Copyright © 2016 Hotwire Communications. All rights reserved.
//

import Foundation
import UIKit


// DVR URL Corpus //



let DVR_Base_Url = "http://8.19.233.211/"
let EXT_DVR_URL = "remotedvrapi/api/Token/662883c0-7df5-4244-8598-b61484aa75ad"


// ***   Live URl   ***//

//    let DAD_DVR_Base_Url = "http://10.72.5.191/"                //remotedvrapi/api/Token/662883c0-7df5-4244-8598-b61484aa75ad - Dad
//    let FAMILY_DVR_Base_Url = "http://170.250.29.171:9810/"      //remotedvrapi/api/Token/886a4baa-20f0-42c5-80fa-b2e4c7ba54f7--family
//    let LIVING_DVR_Base_Url = "http://10.72.5.191/"             //remotedvrapi/api/Token/6328d271-e6c8-49ee-938f-3a6fb1885cbf   -lving
//
//    let EXT_DAD_DVR_URL = "remotedvrapi/api/Token/662883c0-7df5-4244-8598-b61484aa75ad"
//    let EXT_FAMILY_DVR_URL = "remotedvrapi/api/Token/886a4baa-20f0-42c5-80fa-b2e4c7ba54f7"
//    let EXT_LIVING_DVR_URL = "remotedvrapi/api/Token/6328d271-e6c8-49ee-938f-3a6fb1885cbf"

// ****************** //


// ***   DEMO URl   ***//

    let DAD_DVR_Base_Url = "http://8.19.233.211/"               //http://8.19.233.211/remotedvrapi/api/Token/662883c0-7df5-4244-8598-b61484aa75ad
    let FAMILY_DVR_Base_Url = "http://8.19.233.211/"
    let LIVING_DVR_Base_Url = "http://8.19.233.211/"

    let EXT_DAD_DVR_URL = "remotedvrapi/api/Token/33CDDBD1-1F81-4090-A01A-FB6CFFFE496B"                // 33CDDBD1-1F81-4090-A01A-FB6CFFFE496B
    let EXT_FAMILY_DVR_URL = "remotedvrapi/api/Token/33CDDBD1-1F81-4090-A01A-FB6CFFFE496B"             // 662883c0-7df5-4244-8598-b61484aa75ad
    let EXT_LIVING_DVR_URL = "remotedvrapi/api/Token/33CDDBD1-1F81-4090-A01A-FB6CFFFE496B"

// ****************** //


let DVR_SPACE_Url = "remotedvrapi/api/StorageInfo"
let DVR_PAST_REC_Url = "remotedvrapi/api/RecordedRecordingsGroup"
let DVR_SERIES_REC_Url = "remotedvrapi/api/Series"
let DVR_SERIES_DELETE_URL = "remotedvrapi/api/Series/"
let DVR_SCHEDUEL_REC_Url = "remotedvrapi/api/Scheduled?$orderby=StartUtc"
let DVR_EPG_URL = "remotedvrapi/api/channelmap?$filter=(IsRecordable eq 'true')&$orderby=ChannelNumber&$top=100"
let DVR_EPG_TIME_Url_1 = "remotedvrapi/api/Schedules?"
let DVR_EPG_TIME_Url_2 = "startUtc=2017-05-04T2:00:00Z&endUtc=2017-05-04T3:00:00Z"
let DVR_EPG_PRO_TAP_Url = "remotedvrapi/api/Program?programId="


//"http://8.19.233.211/remotedvrapi/api/Schedules?sid=53850&sid=54058&sid=53956&sid=53960&sid=53547&sid=53989&sid=53989&sid=53989&sid=53989&sid=54006&startUtc=2017-05-04T2:00:00Z&endUtc=2017-05-04T3:00:00Z"

///////////////////


// URl for web service
//let kBaseUrl = "https://api.hwctesting.com/v1/"
// Dev Build
let kBaseUrl = "https://api.hwcdev.com/v1/"
// Beta test build


//let  kBaseUrl = "https://api.hwctesting.com/v1/"
let kCheckFirstTimeLoginStatus = "Firstlogin/get_account_status_by_username"
let kSendFirstTimeLoginOTPtoEmail = "Firstlogin/send_otp_to_email"
let kVerifyFirstTimeLoginOTPtoEmail = "Firstlogin/verify_email_by_otp"
let kSendFirstTimeLoginOTPtoMobile = "Firstlogin/send_otp_by_sms"
let kVerifyFirstTimeLoginOTPtoMobile = "Firstlogin/verify_otp_by_phone"
let kPushNotificationAcceptURL = "Firstlogin/turn_on_push_notification"
let kPushNotificationRejectedURL = "Firstlogin/turn_off_push_notification"

let kValidate_Invitation_Code = "register/invitation_by_code/"
//"register/validate_invitation_code/";
let kValidate_Customer_Number = "register/validate_customer_number"///user_by_customer_number"//"register/validate_customer_number/";
let kValidate_Create_user = "register/create_user";
let kValidate_Phone_Number =  "user/contact/validate/phone"; // post
//let kValidate_Phone_Number = "validate/phone/";// get
let kValidate_Email_Number = "user/contact/validate/email" // post
//let kValidate_Email_Number = "validate/email/"; // get
let kVerify_Phone_Number = "user/contact/verify/send/";
let kVerify_Phone_Otp = "user/contact/verify/phone/"
let kVerify_Email_Otp = "user/contact/verify/email/"
//let kTermsOfService = "contract/terms_of_service/"
//let kPrivacyPolicy = "contract/privacy_policy/"
let kPrivacyPolicy = "contract/retrieve/PP/"
let kTermsOfService = "contract/retrieve/TOS/"
// recoverUser
let kRecoverUserNameByPhoneNo = "username_recovery_by_sms"
let kRecoverUserNameByEmail = "username_recovery_by_email"
let kPassword_reset_by_mobile = "password_reset_by_mobile"
let kPassword_reset_by_email = "password_reset_by_email"
let kVerify_email_by_otp = "verify_email_by_otp"
let kVerify_phone_by_otp  = "verify_phone_by_otp"
let kLoginUser  = "login/login"
let kUpdatePassword  = "login/password_change"
let kResetPassword = "Login/reset_password"
//Account section api

let kFetchLanguages  = "Contract/language_list"
let kUpdateLanguages  = "Account/update_user_language"
let kUpdateProfilePic = "Account/store_user_profile_image"
let kUpdateUserName  = "Account/update_user_language"
let kUpdateUserNameByUser = "Account/update_username_for_user"
let kUpdateEmailByUser = "Account/update_email_by_username"
let kUpdateMobileByUser = "Account/update_phone_and_send_otp"
//User Detail Account

let kGetUserDetail = "Account/default_user_profile_data"
let kPDFUrl = "https://gethotwired.com/pdf/BillExplained.pdf"
let kUpdateUserFirstLastName = "Account/update_name_by_username"
let kHeaderHeight = 140
let kSectionHeight = 38
let kRowHeight = 50

var currentViewSize = CGSize(0, 0)
//Support Tab Api key's

let kFaqTopic = "Support/get_topics_for_faq"
let kFaqTopicDetail = "Support/get_article_and_files/"
let kgetAccountManagerInfo = "Support/get_account_manager_info"
let kGetContactUsList = "Support/get_contact_us_list"
let KSendMessage = "Support/store_user_help_request_and_notify_user"

//TV Tab ChannelLineUp
let KGetChannelLineUpPackage = "ChannelLineup/get_packages"
let KGetChannelList = "ChannelLineup/get_channels"

//User Information storage keys

let kIsForgot = "isForgot"
let kEmail = "email"
let kAddress1 = "address_line1"
let kAddress2 = "address_line2"
let kEmailVerified = "email_verified"
let kFirstName = "first_name"
let kLastName = "last_name"
let kiSOCode = "iso_code"
let kUserLanguage = "language"
let kLastLoginTime = "last_login_time"
let kMobileNumber = "mobile_number"
let kMobileNumberVerified = "mobile_verified"
let kPPAccepted = "pp_accepted"
let kTOSAccepted = "tos_accepted"
let kCommunityName = "community_Name"
let kProfilePicName = "profile_pic_name"
let kNotificationEnable = "push_notification_enabled"
let kUserNameKey = "username"
let kUserId = "userid"
let kAccessToken = "access_token"
let kTokenType = "token_type"
let kLanguageKey = "languageName"

enum UrlEndPoints:String {
  case Register = "register/"
  case Login = "login/"
}
enum Format:String {
  case xml  = "/format/xml"
  case json  = "/format/json"
  case generic  = "/format/generic"
}
enum ErrorCode:Int {
  case AlreadyUseCredential  = 4500//112
  case InvalidUseCredential  = 4310
}

//Session Expired Message
let kSessionMessage = "Session expired#Your session has beed expired please login again."
// StoryBoard name
let kStoryBoardMain = "Main";
let kStoryBoardSignUp = "SignUp";

//Corpus
var kColor_DVRSpacebackground = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0);
var INTERNT_TITLE_POPUP_STR = "NO Internet Connection"
var INTERNET_MESSAGE_POPUP_STR = "Please check your internet connection."
var SERVER_NOT_RESPOND_MESSAGE_STR = "Error"
var SERVER_NOT_RESPOND_TITLE_STR = "Server not responding."

// HelpLineNumber
var khelpLineNumber = "(555)5555555";
// tab bar controller color

var kColor_NavigationBarColor = UIColor(red: 50/255, green: 60/255, blue: 68/255, alpha: 1);
var kColor_TabBarSelected = UIColor(red: 238/255, green: 69/255, blue: 86/255, alpha: 1);
var kColor_TabBarBackgroundColor = UIColor(red: 0/255, green: 162/255, blue: 252/255, alpha: 1);
var kColor_LineBorderColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1);
var kColor_HighLightColor = UIColor(red: 39/255, green: 138/255, blue: 255/255, alpha: 1);
var kColor_SignUpbutton = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1);
var kColor_continueSelected = UIColor(red: 238/255, green: 69/255, blue: 86/255, alpha: 1);
var kAlreadyhaveAccount = UIColor(red: 46/255, green: 57/255, blue: 66/255, alpha: 1);
  //UIColor(red: 22/255, green: 122/255, blue: 255/255, alpha: 1);
var kColor_continueUnselected = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1);
var kColor_ToolBarUnselected = UIColor(red: 221/255, green: 225/255, blue: 231/255, alpha: 1);
var kColor_ContinuteUnselected = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1);
var kColor_LogoutButton = UIColor(red: 69/255, green: 140/255, blue: 255/255, alpha: 1);
//page controllerm screen
var kColor_GrayColor = UIColor(red: 74/255, green: 82/255, blue: 90/255, alpha: 1)
var kColor_GreenColor = UIColor(red: 52/255, green: 100/255, blue: 07/255, alpha: 1);
var kColor_Bluecolor = UIColor(red: 16/255, green: 68/255, blue: 120/255, alpha: 1);
var kColor_OrangeColor = UIColor(red: 195/255, green: 70/255, blue: 37/255, alpha: 1);
var kColor_PurpleColor = UIColor(red: 125/255, green: 30/255, blue: 193/255, alpha: 1);
var kColor_YellowColor = UIColor(red: 217/255, green: 142/255, blue: 10/255, alpha: 1);
var kColor_LinkBlue = UIColor(red: 3/255, green: 124/255, blue: 255/255, alpha: 1);

var kColor_weakPassword = UIColor(red: 214/255, green: 1/255, blue: 31/255, alpha: 1);
var kColor_justOkPassword = UIColor(red: 250/255, green: 165/255, blue: 57/255, alpha: 1);
var kColor_goodPassword = UIColor(red: 160/255, green: 187/255, blue: 135/255, alpha: 1);
var kColor_greatPassword = UIColor(red: 73/255, green: 174/255, blue: 41/255, alpha: 1);
// ViewController Story board ID
let kStoryBoardID_FirsScreen = "firstScreen";
let kStoryBoardID_SignUpSelection = "signUpSelection";
let kStoryBoardID_EmailVarification = "EmailVarification";
let kStoryBoardID_PhoneNoVarification = "PhoneNoVarification";
let kStoryBoardID_PhoneVerification = "verifyPhone";
let kStoryBoardID_ConfirmPhoneNumber = "confirmPhoneNumber";
let kStoryBoardID_PushNotification = "pushNotification";
let kStoryBoardID_TermsNCondition = "TermsNConditionTableViewController";
let kStoryBoardID_SignUpTermCondition = "SignUpTermCondition";
let kStoryBoardID_emailVarification = "LoginEmailVarify"
let kStoryBoardID_LoginPage = "LoginPage";
let kStoryBoardID_ForgotLogin = "ForgotLogin";
let kStoryBoardID_CustomLaunch = "CustomSplashViewCellViewController";
// segue identifier
let kSegue_CustomerNumber = "customerNumber";
let kSegue_InstallationCode = "invitationCode";
let kSegue_SignUpNameEntry = "SignUpNameEntry";
let kSegue_LoginScreen = "LoginScreen";

let kSegue_TabBarController = "TabBarController";
let kSegue_TermAndConditon = "TermAndCondition";
let kSegue_chooseSignUpMethod = "chooseSignUpMethod";
let kSegue_EnterMobNumber = "EnterMobNumber";
let kSegue_EnterEmailId = "enterEmailID";
let kSegue_UpdatePassword = "UpdatePassword";
let kSegue_EnterPassword = "EnterPassword";
let kSegue_SecurityPin = "SecurityPin";
let kSegue_SecurityQuestion = "SecurityQuestion";
let kSegue_SecurityAns = "securityAns";
let kSegue_WelcomeScreen = "WelcomeScreen";
let kSegue_PushNotificationActivation = "ActivatePushNotification";
let kSegue_PushPasswordHelp = "pushPasswordHelp";
let kSegue_VarificationPhoneNo = "VarificationPhoneNo";
let kSegue_VarificationEmailAddress = "VarificationEmailAddress";
let kSegue_UserVarificationtermAndConditon = "TermAndCondition";
let kSegue_AccoutSetup = "AccoutSetup";
let kSegue_SetUpEmail = "SetUpEmail";
let kSegue_VerifyMobileNumber = "verifyMobileNumber";
let kSegue_LoginEmailVarification = "LoginEmailVarification";
let kSegue_ForgotLogin = "ForgotLogin";
let kSegue_RecoveryOption = "RecoveryOption";
let kSegue_ResetEmail = "ResetEmail";

let kSegue_TabBarBaseView = "TabBarBaseView";
// Account Connection
let kSegue_AccountInfoScreen = "AccountInfo"
let kSegue_SignInAndSecurity = "SignInAndSecurity"
let kSegue_BillingInfo = "BillingInfo"
let kSegue_ContactInfo = "ContactInfo"
let kSegue_FamilyMember = "FamilyMember"
let kSegue_Notification = "Notification"
// Account Info
let kSegue_CurrentBalance = "CurrentBalance"
let kSegue_PayBill = "PayBill"
let kSegue_PayDiffrent = "PayDiffrent"
let kSegue_UnderStandingBill = "understandingBill_segue"
let kSegue_FAQWebView = "television_segue"

//Language selection screen cells
let kCellIdentifier_LanguageChoice = "languageChoiceCell";
let kCellIdentifier_LanguageIntroWithButon = "languageIntroAndButtoncell";
let kSegue_LanguageScreen = "LanguageList";
// tableview custom cell identifier
let kCellIdentifier_TermAndCondHeader = "termAndCondHeader";
let kCellIdentifier_TermAndCondRegular = "termAndCondRegular";
let kCellIdentifier_SecurityQues = "SecurityQues";
let kCellIdentifier_SecurityHeader = "SecurityHeader" ;
// forgot login
let kCellIdentifier_ForgotLoginHeader = "ForgotLoginHeader"
let kCellIdentifier_ForgotLoginFooter = "ForgotLoginFooter"

//Support Tab
let KTelevision = "Television"
let KAccountManagerSegue = "AccountManagerSegue"
let KAccountManagerHelpSegue = "AccountManagerHelpSegue"
let KContactAccManagerSegue = "ContactAccManagerSegue"


//Support Tab 
//AccountManagerHelpViewController TableView Cell identifier

let KAccountManagerHelp_Cell = "AccountManagerHelp_Cell"


//TV Tab
let KTV_ChannelLineUpSegue = "TV_ChannelLineUpSegue"
let KTV_ChannelTypeSegue = "TV_ChannelTypeSegue"
let KTV_AdditionalChannelListSegue = "TV_AdditionalChannelListSegue"

// First Screen Image Array 
let kImageArrayPotrait = ["obStartBg","obBillingPaymentBg","obAppointmentsBg","obTvservicesBg","obTroubleShootBg","obPushNotificationsBg"];
let kImageArrayPotraitIPhone = ["obStartBgIPhone","obBillingPaymentBgIPhone","obAppointmentsBgIPhone","obTvservicesBgIPhone","obTroubleShootBgIPhone","obPushNotificationsBgIPhone"];
 let kImageArrayLandScape = ["Mainscreenlandscape","Billingpaymentlandscape","Appointmentslandscape","Tvserviceslandscape","Troubleshootlandscape","Notificationslandscape"];
let kImageArrayLandScapeIPhone = ["imgOnboardingMainlandscapeIPhone","imgOnboardingBillingpaymentlandscapeIPhone","imgOnboardingAppointmentslandscapeIPhone","imgOnboardingTvserviceslandscapeIPhone","imgOnboardingTroubleshootlandscapeIPhone","imgOnboardingNotificationslandscapeIPhone"];
let kSecurityQuesList = ["FavoritePlaceToVisit","BestFriendName","FavoriteActor/Actress","MascotFavoriteSportsTeam","MotherMaidenName","NameFirstPet","YourNickname"];
let recoverUsername = ["MobilePhone","Email"];
let resetPassword = ["MobilePhone","Email"]//,"CustomerNumber"];

//Support Tab AccountManager.
var msa_id = ""


// Static frame size 

let kFrame_BarlogoIconSize = CGRect.init(0, 5, 70, 30);
let KFrame_CancelBarbutton = CGRect.init(0, 0, 60, 30);
let KFrame_DoneBarbutton = CGRect.init(0, 0, 60, 30);

let KFrame_Toolbar = CGRect.init(0, 0, 60, 50)
let KFrame_SubmitToolbar = CGRect.init(0, 0, 70, 50)
let KFrame_Submit = CGRect.init(0, 0, 70, 50)
// back button edge
let imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
let titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
// UIFont size
let kFontStyleSemiBold22 = UIFont(name: "SFUIDisplay-Semibold", size: 22);
let kFontStyleSemiBold20 = UIFont(name: "SFUIDisplay-Semibold", size: 20);
let kFontStyleSemiBold18 = UIFont(name: "SFUIDisplay-Semibold", size: 18);
let kFontStyleSemiRegular22 = UIFont(name: "SFUIDisplay-Regular", size: 22);
let kFontStyleSemiRegular20 = UIFont(name: "SFUIDisplay-Regular", size: 20);
let kFontStyleSemiRegular18 = UIFont(name: "SFUIDisplay-Regular", size: 18);
let kFontStyleSemiRegular16 = UIFont(name: "SFUIDisplay-Regular", size: 16);

