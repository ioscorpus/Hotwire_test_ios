//
//  SingleRecdSecondTableViewCell.swift
//  HotwireCommunications
//
//  Created by Dev on 13/06/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class SingleRecdSecondTableViewCell: UITableViewCell {
    
    
    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var forthLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.segmentController.backgroundColor = UIColor.white
        self.segmentController.tintColor = kColor_TabBarSelected
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
