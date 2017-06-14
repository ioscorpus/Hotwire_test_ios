//
//  NetworkAPIModel.swift
//  HotwireCommunications
//
//  Created by Dammu on 6/13/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class NetworkAPIModel: NSObject {
    
    static let shared = NetworkAPIModel()
    
    
    func dvr_postRecordingsAPICall(withCompletionHadler completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        let url = NSURL(string: Dvr_Base_URl + DVR_PAST_REC_Url)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
            
            completionHandler(data, response, error)
            
        }
        
        task.resume()
        
    }
    
    func dvr_spaceAPICall(withCompletionHadler completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        
        let Dvr_Base_URl : String = UserDefaults.standard.value(forKey: "GET_DVR_VALUE")! as! String
        let url = NSURL(string: Dvr_Base_URl + DVR_SPACE_Url)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue(UserDefaults.standard.value(forKey: "MDS_TOKEN_VALUE")! as! String, forHTTPHeaderField: "MDSToken")
        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data , response, error) -> Void in
            
            completionHandler(data, response, error)
            
        }
        
        task.resume()
        
    }
}
