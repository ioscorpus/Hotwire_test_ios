//
//  PastRecdTableViewCell.swift
//  HotwireCommunications
//
//  Created by Dev on 07/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class PastRecdTableViewCell: UITableViewCell {
    

    @IBOutlet var channelImgView: UIImageView!
    @IBOutlet var tittleLabel: UILabel!
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var noOfRecordingLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var hdImgView: UIImageView!
    @IBOutlet var arrowImgView: UIImageView!
    @IBOutlet var recdImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.tittleLabel.text = "Akash"

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
