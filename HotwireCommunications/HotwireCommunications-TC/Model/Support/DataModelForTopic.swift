//
//  DataModelForTopic.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 05/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import Foundation
class DataModelForSpecificTopic
{
  var id : String?
  var article_title : String?
  var article_content : String?
  var file_title : String?
  var file_path : String?
  init(article_title:String,article_content:String,id:String)
  {
    self.id = id
    self.article_title = article_title
    self.article_content = article_content
  }
  init(file_title:String,file_path:String,id:String)
  {
    self.id = id
    self.file_title = file_title
    self.file_path = file_path
  }
 
}
