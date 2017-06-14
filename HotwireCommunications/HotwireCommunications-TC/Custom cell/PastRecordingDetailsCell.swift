//
//  PastRecordingDetailIphoneCell.swift
//  HotwireCommunications
//
//  Created by Dev on 05/04/17.
//  Copyright © 2017 chetu. All rights reserved.
//

import UIKit

class PastRecordingDetailsCell: UITableViewCell  {
    
    
    @IBOutlet weak var pastInnerCollectionView: UICollectionView!

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var characterName: UILabel!
    
    @IBOutlet var subTittle: UILabel!

   
    @IBOutlet var recordedDate: UILabel!
    
    @IBOutlet var durationTime: UILabel!
  
    @IBOutlet var channelName: UILabel!
    
    @IBOutlet var discriptionLabel: UILabel!
    
    
    @IBOutlet var RecordedLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var channelLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    
}
