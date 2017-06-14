//
//  TabHeaderCellTableViewCell.swift
//  HotwireCommunications
//
//  Created by Chetu-macmini-26 on 11/02/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class TabHeaderCellTableViewCell: UITableViewCell {

  @IBOutlet var cellBackgroundImage: UIImageView!
  @IBOutlet var titleLable: UILabel!
  @IBOutlet var centralButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
