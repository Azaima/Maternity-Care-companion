//
//  DownArrowImage.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 11/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class DownArrowImage: UIImageView {

    required init(){
        
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        self.image = #imageLiteral(resourceName: "downArrow")
        
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
