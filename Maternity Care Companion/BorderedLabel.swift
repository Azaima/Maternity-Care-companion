//
//  BorderedLabel.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 11/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class BorderedLabel: UILabel {

    required init(width: Int, height: Int, numberOfLines: Int, borderColor: CGColor, textColor: UIColor, text: String){
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.numberOfLines = numberOfLines
        self.layer.borderColor = borderColor
        self.textColor = textColor
        self.text = text
        
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
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
