//
//  ModelSupport.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 03/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//
//
import Foundation

class DataModelForSelectTopic
{
  var topicName : String?
  var topicId : String?
		
  var articleCount : String?
  var displayOrder : String?
  
  init(topicName:String, topicId:String, articleCount:String,displayOrder:String)
  {
    self.topicName = topicName
    self.topicId = topicId
    self.articleCount = articleCount
    self.displayOrder = displayOrder
  }
  
  
}
