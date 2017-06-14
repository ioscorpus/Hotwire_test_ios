//
//  AlamoFireConnectivity.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 23/11/16.
//  Copyright © 2016 chetu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class AlamoFireConnectivity: NSObject {
  
 class  func alamofireGetRequest(urlString:String, completion: @escaping (_ data: JSON?, _ error: NSError?)->Void){
    print(urlString)
   if  HotwireCommunicationApi.rechability!.isReachable == true {
    let headers = [
      "Authorization": UserDefaults.standard.object(forKey: kAccessToken) as? String != nil ? UserDefaults.standard.object(forKey: kTokenType) as! String + " " + (UserDefaults.standard.object(forKey: kAccessToken) as! String):"",
      "Content-Type": "application/json",
      //"username": UserDefaults.standard.object(forKey: kUserNameKey) as? String != nil ? UserDefaults.standard.object(forKey: kUserNameKey) as! String :""
    ]
    Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
      switch(response.result) {
      case .success(_):
        if let data = response.result.value{
          print(response.result.value!)
           let json = JSON(data)
          completion(json, nil)
        }
      case .failure(_):
        print(response.result.error!)
        completion(nil,response.result.error! as NSError?)
      }
    }
   }else{
    
    let languageCode:String = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
    let userInfo: [NSObject : AnyObject] =
      [
        NSLocalizedDescriptionKey as NSObject : "NoInternet".localized(lang: languageCode, comment: "") as AnyObject,
        NSLocalizedFailureReasonErrorKey as NSObject : "DeviceNotConnected".localized(lang: languageCode, comment: "") as AnyObject
        
    ]
    let rechabilityError:NSError = NSError(domain: "my.domain.error", code: 123, userInfo: userInfo)
    completion(nil, rechabilityError)
    }
  }
  
  
class  func alamofirePostRequest(param:[String:AnyObject], withUrlString urlString:String, completion: @escaping (_ data: JSON?, _ error: NSError?)->Void){
    print(urlString)
    if  HotwireCommunicationApi.rechability?.isReachable == true {
      var headers:[String:String]? = nil
      if(UserDefaults.standard.object(forKey: kAccessToken) != nil){
         headers = [
          "Authorization": UserDefaults.standard.object(forKey: kAccessToken) as? String != nil ? UserDefaults.standard.object(forKey: kTokenType) as! String + " " + (UserDefaults.standard.object(forKey: kAccessToken) as! String):"",
          "Content-Type": "application/json",
          //"username": UserDefaults.standard.object(forKey: kUserNameKey) as? String != nil ? UserDefaults.standard.object(forKey: kUserNameKey) as! String :""
        ]
      }
      Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON {  response in
        print(response.request as Any)
        print(response.response as Any)
        switch response.result {
        case .success:
          print("Validation Successful")
          if let json = response.result.value {
            print("JSON: \(json)")
            let jsonObject = JSON(json)
            // print(json)
            completion(jsonObject, nil)
          }
        case .failure(let error):
        completion(nil, error as NSError?)
        }
      }
    }else{
      let languageCode:String = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      let userInfo: [NSObject : AnyObject] =
        [
          NSLocalizedDescriptionKey as NSObject : "NoInternet".localized(lang: languageCode, comment: "") as AnyObject,
          NSLocalizedFailureReasonErrorKey as NSObject : "DeviceNotConnected".localized(lang: languageCode, comment: "") as AnyObject
          
      ]
      let rechabilityError:NSError = NSError(domain: "my.domain.error", code: 123, userInfo: userInfo)
      completion(nil, rechabilityError)
      
    }
  }
  
  class func uploadImageToServerWith(parameters:[String:String],image:UIImage,url:String,completionHandler: @escaping (_ data: JSON?, _ error: NSError?)->Void){
    Alamofire.upload(multipartFormData: { multipartFormData in
      let imgData = UIImageJPEGRepresentation(image, 0.2)
      multipartFormData.append(imgData!, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
      for (key, value) in parameters {
        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
      }
    },
                     to:url)
    { (result) in
      switch result {
      case .success(let upload, _, _):
        
        upload.uploadProgress(closure: { (progress) in
          print("Upload Progress: \(progress.fractionCompleted)")
        })
        
        upload.responseJSON { response in
          print(response.result.value ?? "")
          if let json = response.result.value {
            print("JSON: \(json)")
            let jsonObject = JSON(json)
            // print(json)
            completionHandler(jsonObject, nil)
          }

        }
        
      case .failure(let encodingError):
        print(encodingError)
      }
    }
  }
  class  func alamofirePutRequest(param:[String:AnyObject], withUrlString urlString:String, completion: @escaping (_ data: JSON?, _ error: NSError?)->Void){
    print(urlString)
    if  HotwireCommunicationApi.rechability?.isReachable == true {
      var headers:[String:String]? = nil
      if(UserDefaults.standard.object(forKey: kAccessToken) != nil){
       headers = [
        "Authorization": UserDefaults.standard.object(forKey: kAccessToken) as? String != nil ? UserDefaults.standard.object(forKey: kTokenType) as! String + " " + (UserDefaults.standard.object(forKey: kAccessToken) as! String):"",
        "Content-Type": "application/json",
        //"username": UserDefaults.standard.object(forKey: kUserNameKey) as? String != nil ? UserDefaults.standard.object(forKey: kUserNameKey) as! String :""
      ]
      }
      Alamofire.request(urlString, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON {  response in
        print(response.request as Any)
        print(response.response as Any)
        switch response.result {
        case .success:
          print("Validation Successful")
          if let json = response.result.value {
            print("JSON: \(json)")
            let jsonObject = JSON(json)
            // print(json)
            completion(jsonObject, nil)
          }
        case .failure(let error):
          completion(nil, error as NSError?)
        }
      }
    }else{
      let languageCode:String = LanguageManager.sharedInstance.DEFAULTS_KEY_LANGUAGE_CODE as String
      let userInfo: [NSObject : AnyObject] =
        [
          NSLocalizedDescriptionKey as NSObject : "NoInternet".localized(lang: languageCode, comment: "") as AnyObject,
          NSLocalizedFailureReasonErrorKey as NSObject : "DeviceNotConnected".localized(lang: languageCode, comment: "") as AnyObject
          
      ]
      let rechabilityError:NSError = NSError(domain: "my.domain.error", code: 123, userInfo: userInfo)
      completion(nil, rechabilityError)
      
    }
  }

  class func loadImageUsingAlamofireWith(url:String,completion:@escaping(DataResponse<UIImage>)->Void){
    Alamofire.request(url).responseImage { response in
      debugPrint(response)
      
     completion(response)
    }
  }
}
