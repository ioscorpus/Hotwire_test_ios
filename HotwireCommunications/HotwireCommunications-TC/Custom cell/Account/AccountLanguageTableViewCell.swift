//
//  AccountLanguageTableViewCell.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 03/03/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class AccountLanguageTableViewCell: UITableViewCell {

  @IBOutlet var mainLanguage: UILabel!
  
  @IBOutlet var selectionImage: UIImageView!
  @IBOutlet var languageInEnglish: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
