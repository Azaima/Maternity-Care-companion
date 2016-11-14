//
//  FluidBalanceCell.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 09/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class FluidBalanceCell: UITableViewCell {

    
    @IBOutlet weak var timeLAbel: UILabel!
    @IBOutlet weak var volumeInTextField: UITextField!
    @IBOutlet weak var volumeOutTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
