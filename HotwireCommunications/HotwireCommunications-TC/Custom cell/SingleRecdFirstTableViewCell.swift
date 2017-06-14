//
//  SingleRecdFirstTableViewCell.swift
//  HotwireCommunications
//
//  Created by Dev on 13/06/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class SingleRecdFirstTableViewCell: UITableViewCell {
    
    
    @IBOutlet var channelImage: UIImageView!
    @IBOutlet var tittleLabel: UILabel!
    @IBOutlet var hdImageView: UIImageView!
    @IBOutlet var channelLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLaftLabel: UILabel!
    @IBOutlet var seasonLabel: UILabel!
    @IBOutlet var sigleImageView: UIImageView!
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var stopLabel: UILabel!
    @IBOutlet var recordedSeriesLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.recordingLabel.textColor = kColor_TabBarSelected
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
