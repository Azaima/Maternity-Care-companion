//
//  VTEScoreCell.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 13/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class VTEScoreCell: UITableViewCell {

    var riskValue = 1
    var value = 0
    
    
    @IBOutlet weak var vteRiskLabel: UILabel!
    @IBOutlet weak var yesNoSegment: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func riskSelected(_ sender: Any) {
        if yesNoSegment.selectedSegmentIndex == 1 {
            value = riskValue
            
        }   else {
            value = 0
        }
        
        switch value {
        case 1:
            self.backgroundColor = UIColor.yellow
        case 2 , 3:
            self.backgroundColor = UIColor.orange
        case 4:
            self.backgroundColor = UIColor.red
        default:
            self.backgroundColor = UIColor.white
        }
    }

}
